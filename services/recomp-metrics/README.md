# Recomp Center traffic counters

This Worker publishes aggregate Cloudflare traffic at `/metrics`. It stores
daily totals in a dedicated D1 database and refreshes at minute 17 of each
hour. The website reads the public result when the section becomes visible,
then every five minutes while the page is visible. No IP addresses, visitor
identifiers, logs or API credentials are exposed.

`ANALYTICS_API_TOKEN` is a Worker secret. Grant **Zone / Analytics / Read** for
**recomp.center** only. Keep it separate from deployment credentials. Without
this secret or a successful first collection, the service returns the dated,
rounded dashboard observation in `web-react/src/data/recomp-metrics.snapshot.json`.
It does not label that observation as an automatic or current measurement.

## Deploy

From the repository root:

```sh
npx wrangler@4.155.0 d1 migrations apply recomp-portfolio-metrics --remote --config services/recomp-metrics/wrangler.jsonc
npx wrangler@4.155.0 deploy --config services/recomp-metrics/wrangler.jsonc
npx wrangler@4.155.0 secret put ANALYTICS_API_TOKEN --config services/recomp-metrics/wrangler.jsonc
```

Run `node services/recomp-metrics/collect-once.mjs` for initial collection or
recovery. It reads `ANALYTICS_API_TOKEN` and a separate D1-capable
`CLOUDFLARE_API_TOKEN` from the process environment. Do not put their values in
commands, configuration files, this repository or browser code.

## Counting rules

- The first automatic collection backfills daily data from the configured
  start date, within the source's retention window. That date means the start
  of this measurement period, not a claim about the launch date.
- Each query covers `[00:00 UTC, next 00:00 UTC)` or the elapsed portion of
  today. Requests use `requestSource: eyeball` for delivery to clients. The
  zone includes the website and catalog. Automated client traffic remains
  included; neither counter is a count of unique people or installations.
- Repeated collections **replace** each day's totals. The most recent three
  UTC dates are re-read for late data and source corrections. Historical days
  remain stored after the provider's retention window expires.
- Counts are estimates. Source corrections can lower them; do not force a
  monotonic maximum, add overlapping windows or invent per-second growth.
- An error, invalid response or gap outside retention preserves the last
  complete public observation and its date. Gaps require recovery from a
  verified source or an explicitly chosen new period, never silent zero-fill.
- The HTTP service supports read operations only. First collection is a local
  administrative operation; there is no public synchronization endpoint.

## Validation

`npm run test:agents` in `web-react` runs the collector tests against the real
SQLite schema alongside the existing content/MCP tests. Playwright covers
the public section, both languages, responsive layouts, updated values and
fallback behavior.
