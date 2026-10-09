# Leone Daher Portfolio

React portfolio for Leone Daher's mobile engineering, connected systems and
AI automation work. The public GitHub Pages deployment serves the approved
React version from `web-react/`, including static HTML, Portuguese/English
Markdown, structured data, and `llms.txt` for automated readers.
English is served at `/`, Portuguese at `/pt/`, and legacy `/en/` links
redirect to the English pages.

See [`web-react/README.md`](web-react/README.md) for the current application,
Node server, read-only MCP endpoint, and validation. The original Flutter
implementation remains in this repository.

## Shared professional knowledge

Professional facts and consultancy/client/project relationships are maintained
in `/Users/leone/Documents/Perfil Profissional/base/conhecimento.json`.
Its `ferramentas/conhecimento.py sync` command generates the selected experience
and case-study JSON modules in `web-react/src/data/`. Edit facts and approved
copy in the shared base, then validate and publish this repository. The shared
base has its own Git history; it is not part of this public checkout.

## Brand

The canonical LD identity, including strategy, geometry, color, motion, voice
and accessibility rules, lives in
[`assets/brand/identity.md`](assets/brand/identity.md). React design tokens
live in [`web-react/src/styles.css`](web-react/src/styles.css); the original
Flutter tokens remain in [`lib/brand/leone_brand.dart`](lib/brand/leone_brand.dart).

## Run React

```bash
cd web-react
npm ci
SITE_ORIGIN=http://127.0.0.1:4173 npm run build
npm start
```

## Validate React

```bash
cd web-react
npm run validate
```

## Run original Flutter implementation

```bash
fvm flutter run -d web-server --web-hostname 127.0.0.1 --web-port 8080
```

## Validate original Flutter implementation

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
- Sentry captures unhandled and silent Flutter errors, affected sessions,
  releases, sampled performance traces, breadcrumbs, and structured logs for
  high-signal portfolio activity.

Neither provider is enabled in local builds unless its configuration is
supplied. React reads `VITE_GA_MEASUREMENT_ID`, `VITE_SENTRY_DSN`,
`VITE_TELEMETRY_ENVIRONMENT`, and `VITE_PORTFOLIO_RELEASE` during its build.
To test the original Flutter integration locally:

```bash
fvm flutter run -d chrome \
  --dart-define=GA_MEASUREMENT_ID=G-XXXXXXXXXX \
  --dart-define=SENTRY_DSN=https://PUBLIC_KEY@SENTRY_HOST/PROJECT_ID \
  --dart-define=TELEMETRY_ENVIRONMENT=development
```

For GitHub Pages, the existing repository variable `GA_MEASUREMENT_ID` and
Actions secret `SENTRY_DSN` are supplied to the React build. The deploy
workflow supplies the commit SHA as the Sentry release automatically.

Sentry Logs is enabled in production. It records `portfolio_view`,
`portfolio_attribution`, `select_outbound_link`, `contact_intent`,
`generate_lead`, and `certificate_action` with typed, non-PII attributes.
Frequent section, preference, and scroll activity remains available as error
breadcrumbs without consuming one log entry per interaction.

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
identified. Social profiles use the clean short links `/ig` for Instagram,
`/fb` for Facebook, and `/in` for LinkedIn; each entry point redirects to the
home page with its stable reference so attribution remains intact. Social entry points also save the
reference in the `portfolio_attribution_ref` cookie before redirecting. In GA4,
inspect the `portfolio_attribution` event and its `attribution_ref` parameter.
Register `attribution_ref` as an event-scoped custom dimension named `Portfolio ref` to
use it in historical reports and Explorations. Sentry receives the same event
as a structured log and breadcrumb, while GA4 remains the traffic-reporting
source.

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
