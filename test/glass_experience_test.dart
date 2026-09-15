import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:leone_portfolio/brand/leone_brand.dart';
import 'package:leone_portfolio/brand/leone_glass.dart';
import 'package:leone_portfolio/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/link.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  testWidgets('serves the hidden ios route with the glass visual system', (
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
    expect(tester.element(home).leonePalette, LeonePalette.glassDark);
    expect(
      Theme.of(tester.element(home)).scaffoldBackgroundColor,
      Colors.transparent,
    );
    expect(find.byType(LeoneGlassSurface), findsWidgets);
  });

  testWidgets('keeps the public home free of links to the hidden route', (
    tester,
  ) async {
    await tester.pumpWidget(const LeonePortfolioApp());
    await tester.pump();
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('ios-glass-background')), findsNothing);
    for (final link in tester.widgetList<Link>(find.byType(Link))) {
      expect(link.uri?.path.startsWith('/ios') ?? false, isFalse);
    }
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
