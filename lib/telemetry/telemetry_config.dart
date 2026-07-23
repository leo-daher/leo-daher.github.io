class TelemetryConfig {
  const TelemetryConfig({
    this.googleAnalyticsMeasurementId = '',
    this.sentryDsn = '',
    this.environment = 'production',
    this.release = '',
  });

  const TelemetryConfig.fromEnvironment()
    : googleAnalyticsMeasurementId = const String.fromEnvironment(
        'GA_MEASUREMENT_ID',
      ),
      sentryDsn = const String.fromEnvironment('SENTRY_DSN'),
      environment = const String.fromEnvironment(
        'TELEMETRY_ENVIRONMENT',
        defaultValue: 'production',
      ),
      release = const String.fromEnvironment('PORTFOLIO_RELEASE');

  final String googleAnalyticsMeasurementId;
  final String sentryDsn;
  final String environment;
  final String release;

  bool get googleAnalyticsEnabled =>
      RegExp(r'^G-[A-Z0-9]+$').hasMatch(googleAnalyticsMeasurementId);

  bool get sentryEnabled {
    final uri = Uri.tryParse(sentryDsn);
    return uri != null &&
        uri.scheme == 'https' &&
        uri.host.isNotEmpty &&
        uri.userInfo.isNotEmpty;
  }
}
