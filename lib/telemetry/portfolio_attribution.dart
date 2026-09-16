const _portfolioAttributionKeys = {
  'utm_source': 'attribution_source',
  'utm_medium': 'attribution_medium',
  'utm_campaign': 'attribution_campaign',
  'utm_content': 'attribution_content',
  'utm_term': 'attribution_term',
  'ref': 'attribution_ref',
};

Map<String, Object> portfolioAttributionFromUri(Uri uri) {
  final attribution = <String, Object>{};

  for (final entry in _portfolioAttributionKeys.entries) {
    final value = uri.queryParameters[entry.key]?.trim();
    if (value == null || value.isEmpty) continue;

    final safeValue = value.replaceAll(RegExp(r'[^A-Za-z0-9._-]'), '-');
    if (safeValue.isEmpty) continue;

    attribution[entry.value] = safeValue.length > 80
        ? safeValue.substring(0, 80)
        : safeValue;
  }

  return attribution;
}
