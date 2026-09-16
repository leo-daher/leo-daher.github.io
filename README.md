# Leone Daher Portfolio

Adaptive Flutter portfolio for Leone Daher's mobile engineering, connected
systems and AI automation work.

## Brand

The canonical LD identity, including strategy, geometry, color, motion, voice
and accessibility rules, lives in
[`assets/brand/identity.md`](assets/brand/identity.md). Runtime design tokens
live in [`lib/brand/leone_brand.dart`](lib/brand/leone_brand.dart).

## Run

```bash
fvm flutter run -d web-server --web-hostname 127.0.0.1 --web-port 8080
```

## Validate

```bash
fvm dart format lib test
fvm flutter analyze
fvm flutter test
fvm flutter build web
```

## Telemetry

Production supports two complementary dashboards:

- Google Analytics 4 measures visits, acquisition, geography, devices, and
  portfolio interactions.
- Sentry captures unhandled errors, affected sessions, releases, and sampled
  performance traces.

Neither provider is enabled in local builds unless its configuration is
supplied. To test both locally:

```bash
fvm flutter run -d chrome \
  --dart-define=GA_MEASUREMENT_ID=G-XXXXXXXXXX \
  --dart-define=SENTRY_DSN=https://PUBLIC_KEY@SENTRY_HOST/PROJECT_ID \
  --dart-define=TELEMETRY_ENVIRONMENT=development
```

For GitHub Pages, create the repository variable `GA_MEASUREMENT_ID` and the
Actions secret `SENTRY_DSN`. The deploy workflow supplies the commit SHA as the
Sentry release automatically.

The custom GA4 events include `portfolio_view`, `portfolio_attribution`,
`section_view`, `scroll_depth`, `change_preference`, `select_outbound_link`,
`contact_intent`, `generate_lead`, and `certificate_action`. Resume,
application, and social links can use `utm_source`, `utm_medium`,
`utm_campaign`, `utm_content`, `utm_term`, or the short `ref` parameter. The
portfolio records only sanitized, bounded parameter values; names, email
addresses, full outbound URLs, and other personal data are excluded. Google
Signals and ad-personalization signals are disabled; Sentry default PII
collection is disabled.

Short references and their meanings are registered in
[`tracking/portfolio_ref_registry.csv`](tracking/portfolio_ref_registry.csv).
CV links use `ref=cv-<UTC timestamp>` so each generated document can be
identified; the Instagram link uses the stable `ref=ig` value. In GA4, inspect
the `portfolio_attribution` event and its `attribution_ref` parameter. Register
`attribution_ref` as an event-scoped custom dimension named `Portfolio ref` to
use it in historical reports and Explorations. Sentry receives the same event
as a breadcrumb for error context, but GA4 is the traffic-reporting source.

## Experience map

The world-experience map remains available in `lib/world_experience_map.dart`,
but is intentionally not mounted on the home page at the moment. This keeps
the portfolio focused and preserves the map source for a later iteration.

## Production apps

The home page presents selected public apps as scoped case studies: real store
screens, Leone's contribution, stack, current public proof, and official store
links. Localized presentation data lives in
`lib/features/apps/production_apps_content.dart`; the reusable responsive UI
lives beside it in `lib/features/apps/`.

Store media and its source record live in `assets/apps/`. Ratings, review
counts, downloads, update dates, and availability can change, so every metric
shown in the UI includes the month in which it was checked.

## Certificates

Verified certificate metadata and original artifacts live in
`assets/certificates/`. The website loads the compact catalog first and only
loads the official certificate image when a visitor opens a record. PDF
originals remain archived in the repository but are not bundled into the web
release.
