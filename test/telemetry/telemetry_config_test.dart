import 'package:flutter_test/flutter_test.dart';
import 'package:leone_portfolio/telemetry/telemetry_config.dart';

void main() {
  group('TelemetryConfig', () {
    test('enables a valid GA4 measurement ID', () {
      const config = TelemetryConfig(
        googleAnalyticsMeasurementId: 'G-ABC123XYZ9',
      );

      expect(config.googleAnalyticsEnabled, isTrue);
    });

    test('keeps malformed or missing GA4 IDs disabled', () {
      const missing = TelemetryConfig();
      const malformed = TelemetryConfig(
        googleAnalyticsMeasurementId: 'UA-123456-7',
      );

      expect(missing.googleAnalyticsEnabled, isFalse);
      expect(malformed.googleAnalyticsEnabled, isFalse);
    });

    test('enables an HTTPS Sentry DSN with a public key', () {
      const config = TelemetryConfig(
        sentryDsn: 'https://public-key@example.ingest.sentry.io/12345',
      );

      expect(config.sentryEnabled, isTrue);
    });

    test('keeps incomplete or insecure Sentry DSNs disabled', () {
      const missingKey = TelemetryConfig(
        sentryDsn: 'https://example.ingest.sentry.io/12345',
      );
      const insecure = TelemetryConfig(
        sentryDsn: 'http://public-key@example.ingest.sentry.io/12345',
      );

      expect(missingKey.sentryEnabled, isFalse);
      expect(insecure.sentryEnabled, isFalse);
    });
  });
}
