import 'package:flutter_test/flutter_test.dart';
import 'package:leone_portfolio/telemetry/sentry_log_policy.dart';

void main() {
  group('Sentry log policy', () {
    test('keeps high-signal portfolio events', () {
      expect(shouldSendSentryLog('portfolio_view'), isTrue);
      expect(shouldSendSentryLog('portfolio_attribution'), isTrue);
      expect(shouldSendSentryLog('contact_intent'), isTrue);
      expect(shouldSendSentryLog('generate_lead'), isTrue);
    });

    test('keeps noisy navigation and scroll events as breadcrumbs only', () {
      expect(shouldSendSentryLog('section_view'), isFalse);
      expect(shouldSendSentryLog('scroll_depth'), isFalse);
      expect(shouldSendSentryLog('change_preference'), isFalse);
    });

    test('converts supported values to typed Sentry attributes', () {
      final attributes = sentryLogAttributes({
        'ref': 'ig',
        'is_lead': true,
        'depth': 75,
        'sample_rate': 0.15,
        'unsupported': Uri.parse('https://example.com'),
      });

      expect(attributes['ref']?.value, 'ig');
      expect(attributes['is_lead']?.value, isTrue);
      expect(attributes['depth']?.value, 75);
      expect(attributes['sample_rate']?.value, 0.15);
      expect(attributes, isNot(contains('unsupported')));
    });
  });
}
