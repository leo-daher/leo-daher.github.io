import 'package:web/web.dart' as web;

import 'portfolio_attribution.dart';

Future<void> persistAndCleanPortfolioRef(Uri uri) async {
  final ref = portfolioAttributionRefFromUri(uri);
  if (ref == null) return;

  web.window.sessionStorage.setItem('portfolio_attribution_ref', ref);
  web.window.localStorage.setItem('portfolio_attribution_ref', ref);

  final remainingParameters = Map<String, String>.from(uri.queryParameters)
    ..remove('ref');
  final cleanUri = uri.replace(
    queryParameters: remainingParameters.isEmpty ? null : remainingParameters,
  );
  final cleanPath =
      '${cleanUri.path.isEmpty ? '/' : cleanUri.path}'
      '${cleanUri.hasQuery ? '?${cleanUri.query}' : ''}'
      '${cleanUri.hasFragment ? '#${cleanUri.fragment}' : ''}';
  web.window.history.replaceState(null, '', cleanPath);
}
