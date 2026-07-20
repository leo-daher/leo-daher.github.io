# World map assets

`world-map-base.svg` is generated from `countries_world_map` and intentionally
kept outside Flutter's asset bundle. Regenerate both the SVG source and the
numeric interactive overlay data with:

```sh
fvm dart run tool/generate_world_map_assets.dart
```

Compile the runtime asset with:

```sh
fvm dart run vector_graphics_compiler \
  -i tool/assets/world-map-base.svg \
  -o assets/maps/world-map-base.svg.vec
```

Only the `.svg.vec` output is shipped by `pubspec.yaml`.
