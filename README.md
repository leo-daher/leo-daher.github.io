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
