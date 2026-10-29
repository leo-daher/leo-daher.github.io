import initialSnapshot from "../../web-react/src/data/recomp-metrics.snapshot.json" with { type: "json" };
import { isMetricsSnapshot } from "../../web-react/src/data/recomp-metrics.js";

const DAY = 86_400_000;
const graphEndpoint = "https://api.cloudflare.com/client/v4/graphql";
const query = `query PortfolioMetrics($zone: string, $start: Time, $end: Time) {
  viewer {
    zones(filter: {zoneTag: $zone}) {
      httpRequestsAdaptiveGroups(limit: 1, filter: {
        datetime_geq: $start, datetime_lt: $end, requestSource: "eyeball"
      }) { count sum { visits } }
    }
  }
}`;

const dayKey = (time) => new Date(time).toISOString().slice(0, 10);

export function datesBetween(start, end) {
  const first = Date.parse(start);
  const last = Date.parse(dayKey(end));
  if (!Number.isFinite(first) || first > last)
    throw new Error("invalid_start_date");
  const days = [];
  for (let time = first; time <= last; time += DAY) days.push(dayKey(time));
  return days;
}

function count(value) {
  if (typeof value !== "number" || !Number.isFinite(value) || value < 0)
    throw new Error("invalid_source_count");
  const rounded = Math.round(value);
  if (!Number.isSafeInteger(rounded)) throw new Error("invalid_source_count");
  return rounded;
}

export async function queryDay(env, date, now, fetcher = fetch) {
  const start = `${date}T00:00:00.000Z`;
  const end = new Date(
    Math.min(Date.parse(start) + DAY, now.getTime()),
  ).toISOString();
  if (end <= start) return { date, requests: 0, visits: 0 };
  const response = await fetcher(graphEndpoint, {
    method: "POST",
    headers: {
      Authorization: `Bearer ${env.ANALYTICS_API_TOKEN}`,
      "Content-Type": "application/json",
    },
    signal: AbortSignal.timeout(20_000),
    body: JSON.stringify({
      query,
      variables: { zone: env.CLOUDFLARE_ZONE_ID, start, end },
    }),
  });
  if (!response.ok) throw new Error(`source_http_${response.status}`);
  const body = await response.json();
  if (body.errors?.length) throw new Error("source_query_failed");
  const zones = body.data?.viewer?.zones;
  if (!Array.isArray(zones) || zones.length !== 1)
    throw new Error("source_zone_unavailable");
  const groups = zones[0].httpRequestsAdaptiveGroups;
  if (!Array.isArray(groups) || groups.length > 1)
    throw new Error("invalid_source_groups");
  if (!groups.length) return { date, requests: 0, visits: 0 };
  return {
    date,
    requests: count(groups[0].count),
    visits: count(groups[0].sum?.visits),
  };
}

export async function readSnapshot(env) {
  const stored = await env.DB.prepare(
    "SELECT value FROM metrics_meta WHERE key = 'public_snapshot'",
  ).first();
  if (stored) {
    try {
      const value = JSON.parse(stored.value);
      if (isMetricsSnapshot(value)) return value;
    } catch {
      // An invalid stored payload never becomes a fresh or zero-valued count.
    }
  }
  return initialSnapshot;
}

export async function synchronizeMetrics(
  env,
  now = new Date(),
  fetcher = fetch,
) {
  if (!env.ANALYTICS_API_TOKEN)
    return { updated: false, reason: "missing_analytics_token" };
  const days = datesBetween(env.METRICS_START_DATE, now);
  const retained = dayKey(now.getTime() - 30 * DAY);
  const recent = dayKey(now.getTime() - 2 * DAY);
  const stored = await env.DB.prepare(
    "SELECT date FROM daily_metrics WHERE date >= ?",
  )
    .bind(env.METRICS_START_DATE)
    .all();
  const existing = new Set(stored.results.map((row) => row.date));
  if (days.some((date) => date < retained && !existing.has(date)))
    throw new Error("history_gap_outside_retention");
  const selected = days.filter((date) => !existing.has(date) || date >= recent);
  const updates = [];
  for (const date of selected)
    updates.push(await queryDay(env, date, now, fetcher));
  const asOf = now.toISOString();
  if (updates.length) {
    await env.DB.batch(
      updates.map((row) =>
        env.DB.prepare(
          `INSERT INTO daily_metrics (date, requests, visits, collected_at)
           VALUES (?, ?, ?, ?)
           ON CONFLICT(date) DO UPDATE SET
             requests = excluded.requests, visits = excluded.visits,
             collected_at = excluded.collected_at
           WHERE daily_metrics.collected_at <= excluded.collected_at`,
        ).bind(row.date, row.requests, row.visits, asOf),
      ),
    );
  }
  const totals = await env.DB.prepare(
    `SELECT COUNT(*) AS days, SUM(requests) AS requests, SUM(visits) AS visits
     FROM daily_metrics WHERE date >= ? AND date <= ?`,
  )
    .bind(env.METRICS_START_DATE, dayKey(now))
    .first();
  if (totals.days !== days.length) throw new Error("incomplete_history");
  const snapshot = {
    schemaVersion: 1,
    project: "recomp-center",
    source: "Cloudflare Analytics",
    approximate: true,
    includesAutomatedTraffic: true,
    coverageComplete: true,
    collection: "automatic",
    asOf,
    period: { kind: "cumulative", start: days[0], end: asOf },
    metrics: { visits: count(totals.visits), requests: count(totals.requests) },
  };
  if (!isMetricsSnapshot(snapshot)) throw new Error("invalid_public_snapshot");
  await env.DB.prepare(
    `INSERT INTO metrics_meta (key, value, updated_at)
     VALUES ('public_snapshot', ?, ?)
     ON CONFLICT(key) DO UPDATE SET value = excluded.value, updated_at = excluded.updated_at
     WHERE metrics_meta.updated_at <= excluded.updated_at`,
  )
    .bind(JSON.stringify(snapshot), asOf)
    .run();
  return { updated: true, days: days.length };
}
