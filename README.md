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

## Edit Countries

The current mapped countries live in `lib/world_experience_map.dart` as
`_portfolioCountries`. Update that list with the real countries, project
counts, roles, and copy before publishing the portfolio.
