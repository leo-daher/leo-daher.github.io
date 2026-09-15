import 'package:material_ui/material_ui.dart';

import 'portfolio_seo_writer.dart';

class PortfolioSeoPage {
  const PortfolioSeoPage({
    required this.language,
    required this.title,
    required this.description,
    required this.canonicalUrl,
    required this.robots,
    required this.openGraphType,
  });

  final String language;
  final String title;
  final String description;
  final String canonicalUrl;
  final String robots;
  final String openGraphType;

  static PortfolioSeoPage? forRoute(
    String? routeName, {
    required String languageCode,
  }) {
    if (routeName == null) return null;

    final uri = Uri.tryParse(routeName);
    var path = uri?.path ?? routeName;
    if (path.length > 1 && path.endsWith('/')) {
      path = path.substring(0, path.length - 1);
    }

    final isPortuguese = languageCode == 'pt';
    final isGlass = path == '/ios' || path.startsWith('/ios/');
    final contentPath = isGlass ? path.substring(4) : path;
    final normalizedContentPath = contentPath.isEmpty ? '/' : contentPath;
    final robots = isGlass ? 'noindex, nofollow' : 'index, follow';

    if (normalizedContentPath == '/') {
      return PortfolioSeoPage(
        language: isPortuguese ? 'pt-BR' : 'en',
        title: 'Leone Daher — Mobile Software Engineer',
        description: isPortuguese
            ? 'Portfólio de Leone Daher: engenharia mobile com Android, Kotlin, Flutter, sistemas offline-first, arquitetura de software e automação com IA.'
            : 'Portfolio of Leone Daher: mobile engineering with Android, Kotlin, Flutter, offline-first systems, software architecture, and AI automation.',
        canonicalUrl: 'https://leo-daher.github.io/',
        robots: robots,
        openGraphType: 'website',
      );
    }

    if (normalizedContentPath == '/artigos/identidade-visual') {
      return PortfolioSeoPage(
        language: isPortuguese ? 'pt-BR' : 'en',
        title: isPortuguese
            ? 'Como desenvolvi a logo e a identidade visual deste portfólio — Leone Daher'
            : "How I designed this portfolio's logo and visual identity — Leone Daher",
        description: isPortuguese
            ? 'O processo por trás do símbolo LD, da linguagem visual e da ideia de transformar a própria marca em interface.'
            : 'The process behind the LD symbol, its visual language, and the idea of turning the brand itself into an interface.',
        canonicalUrl: 'https://leo-daher.github.io/artigos/identidade-visual/',
        robots: robots,
        openGraphType: 'article',
      );
    }

    return null;
  }
}

class PortfolioSeoRouteObserver extends NavigatorObserver {
  PortfolioSeoRouteObserver({required String initialLanguageCode})
    : _languageCode = initialLanguageCode;

  String _languageCode;
  String? _currentRouteName;

  void setLanguageCode(String languageCode) {
    _languageCode = languageCode;
    _applyCurrentRoute();
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    _selectRoute(route);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    if (previousRoute != null) _selectRoute(previousRoute);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (newRoute != null) _selectRoute(newRoute);
  }

  void _selectRoute(Route<dynamic> route) {
    final routeName = route.settings.name;
    if (routeName == null) return;
    _currentRouteName = routeName;
    _applyCurrentRoute();
  }

  void _applyCurrentRoute() {
    final page = PortfolioSeoPage.forRoute(
      _currentRouteName,
      languageCode: _languageCode,
    );
    if (page == null) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      applyPortfolioSeoMetadata(
        language: page.language,
        title: page.title,
        description: page.description,
        canonicalUrl: page.canonicalUrl,
        robots: page.robots,
        openGraphType: page.openGraphType,
      );
    });
  }
}
