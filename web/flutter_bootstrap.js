{{flutter_js}}
{{flutter_build_config}}

(async () => {
  if ('serviceWorker' in navigator) {
    try {
      const registrations = await navigator.serviceWorker.getRegistrations();
      await Promise.all(
        registrations.map((registration) => registration.unregister()),
      );
    } catch (_) {
      // Loading the current app is more important than service worker cleanup.
    }
  }

  if ('caches' in window) {
    try {
      const keys = await caches.keys();
      await Promise.all(
        keys
          .filter((key) => key.includes('flutter') || key.includes('main.dart'))
          .map((key) => caches.delete(key)),
      );
    } catch (_) {
      // Cache cleanup can fail in private/restricted browser modes.
    }
  }

  _flutter.loader.load();
})();
