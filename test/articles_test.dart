import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:leone_portfolio/brand/leone_brand.dart';
import 'package:leone_portfolio/features/articles/articles.dart';
import 'package:leone_portfolio/l10n/app_localizations.dart';
import 'package:leone_portfolio/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/link.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  testWidgets('article page publishes the complete identity story', (
    tester,
  ) async {
    await tester.pumpWidget(_localizedApp(const ArticlesPage()));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('articles-page')), findsOneWidget);
    expect(find.text('PUBLISHED'), findsOneWidget);
    expect(
      find.text("How I designed this portfolio's logo and visual identity"),
      findsOneWidget,
    );
    expect(find.text('The initials and the frame'), findsOneWidget);
    expect(find.text('The dot that becomes a button'), findsOneWidget);
    expect(find.text('When the logo becomes the page'), findsOneWidget);
    expect(find.byKey(const Key('identity-logo-figure')), findsOneWidget);
    expect(find.byKey(const Key('identity-exploded-figure')), findsOneWidget);
    expect(find.byKey(const Key('identity-fab-figure')), findsOneWidget);
    expect(
      find.byKey(const Key('identity-opening-sequence-figure')),
      findsOneWidget,
    );
    expect(find.byKey(const Key('article-share-badges')), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Portuguese article explains LD, Material 3 and the viewport', (
    tester,
  ) async {
    await tester.pumpWidget(
      _localizedApp(const ArticlesPage(), locale: const Locale('pt')),
    );
    await tester.pumpAndSettle();

    expect(find.text('PUBLICADO'), findsOneWidget);
    expect(find.textContaining('L.D.'), findsWidgets);
    expect(find.textContaining('Material Design 3'), findsOneWidget);
    expect(find.textContaining('microcorte'), findsWidgets);
    expect(find.textContaining('viewport'), findsWidgets);
    expect(tester.takeException(), isNull);
  });

  testWidgets('article share badges expose canonical social URLs', (
    tester,
  ) async {
    await tester.pumpWidget(_localizedApp(const ArticlesPage()));
    await tester.pumpAndSettle();

    final linkedin = tester.widget<Link>(
      find.byKey(const Key('share-linkedin')),
    );
    final whatsApp = tester.widget<Link>(
      find.byKey(const Key('share-whatsapp')),
    );
    final x = tester.widget<Link>(find.byKey(const Key('share-x')));
    final facebook = tester.widget<Link>(
      find.byKey(const Key('share-facebook')),
    );

    final linkedinUri = linkedin.uri!;
    final whatsAppUri = whatsApp.uri!;
    final xUri = x.uri!;
    final facebookUri = facebook.uri!;

    expect(linkedinUri.host, 'www.linkedin.com');
    expect(linkedinUri.path, '/sharing/share-offsite/');
    expect(
      linkedinUri.queryParameters['url'],
      ArticlesPage.canonicalArticleUri.toString(),
    );
    expect(whatsAppUri.host, 'wa.me');
    expect(
      whatsAppUri.queryParameters['text'],
      contains(ArticlesPage.canonicalArticleUri.toString()),
    );
    expect(xUri.host, 'twitter.com');
    expect(
      xUri.queryParameters['url'],
      ArticlesPage.canonicalArticleUri.toString(),
    );
    expect(facebookUri.host, 'www.facebook.com');
    expect(
      facebookUri.queryParameters['u'],
      ArticlesPage.canonicalArticleUri.toString(),
    );
  });

  testWidgets('article figures and share links expose concise semantics', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();

    await tester.pumpWidget(_localizedApp(const ArticlesPage()));
    await tester.pumpAndSettle();

    final figure = tester.getSemantics(
      find.bySemanticsLabel(
        'Comparison between the orange dot inside the logo and the '
        'functional FAB with a menu icon.',
      ),
    );
    final figureData = figure.getSemanticsData();
    expect(figureData.flagsCollection.isImage, isTrue);
    expect(figureData.hasAction(SemanticsAction.tap), isFalse);

    final linkedin = tester.getSemantics(
      find.bySemanticsLabel('Share on LinkedIn'),
    );
    expect(linkedin.label, 'Share on LinkedIn');
    final linkedinData = linkedin.getSemanticsData();
    expect(linkedinData.flagsCollection.isLink, isTrue);
    expect(linkedinData.hasAction(SemanticsAction.tap), isTrue);

    semantics.dispose();
  });

  testWidgets('article page remains usable on a narrow viewport', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(_localizedApp(const ArticlesPage()));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('article-share-badges')), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('article page fits a 320px viewport with large text', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 900);
    tester.view.devicePixelRatio = 1;
    tester.platformDispatcher.textScaleFactorTestValue = 2;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

    await tester.pumpWidget(
      _localizedApp(const ArticlesPage(), locale: const Locale('pt')),
    );
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byKey(const Key('article-share-badges')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('identity-exploded-figure')), findsOneWidget);
    expect(find.byKey(const Key('identity-fab-figure')), findsOneWidget);
    expect(find.byKey(const Key('article-share-badges')), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('portfolio registers the canonical article route', (
    tester,
  ) async {
    await tester.pumpWidget(const LeonePortfolioApp());
    await tester.pump();
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();

    final navigator = tester.state<NavigatorState>(find.byType(Navigator));
    navigator.pushNamed(ArticlesPage.routeName);
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('articles-page')), findsOneWidget);
  });
}

Widget _localizedApp(Widget child, {Locale locale = const Locale('en')}) =>
    MaterialApp(
      locale: locale,
      theme: LeoneBrandTheme.dark(),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: child,
    );
