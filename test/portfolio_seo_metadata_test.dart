import 'package:flutter_test/flutter_test.dart';
import 'package:leone_portfolio/seo/portfolio_seo_metadata.dart';

void main() {
  test('publishes indexable metadata for the canonical article route', () {
    final page = PortfolioSeoPage.forRoute(
      '/artigos/identidade-visual/',
      languageCode: 'pt',
    );

    expect(page, isNotNull);
    expect(page!.language, 'pt-BR');
    expect(page.openGraphType, 'article');
    expect(page.robots, 'index, follow');
    expect(
      page.canonicalUrl,
      'https://leo-daher.github.io/artigos/identidade-visual/',
    );
    expect(page.title, contains('identidade visual'));
  });

  test('keeps the glass experiment out of search results', () {
    final home = PortfolioSeoPage.forRoute('/ios/', languageCode: 'en');
    final article = PortfolioSeoPage.forRoute(
      '/ios/artigos/identidade-visual',
      languageCode: 'en',
    );

    expect(home!.robots, 'noindex, nofollow');
    expect(home.canonicalUrl, 'https://leo-daher.github.io/');
    expect(article!.robots, 'noindex, nofollow');
    expect(
      article.canonicalUrl,
      'https://leo-daher.github.io/artigos/identidade-visual/',
    );
  });

  test('ignores routes without public SEO metadata', () {
    expect(PortfolioSeoPage.forRoute('/unknown', languageCode: 'en'), isNull);
    expect(PortfolioSeoPage.forRoute(null, languageCode: 'en'), isNull);
  });
}
