import 'dart:js_interop';

import 'package:web/web.dart' as web;

@JS('gtag')
external void _gtag(JSString command, JSString target, JSAny? fields);

class GoogleAnalyticsClient {
  const GoogleAnalyticsClient();

  void initialize(String measurementId) {
    final loader = web.HTMLScriptElement()
      ..async = true
      ..src = 'https://www.googletagmanager.com/gtag/js?id=$measurementId';
    web.document.head?.append(loader);

    final bootstrap = web.HTMLScriptElement()
      ..text =
          '''
window.dataLayer = window.dataLayer || [];
function gtag(){dataLayer.push(arguments);}
gtag('js', new Date());
gtag('config', '$measurementId', {
  'send_page_view': true,
  'allow_google_signals': false,
  'allow_ad_personalization_signals': false
});
''';
    web.document.head?.append(bootstrap);
  }

  void logEvent(String name, Map<String, Object> parameters) {
    _gtag('event'.toJS, name.toJS, parameters.jsify());
  }
}
