import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:leone_portfolio/brand/leone_brand.dart';
import 'package:leone_portfolio/features/articles/articles.dart';
import 'package:leone_portfolio/l10n/app_localizations.dart';
import 'package:leone_portfolio/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/link.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  testWidgets('article page keeps the first topic as an unpublished draft', (
    tester,
  ) async {
    await tester.pumpWidget(_localizedApp(const ArticlesPage()));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('articles-page')), findsOneWidget);
    expect(find.text('IN PREPARATION'), findsOneWidget);
    expect(
      find.text("How I developed this portfolio's logo and visual identity"),
      findsOneWidget,
    );
    expect(find.byKey(const Key('article-share-badges')), findsOneWidget);
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

Widget _localizedApp(Widget child) => MaterialApp(
  locale: const Locale('en'),
  theme: LeoneBrandTheme.dark(),
  localizationsDelegates: const [AppLocalizations.delegate],
  supportedLocales: AppLocalizations.supportedLocales,
  home: child,
);
