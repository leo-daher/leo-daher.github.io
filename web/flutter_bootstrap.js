{{flutter_js}}
{{flutter_build_config}}

window.addEventListener(
  'flutter-first-frame',
  () => document.getElementById('flutter-splash')?.remove(),
  { once: true },
);

_flutter.loader.load();
