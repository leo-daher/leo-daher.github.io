# Leone Portfolio

Flutter portfolio prototype focused on a global experience map widget.

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
