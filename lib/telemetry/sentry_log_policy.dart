import 'package:sentry_flutter/sentry_flutter.dart';

const _sentryLogEvents = {
  'portfolio_view',
  'portfolio_attribution',
  'select_outbound_link',
  'contact_intent',
  'generate_lead',
  'certificate_action',
};

bool shouldSendSentryLog(String eventName) =>
    _sentryLogEvents.contains(eventName);

Map<String, SentryAttribute> sentryLogAttributes(
  Map<String, Object> parameters,
) {
  final attributes = <String, SentryAttribute>{};

  for (final entry in parameters.entries) {
    final value = entry.value;
    final attribute = switch (value) {
      String() => SentryAttribute.string(value),
      bool() => SentryAttribute.bool(value),
      int() => SentryAttribute.int(value),
      double() => SentryAttribute.double(value),
      _ => null,
    };
    if (attribute != null) attributes[entry.key] = attribute;
  }

  return attributes;
}
