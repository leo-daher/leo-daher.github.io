import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'google_analytics.dart';
import 'telemetry_config.dart';

class PortfolioTelemetry {
  PortfolioTelemetry._();

  static const config = TelemetryConfig.fromEnvironment();
  static const _analytics = GoogleAnalyticsClient();
  static bool _sentryEnabled = false;

  static Future<void> initialize(VoidCallback appRunner) async {
    if (config.googleAnalyticsEnabled && kIsWeb) {
      _analytics.initialize(config.googleAnalyticsMeasurementId);
    }

    if (!config.sentryEnabled) {
      appRunner();
      return;
    }

    _sentryEnabled = true;
    await SentryFlutter.init((options) {
      options
        ..dsn = config.sentryDsn
        ..environment = config.environment
        ..release = config.release.isEmpty ? null : config.release
        ..sendDefaultPii = false
        ..tracesSampleRate = 0.15
        ..enableAutoSessionTracking = true;
    }, appRunner: appRunner);
  }

  static void event(String name, [Map<String, Object> parameters = const {}]) {
    if (config.googleAnalyticsEnabled && kIsWeb) {
      _analytics.logEvent(name, parameters);
    }
    if (_sentryEnabled) {
      unawaited(
        Sentry.addBreadcrumb(
          Breadcrumb(
            category: 'portfolio.interaction',
            message: name,
            data: parameters,
          ),
        ),
      );
    }
  }

  static void portfolioViewed({
    required String locale,
    required String theme,
  }) => event('portfolio_view', {'locale': locale, 'theme': theme});

  static void sectionSelected(String section) =>
      event('select_section', {'section': section});

  static void preferenceChanged(String preference, String value) =>
      event('change_preference', {'preference': preference, 'value': value});

  static void outboundLink(String destination, Uri uri) => event(
    'select_outbound_link',
    {'destination': destination, 'host': uri.host},
  );

  static void certificateAction(String action, {String? certificateId}) =>
      event('certificate_action', {
        'action': action,
        'certificate_id': ?certificateId,
      });
}
