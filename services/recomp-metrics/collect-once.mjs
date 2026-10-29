import { readFile } from "node:fs/promises";
import { synchronizeMetrics } from "./metrics.mjs";

// Use an existing deployment credential only for D1. The analytics credential
// remains separate and has no permission to write data or deploy code.
const controlToken = process.env.CLOUDFLARE_API_TOKEN;
const analyticsToken = process.env.ANALYTICS_API_TOKEN;
if (!controlToken || !analyticsToken)
  throw new Error("CLOUDFLARE_API_TOKEN and ANALYTICS_API_TOKEN are required");
const config = JSON.parse(
  await readFile(new URL("./wrangler.jsonc", import.meta.url), "utf8"),
);
const database = config.d1_databases.find((item) => item.binding === "DB");
const endpoint = `https://api.cloudflare.com/client/v4/accounts/${config.account_id}/d1/database/${database.database_id}/query`;
function prepare(sql, params = []) {
  async function execute() {
    const response = await fetch(endpoint, {
      method: "POST",
      headers: {
        Authorization: `Bearer ${controlToken}`,
        "Content-Type": "application/json",
      },
      body: JSON.stringify({ sql, params }),
      signal: AbortSignal.timeout(20_000),
    });
    const body = await response.json();
    if (
      !response.ok ||
      body.success !== true ||
      body.result?.[0]?.success !== true
    )
      throw new Error("D1 query failed");
    return body.result[0];
  }
  return {
    bind(...values) {
      return prepare(sql, values);
    },
    all: execute,
    run: execute,
    async first() {
      return (await execute()).results[0] ?? null;
    },
  };
}
const result = await synchronizeMetrics({
  ...config.vars,
  ANALYTICS_API_TOKEN: analyticsToken,
  DB: {
    prepare,
    async batch(statements) {
      for (const statement of statements) await statement.run();
    },
  },
});
console.log(JSON.stringify(result));
