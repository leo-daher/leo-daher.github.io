import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:leone_portfolio/brand/leone_brand.dart';
import 'package:leone_portfolio/brand/leone_glass.dart';
import 'package:leone_portfolio/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/link.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  testWidgets('keeps the ios route as a compatible glass alias', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1440, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const LeonePortfolioApp(initialRoute: '/ios'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();

    final home = find.byKey(const Key('portfolio-home-page'));
    expect(home, findsOneWidget);
    expect(find.byKey(const Key('ios-glass-background')), findsOneWidget);
    expect(tester.element(home).usesLeoneGlass, isTrue);
    expect(tester.element(home).leonePalette, LeonePalette.glassLight);
    expect(
      Theme.of(tester.element(home)).scaffoldBackgroundColor,
      Colors.transparent,
    );
    expect(find.byType(LeoneGlassSurface), findsWidgets);
  });

  testWidgets('uses glass on the public home with canonical public links', (
    tester,
  ) async {
    await tester.pumpWidget(const LeonePortfolioApp());
    await tester.pump();
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();

    final home = find.byKey(const Key('portfolio-home-page'));
    expect(tester.element(home).usesLeoneGlass, isTrue);
    expect(tester.element(home).leonePalette, LeonePalette.glassLight);
    expect(find.byKey(const Key('ios-glass-background')), findsOneWidget);
    for (final link in tester.widgetList<Link>(find.byType(Link))) {
      expect(link.uri?.path.startsWith('/ios') ?? false, isFalse);
    }
  });

  testWidgets('restores language and light mode on the default glass home', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({
      'portfolio_locale': 'pt',
      'portfolio_theme': 'light',
    });
    await tester.pumpWidget(const LeonePortfolioApp());
    await tester.pump();
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();

    final home = tester.element(find.byKey(const Key('portfolio-home-page')));
    expect(home.usesLeoneGlass, isTrue);
    expect(home.leonePalette, LeonePalette.glassLight);
    expect(Theme.of(home).brightness, Brightness.light);
    expect(Localizations.localeOf(home), const Locale('pt'));
  });

  testWidgets('serves the canonical article in glass with saved preferences', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({
      'portfolio_locale': 'pt',
      'portfolio_theme': 'light',
    });
    await tester.pumpWidget(
      const LeonePortfolioApp(initialRoute: '/artigos/identidade-visual'),
    );
    await tester.pumpAndSettle();

    final article = tester.element(find.byKey(const Key('articles-page')));
    expect(article.usesLeoneGlass, isTrue);
    expect(article.leonePalette, LeonePalette.glassLight);
    expect(Localizations.localeOf(article), const Locale('pt'));
    expect(ModalRoute.of(article)?.settings.name, '/artigos/identidade-visual');
    expect(find.byKey(const Key('ios-glass-background')), findsOneWidget);
    expect(find.byKey(const Key('portfolio-home-page')), findsNothing);
    final transitionSurface = tester.widget<ColoredBox>(
      find.byKey(const Key('article-page-transition-surface')),
    );
    expect(transitionSurface.color, Colors.transparent);
  });

  testWidgets('keeps the glass treatment on the ios article route', (
    tester,
  ) async {
    await tester.pumpWidget(const LeonePortfolioApp());
    await tester.pump();
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();

    final navigator = tester.state<NavigatorState>(find.byType(Navigator));
    navigator.pushNamed('/ios/artigos/identidade-visual');
    await tester.pumpAndSettle();

    final article = find.byKey(const Key('articles-page'));
    expect(article, findsOneWidget);
    expect(tester.element(article).usesLeoneGlass, isTrue);
    expect(find.byKey(const Key('ios-glass-background')), findsOneWidget);
    final transitionSurface = tester.widget<ColoredBox>(
      find.byKey(const Key('article-page-transition-surface')),
    );
    expect(transitionSurface.color, Colors.transparent);
  });
}
