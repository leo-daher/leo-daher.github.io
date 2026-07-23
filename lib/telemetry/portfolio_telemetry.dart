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

  static void sectionSelected(String section) => event('section_view', {
    'section_name': section,
    'navigation_type': 'menu',
  });

  static void preferenceChanged(String preference, String value) =>
      event('change_preference', {'preference': preference, 'value': value});

  static void scrollDepth(int percent) =>
      event('scroll_depth', {'scroll_percent': percent});

  static void outboundLink(
    String destination,
    Uri uri, {
    String linkType = 'external',
  }) => event('select_outbound_link', {
    'destination': destination,
    'link_type': linkType,
    'link_domain': uri.host,
    'link_url': uri.toString(),
  });

  static void contactIntent(String method, Uri uri, {required bool isLead}) {
    outboundLink(method, uri, linkType: 'contact');
    event('contact_intent', {
      'contact_method': method,
      'link_domain': uri.host,
    });
    if (isLead) {
      event('generate_lead', {
        'contact_method': method,
        'link_domain': uri.host,
      });
    }
  }

  static void certificateAction(String action, {String? certificateId}) =>
      event('certificate_action', {
        'action': action,
        'certificate_id': ?certificateId,
      });
}
