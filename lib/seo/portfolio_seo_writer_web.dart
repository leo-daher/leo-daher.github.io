import 'package:web/web.dart' as web;

void applyPortfolioSeoMetadata({
  required String language,
  required String title,
  required String description,
  required String canonicalUrl,
  required String robots,
  required String openGraphType,
}) {
  final document = web.document;
  document.title = title;
  document.documentElement?.setAttribute('lang', language);

  _upsertMeta('name', 'description', description);
  _upsertMeta('name', 'robots', robots);
  _upsertMeta('property', 'og:type', openGraphType);
  _upsertMeta('property', 'og:title', title);
  _upsertMeta('property', 'og:description', description);
  _upsertMeta('property', 'og:url', canonicalUrl);
  _upsertMeta('name', 'twitter:title', title);
  _upsertMeta('name', 'twitter:description', description);
  _upsertCanonical(canonicalUrl);
}

void _upsertMeta(String keyAttribute, String key, String content) {
  final document = web.document;
  final selector = 'meta[$keyAttribute="$key"]';
  final element =
      document.querySelector(selector) ??
      (document.createElement('meta')..setAttribute(keyAttribute, key));
  element.setAttribute('content', content);
  if (!element.isConnected) document.head?.append(element);
}

void _upsertCanonical(String canonicalUrl) {
  final document = web.document;
  final element =
      document.querySelector('link[rel="canonical"]') ??
      (document.createElement('link')..setAttribute('rel', 'canonical'));
  element.setAttribute('href', canonicalUrl);
  if (!element.isConnected) document.head?.append(element);
}
