import 'package:flutter_test/flutter_test.dart';
import 'package:leone_portfolio/telemetry/portfolio_attribution.dart';

void main() {
  group('portfolioAttributionFromUri', () {
    test('records the canonical CV reference', () {
      final attribution = portfolioAttributionFromUri(
        Uri.parse('https://leo-daher.github.io/?ref=cv-20260916T144658237Z'),
      );

      expect(attribution, {'attribution_ref': 'cv-20260916T144658237Z'});
    });

    test('records the Instagram reference', () {
      final attribution = portfolioAttributionFromUri(
        Uri.parse('https://leo-daher.github.io/?ref=ig'),
      );

      expect(attribution, {'attribution_ref': 'ig'});
    });

    test('sanitizes and bounds supported values', () {
      final attribution = portfolioAttributionFromUri(
        Uri.parse(
          'https://leo-daher.github.io/?utm_source=resume%20pdf'
          '&ref=${'a' * 100}&ignored=value',
        ),
      );

      expect(attribution['attribution_source'], 'resume-pdf');
      expect(attribution['attribution_ref'], 'a' * 80);
      expect(attribution, isNot(contains('ignored')));
    });

    test('ignores empty attribution values', () {
      final attribution = portfolioAttributionFromUri(
        Uri.parse('https://leo-daher.github.io/?ref=%20%20'),
      );

      expect(attribution, isEmpty);
    });
  });
}
