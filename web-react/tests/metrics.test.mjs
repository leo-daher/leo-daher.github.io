import { test } from "node:test";
import assert from "node:assert/strict";
import { DatabaseSync } from "node:sqlite";
import { readFileSync } from "node:fs";
import {
  datesBetween,
  queryDay,
  readSnapshot,
  synchronizeMetrics,
} from "../../services/recomp-metrics/metrics.mjs";
import worker from "../../services/recomp-metrics/worker.mjs";
import initial from "../src/data/recomp-metrics.snapshot.json" with { type: "json" };
import {
  isMetricsSnapshot,
  newerSnapshot,
} from "../src/data/recomp-metrics.js";

test("deployment configuration is readable by the initial collector", () => {
  const config = JSON.parse(
    readFileSync(
      new URL("../../services/recomp-metrics/wrangler.json", import.meta.url),
      "utf8",
    ),
  );
  assert.ok(config.vars.CLOUDFLARE_ZONE_ID);
  assert.ok(
    config.d1_databases.find((database) => database.binding === "DB")
      ?.database_id,
  );
  assert.deepEqual(
    datesBetween(
      config.vars.METRICS_START_DATE,
      new Date("2026-10-01T12:00:00Z"),
    ),
    ["2026-10-01"],
  );
});

function database() {
  const sqlite = new DatabaseSync(":memory:");
  sqlite.exec(
    readFileSync(
      new URL(
        "../../services/recomp-metrics/migrations/0001_daily_metrics.sql",
        import.meta.url,
      ),
      "utf8",
    ),
  );
  function prepare(sql, params = []) {
    return {
      bind(...values) {
        return prepare(sql, values);
      },
      async all() {
        return { results: sqlite.prepare(sql).all(...params) };
      },
      async first() {
        return sqlite.prepare(sql).get(...params) ?? null;
      },
      async run() {
        return sqlite.prepare(sql).run(...params);
      },
    };
  }
  return {
    prepare,
    async batch(statements) {
      sqlite.exec("BEGIN");
      try {
        for (const statement of statements) await statement.run();
        sqlite.exec("COMMIT");
      } catch (error) {
        sqlite.exec("ROLLBACK");
        throw error;
      }
    },
  };
}
const environment = () => ({
  DB: database(),
  ANALYTICS_API_TOKEN: "test-private-token",
  CLOUDFLARE_ZONE_ID: "test-zone",
  METRICS_START_DATE: "2026-10-01",
});
function source(requests = 100, visits = 10) {
  return async (url, options) => {
    assert.equal(url, "https://api.cloudflare.com/client/v4/graphql");
    assert.equal(options.headers.Authorization, "Bearer test-private-token");
    return Response.json({
      data: {
        viewer: {
          zones: [
            {
              httpRequestsAdaptiveGroups: [
                { count: requests, sum: { visits } },
              ],
            },
          ],
        },
      },
    });
  };
}

test("repeated collection replaces daily totals and accepts source corrections", async () => {
  const env = environment();
  const now = new Date("2026-10-03T12:00:00Z");
  await synchronizeMetrics(env, now, source());
  assert.deepEqual((await readSnapshot(env)).metrics, {
    visits: 30,
    requests: 300,
  });
  await synchronizeMetrics(env, now, source());
  assert.deepEqual((await readSnapshot(env)).metrics, {
    visits: 30,
    requests: 300,
  });
  await synchronizeMetrics(
    env,
    new Date("2026-10-03T13:00:00Z"),
    source(90, 9),
  );
  assert.deepEqual((await readSnapshot(env)).metrics, {
    visits: 27,
    requests: 270,
  });
});

test("historical days survive later updates and only recent dates are re-read", async () => {
  const env = environment();
  await synchronizeMetrics(env, new Date("2026-10-03T12:00:00Z"), source());
  const fetched = [];
  await synchronizeMetrics(
    env,
    new Date("2026-10-05T12:00:00Z"),
    async (url, options) => {
      fetched.push(JSON.parse(options.body).variables.start.slice(0, 10));
      return source(200, 20)(url, options);
    },
  );
  assert.deepEqual(fetched, ["2026-10-03", "2026-10-04", "2026-10-05"]);
  assert.deepEqual((await readSnapshot(env)).metrics, {
    visits: 80,
    requests: 800,
  });
});

test("errors and unavailable history preserve the last published observation", async () => {
  const env = environment();
  await synchronizeMetrics(env, new Date("2026-10-03T12:00:00Z"), source());
  const previous = await readSnapshot(env);
  await assert.rejects(
    synchronizeMetrics(env, new Date("2026-10-03T13:00:00Z"), async () =>
      Response.json({ errors: [{ message: "private provider response" }] }),
    ),
    /source_query_failed/,
  );
  assert.deepEqual(await readSnapshot(env), previous);
  await assert.rejects(
    synchronizeMetrics(env, new Date("2026-12-01T13:00:00Z"), source()),
    /history_gap_outside_retention/,
  );
  assert.deepEqual(await readSnapshot(env), previous);
});

test("partial or invalid upstream data never becomes a zero-count update", async () => {
  for (const body of [
    { data: { viewer: { zones: [] } } },
    { data: { viewer: { zones: [{ httpRequestsAdaptiveGroups: null }] } } },
    {
      data: {
        viewer: {
          zones: [
            { httpRequestsAdaptiveGroups: [{ count: -1, sum: { visits: 5 } }] },
          ],
        },
      },
    },
  ]) {
    await assert.rejects(
      queryDay(environment(), "2026-10-02", new Date("2026-10-03"), async () =>
        Response.json(body),
      ),
    );
  }
  const noEvents = await queryDay(
    environment(),
    "2026-10-02",
    new Date("2026-10-03"),
    async () =>
      Response.json({
        data: { viewer: { zones: [{ httpRequestsAdaptiveGroups: [] }] } },
      }),
  );
  assert.deepEqual(noEvents, { date: "2026-10-02", requests: 0, visits: 0 });
});

test("UTC boundaries do not overlap and current-day requests end at collection time", async () => {
  const now = new Date("2026-10-03T00:30:00Z");
  assert.deepEqual(datesBetween("2026-10-01", now), [
    "2026-10-01",
    "2026-10-02",
    "2026-10-03",
  ]);
  let variables;
  await queryDay(environment(), "2026-10-03", now, async (url, options) => {
    variables = JSON.parse(options.body).variables;
    return source()(url, options);
  });
  assert.equal(variables.start, "2026-10-03T00:00:00.000Z");
  assert.equal(variables.end, "2026-10-03T00:30:00.000Z");
});

test("public endpoint exposes only aggregates and has no unauthenticated write route", async () => {
  const env = environment();
  await synchronizeMetrics(env, new Date("2026-10-03T12:00:00Z"), source());
  const response = await worker.fetch(
    new Request("https://metrics.test/metrics"),
    env,
  );
  assert.equal(response.status, 200);
  assert.equal(response.headers.get("Access-Control-Allow-Origin"), "*");
  const text = await response.text();
  assert.ok(!text.includes("test-private-token"));
  assert.ok(!text.includes("test-zone"));
  assert.ok(isMetricsSnapshot(JSON.parse(text)));
  assert.equal(
    (
      await worker.fetch(
        new Request("https://metrics.test/metrics", { method: "POST" }),
        env,
      )
    ).status,
    405,
  );
  assert.equal(
    (
      await worker.fetch(
        new Request("https://metrics.test/sync", { method: "POST" }),
        env,
      )
    ).status,
    404,
  );
});

test("missing credentials keep the dated fallback without pretending collection succeeded", async () => {
  const env = environment();
  delete env.ANALYTICS_API_TOKEN;
  assert.deepEqual(await synchronizeMetrics(env), {
    updated: false,
    reason: "missing_analytics_token",
  });
  assert.deepEqual(await readSnapshot(env), initial);
});

test("browser rejects incomplete, stale or mislabelled payloads but accepts lower corrected counts", () => {
  assert.ok(isMetricsSnapshot(initial));
  assert.strictEqual(
    newerSnapshot(initial, { ...initial, coverageComplete: false }),
    initial,
  );
  assert.strictEqual(
    newerSnapshot(initial, { ...initial, asOf: "2020-01-01" }),
    initial,
  );
  assert.strictEqual(
    newerSnapshot(initial, {
      ...initial,
      metrics: { visits: null, requests: 10 },
    }),
    initial,
  );
  const corrected = {
    ...initial,
    asOf: "2026-10-28T12:00:00Z",
    metrics: { visits: 2400, requests: 44000 },
  };
  assert.strictEqual(newerSnapshot(initial, corrected), corrected);
});
