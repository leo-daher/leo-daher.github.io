import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:leone_portfolio/brand/leone_brand.dart';
import 'package:leone_portfolio/features/articles/article_catalog.dart';
import 'package:leone_portfolio/features/articles/article_page_layout.dart';
import 'package:leone_portfolio/features/articles/article_publication_metadata.dart';
import 'package:leone_portfolio/features/articles/articles.dart';
import 'package:leone_portfolio/features/contact/portfolio_contact_links.dart';
import 'package:leone_portfolio/features/navigation/portfolio_top_bar.dart';
import 'package:leone_portfolio/l10n/app_localizations.dart';
import 'package:leone_portfolio/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/link.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('article metadata requires ordered UTC timestamps', () {
    expect(
      () =>
          ArticlePublicationInfo(publishedAtUtc: DateTime(2026, 9, 15, 10, 38)),
      throwsArgumentError,
    );
    expect(
      () => ArticlePublicationInfo(
        publishedAtUtc: DateTime.utc(2026, 9, 15, 13, 38),
        lastEditedAtUtc: DateTime.utc(2026, 9, 15, 13, 37),
      ),
      throwsArgumentError,
    );
  });

  testWidgets('article page publishes the complete identity story', (
    tester,
  ) async {
    await tester.pumpWidget(_localizedApp(_articlesPage()));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('articles-page')), findsOneWidget);
    expect(
      tester.widget<AppBar>(find.byType(AppBar)).title,
      isA<PortfolioTopBarContent>(),
    );
    expect(find.text('PUBLISHED'), findsNothing);
    expect(find.byKey(const Key('article-published-at')), findsOneWidget);
    expect(find.byKey(const Key('article-last-edited-at')), findsNothing);
    expect(find.text('Published Sep 15, 2026 · 10:38 AM BRT'), findsOneWidget);
    expect(
      find.descendant(
        of: find.byKey(const Key('article-reading-column')),
        matching: find.text(
          "How I designed this portfolio's logo and visual identity",
        ),
      ),
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
      _localizedApp(_articlesPage(), locale: const Locale('pt')),
    );
    await tester.pumpAndSettle();

    expect(find.text('PUBLICADO'), findsNothing);
    expect(find.byKey(const Key('article-published-at')), findsOneWidget);
    expect(find.byKey(const Key('article-last-edited-at')), findsNothing);
    final published = tester.widget<Text>(
      find.descendant(
        of: find.byKey(const Key('article-published-at')),
        matching: find.byType(Text),
      ),
    );
    expect(published.data, startsWith('Publicado em 15'));
    expect(published.data, contains('set.'));
    expect(published.data, contains('2026 · 10:38 BRT'));
    expect(find.textContaining('L.D.'), findsWidgets);
    expect(find.textContaining('Material Design 3'), findsOneWidget);
    expect(find.textContaining('microcorte'), findsWidgets);
    expect(find.textContaining('viewport'), findsWidgets);
    expect(tester.takeException(), isNull);
  });

  testWidgets('article share badges expose canonical social URLs', (
    tester,
  ) async {
    await tester.pumpWidget(_localizedApp(_articlesPage()));
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

    await tester.pumpWidget(_localizedApp(_articlesPage()));
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

  testWidgets('article hides related reading when no other article exists', (
    tester,
  ) async {
    for (final size in [const Size(390, 844), const Size(1440, 1000)]) {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1;

      await tester.pumpWidget(_localizedApp(_articlesPage()));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('article-share-badges')), findsOneWidget);
      expect(find.byKey(const Key('related-articles-section')), findsNothing);
      expect(find.byKey(const Key('related-articles-divider')), findsNothing);
      expect(find.byKey(const Key('related-articles-heading')), findsNothing);
      expect(tester.takeException(), isNull);
    }
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  });

  testWidgets('wide article stays centered in a readable column', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1440, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(_localizedApp(_articlesPage()));
    await tester.pumpAndSettle();

    final articleRect = tester.getRect(
      find.byKey(const Key('article-reading-column')),
    );
    expect(articleRect.width, lessThanOrEqualTo(920));
    expect(articleRect.center.dx, closeTo(720, 1));
    expect(tester.takeException(), isNull);
  });

  testWidgets('related articles follow the text in a quiet desktop grid', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1440, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final current = _articleEntry(id: 'current', title: 'Current article');
    final first = _articleEntry(id: 'first', title: 'First related article');
    final second = _articleEntry(id: 'second', title: 'Second related article');

    await tester.pumpWidget(
      _localizedApp(
        ArticlePageLayout(
          pageKey: const Key('test-article-page'),
          currentArticle: current,
          articles: [current, first, second],
          article: const SizedBox(
            key: Key('test-article-content'),
            width: double.infinity,
            height: 240,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final contentRect = tester.getRect(
      find.byKey(const Key('test-article-content')),
    );
    final relatedRect = tester.getRect(
      find.byKey(const Key('related-articles-section')),
    );
    final firstRect = tester.getRect(
      find.byKey(const Key('related-article-first')),
    );
    final secondRect = tester.getRect(
      find.byKey(const Key('related-article-second')),
    );
    final firstMaterial = tester.widget<Material>(
      find.byKey(const Key('related-article-first')),
    );

    expect(find.text('More to read'), findsOneWidget);
    expect(find.byKey(const Key('related-article-current')), findsNothing);
    expect(relatedRect.top, greaterThan(contentRect.bottom));
    expect(secondRect.width, closeTo(firstRect.width, 1));
    expect(secondRect.top, closeTo(firstRect.top, 1));
    expect(secondRect.left, greaterThan(firstRect.right));
    expect(firstRect.left, greaterThanOrEqualTo(relatedRect.left));
    expect(secondRect.right, lessThanOrEqualTo(relatedRect.right));
    expect(firstMaterial.color, Colors.transparent);
    expect(tester.takeException(), isNull);
  });

  testWidgets('related articles form a vertical list after text on mobile', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final current = _articleEntry(id: 'current', title: 'Current article');
    final first = _articleEntry(id: 'first', title: 'First related article');
    final second = _articleEntry(id: 'second', title: 'Second related article');

    await tester.pumpWidget(
      _localizedApp(
        ArticlePageLayout(
          pageKey: const Key('test-article-page'),
          currentArticle: current,
          articles: [current, first, second],
          article: const SizedBox(
            key: Key('test-article-content'),
            width: double.infinity,
            height: 180,
          ),
        ),
        locale: const Locale('pt'),
      ),
    );
    await tester.pumpAndSettle();

    final contentRect = tester.getRect(
      find.byKey(const Key('test-article-content')),
    );
    final relatedRect = tester.getRect(
      find.byKey(const Key('related-articles-section')),
    );
    final firstRect = tester.getRect(
      find.byKey(const Key('related-article-first')),
    );
    final secondRect = tester.getRect(
      find.byKey(const Key('related-article-second')),
    );

    expect(find.text('Leia também'), findsOneWidget);
    expect(relatedRect.top, greaterThan(contentRect.bottom));
    expect(secondRect.top, greaterThan(firstRect.bottom));
    expect(firstRect.width, closeTo(secondRect.width, 1));
    expect(tester.takeException(), isNull);
  });

  testWidgets('article layout respects lateral safe-area insets', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1440, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      _localizedApp(
        MediaQuery(
          data: const MediaQueryData(
            padding: EdgeInsets.only(left: 48, right: 64),
          ),
          child: _articlesPage(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final articleRect = tester.getRect(
      find.byKey(const Key('article-reading-column')),
    );
    expect(articleRect.left, greaterThanOrEqualTo(48));
    expect(articleRect.right, lessThanOrEqualTo(1440 - 64));
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'article navigation truncates copy but keeps complete semantics',
    (tester) async {
      tester.view.physicalSize = const Size(320, 900);
      tester.view.devicePixelRatio = 1;
      tester.platformDispatcher.textScaleFactorTestValue = 2;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
      final semantics = tester.ensureSemantics();

      const title = 'A deliberately long article title for a compact card';
      const summary =
          'A complete summary that remains available to assistive technology '
          'even when the visual copy is shortened.';
      final entry = _articleEntry(id: 'long', title: title, summary: summary);

      await tester.pumpWidget(
        _localizedApp(
          Scaffold(body: RelatedArticlesNavigation(entries: [entry])),
        ),
      );
      await tester.pumpAndSettle();

      final titleText = tester.widget<Text>(
        find.byKey(const Key('related-article-title-long')),
      );
      final summaryText = tester.widget<Text>(
        find.byKey(const Key('related-article-summary-long')),
      );
      final cardSize = tester.getSize(
        find.byKey(const Key('related-article-long')),
      );
      final relatedArticle = tester.getSemantics(
        find.bySemanticsLabel('Open article: $title. $summary'),
      );
      final navigation = tester.getSemantics(
        find.bySemanticsLabel('More articles to read'),
      );

      expect(titleText.maxLines, 2);
      expect(titleText.overflow, TextOverflow.ellipsis);
      expect(summaryText.maxLines, 2);
      expect(summaryText.overflow, TextOverflow.ellipsis);
      expect(cardSize.height, lessThan(300));
      expect(relatedArticle.label, contains(title));
      expect(relatedArticle.label, contains(summary));
      expect(relatedArticle.getSemanticsData().flagsCollection.isLink, isTrue);
      expect(
        relatedArticle.getSemanticsData().flagsCollection.isButton,
        isFalse,
      );
      expect(
        relatedArticle.getSemanticsData().hasAction(SemanticsAction.tap),
        isTrue,
      );
      expect(navigation.getSemanticsData().role, SemanticsRole.navigation);
      expect(tester.takeException(), isNull);
      semantics.dispose();
    },
  );

  testWidgets('article navigation exposes an internal route link', (
    tester,
  ) async {
    final other = _articleEntry(
      id: 'other',
      routeName: '/articles/other',
      title: 'Another article',
    );

    await tester.pumpWidget(
      _localizedApp(
        Scaffold(body: RelatedArticlesNavigation(entries: [other])),
      ),
    );
    await tester.pumpAndSettle();

    final link = tester.widget<Link>(find.byType(Link));
    final inkWell = tester.widget<InkWell>(
      find.descendant(
        of: find.byKey(const Key('related-article-other')),
        matching: find.byType(InkWell),
      ),
    );
    expect(link.uri, Uri.parse(other.routeName));
    expect(link.target, LinkTarget.defaultTarget);
    expect(inkWell.onTap, isNotNull);
  });

  testWidgets('article metadata reveals the optional last edition', (
    tester,
  ) async {
    await tester.pumpWidget(
      _localizedApp(
        Scaffold(
          body: ArticlePublicationLine(
            info: ArticlePublicationInfo(
              publishedAtUtc: DateTime.utc(2026, 9, 14, 21, 19),
              lastEditedAtUtc: DateTime.utc(2026, 9, 16, 13, 5),
            ),
          ),
        ),
      ),
    );

    expect(find.byKey(const Key('article-metadata')), findsOneWidget);
    expect(find.byKey(const Key('article-published-at')), findsOneWidget);
    expect(find.byKey(const Key('article-last-edited-at')), findsOneWidget);
    expect(find.textContaining('Published Sep 14, 2026'), findsOneWidget);
    expect(find.textContaining('Last edited Sep 16, 2026'), findsOneWidget);
    expect(find.textContaining('10:05 AM BRT'), findsOneWidget);
  });

  testWidgets('article metadata omits an unchanged edition timestamp', (
    tester,
  ) async {
    final timestamp = DateTime.utc(2026, 9, 15, 13, 38);
    await tester.pumpWidget(
      _localizedApp(
        Scaffold(
          body: ArticlePublicationLine(
            info: ArticlePublicationInfo(
              publishedAtUtc: timestamp,
              lastEditedAtUtc: timestamp,
            ),
          ),
        ),
      ),
    );

    expect(find.byKey(const Key('article-published-at')), findsOneWidget);
    expect(find.byKey(const Key('article-last-edited-at')), findsNothing);
  });

  testWidgets('article card metadata fits a narrow viewport with large text', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 900);
    tester.view.devicePixelRatio = 1;
    tester.platformDispatcher.textScaleFactorTestValue = 2;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

    await tester.pumpWidget(
      _localizedApp(
        Scaffold(
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: ArticlesSection(onOpenArticles: () {}),
          ),
        ),
        locale: const Locale('pt'),
      ),
    );
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byKey(const Key('article-metadata')));
    await tester.pumpAndSettle();

    final metadataRect = tester.getRect(
      find.byKey(const Key('article-metadata')),
    );
    expect(metadataRect.left, greaterThanOrEqualTo(0));
    expect(metadataRect.right, lessThanOrEqualTo(320));
    expect(
      tester.getSize(find.byKey(const Key('open-articles-page'))).height,
      lessThan(1800),
    );
    expect(find.text('PUBLICADO'), findsNothing);
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
    final semantics = tester.ensureSemantics();

    await tester.pumpWidget(
      _localizedApp(_articlesPage(), locale: const Locale('pt')),
    );
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byKey(const Key('article-share-badges')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('identity-exploded-figure')), findsOneWidget);
    expect(find.byKey(const Key('identity-fab-figure')), findsOneWidget);
    expect(find.byKey(const Key('article-share-badges')), findsOneWidget);
    for (final key in [
      const Key('language-toggle'),
      const Key('theme-toggle'),
      const Key('header-contact-button'),
    ]) {
      final rect = tester.getRect(find.byKey(key));
      expect(rect.left, greaterThanOrEqualTo(0));
      expect(rect.right, lessThanOrEqualTo(320));
      expect(rect.width, greaterThanOrEqualTo(48));
      expect(rect.height, greaterThanOrEqualTo(48));
    }
    expect(find.bySemanticsLabel('Escolher idioma: English'), findsOneWidget);
    expect(find.bySemanticsLabel('Mudar para tema claro'), findsOneWidget);
    expect(find.bySemanticsLabel('Opções de contato'), findsOneWidget);
    expect(tester.takeException(), isNull);
    semantics.dispose();
  });

  testWidgets(
    'article header changes language and theme and opens contact options',
    (tester) async {
      SharedPreferences.setMockInitialValues({
        'portfolio_locale': 'en',
        'portfolio_theme': 'dark',
      });
      final semantics = tester.ensureSemantics();
      await tester.pumpWidget(const LeonePortfolioApp());
      await tester.pump();
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      final navigator = tester.state<NavigatorState>(find.byType(Navigator));
      navigator.pushNamed(ArticlesPage.routeName);
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('language-toggle')), findsOneWidget);
      expect(find.byKey(const Key('theme-toggle')), findsOneWidget);
      expect(find.byKey(const Key('header-contact-button')), findsOneWidget);
      final contactSemantics = tester.getSemantics(
        find.bySemanticsLabel('Contact options'),
      );
      expect(
        contactSemantics.getSemanticsData().flagsCollection.isLink,
        isFalse,
      );
      expect(
        contactSemantics.getSemanticsData().flagsCollection.isButton,
        isTrue,
      );
      expect(
        contactSemantics
            .getSemanticsData()
            .flagsCollection
            .isExpanded
            .toBoolOrNull(),
        isFalse,
      );

      await tester.tap(find.byKey(const Key('header-contact-button')));
      await tester.pumpAndSettle();
      final contactLinks = {
        'whatsapp': PortfolioContactLinks.whatsApp,
        'calendly': PortfolioContactLinks.calendly,
        'linkedin': PortfolioContactLinks.linkedin,
        'github': PortfolioContactLinks.github,
      };
      for (final entry in contactLinks.entries) {
        final link = tester.widget<Link>(
          find.byKey(Key('header-contact-link-${entry.key}')),
        );
        expect(link.uri, entry.value);
        expect(link.target, LinkTarget.blank);
      }
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('language-toggle')));
      await tester.pumpAndSettle();
      expect(
        find.text(
          'Como desenvolvi a logo e a identidade visual deste portfólio',
        ),
        findsOneWidget,
      );

      await tester.tap(find.byKey(const Key('theme-toggle')));
      await tester.pumpAndSettle();
      expect(
        Theme.of(
          tester.element(find.byKey(const Key('articles-page'))),
        ).brightness,
        Brightness.light,
      );

      final preferences = await SharedPreferences.getInstance();
      expect(preferences.getString('portfolio_locale'), 'pt');
      expect(preferences.getString('portfolio_theme'), 'light');
      semantics.dispose();
    },
  );

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

Widget _articlesPage() =>
    ArticlesPage(onLocaleChanged: (_) {}, onThemeModeChanged: (_) {});

ArticleEntry _articleEntry({
  required String id,
  String? routeName,
  required String title,
  String summary = 'A concise article summary.',
}) => ArticleEntry(
  id: id,
  routeName: routeName ?? '/articles/$id',
  canonicalUri: Uri.parse('https://example.com/articles/$id'),
  title: title,
  summary: summary,
  publicationInfo: ArticlePublicationInfo(
    publishedAtUtc: DateTime.utc(2026, 9, 15, 13, 38),
  ),
  lightThumbnailAsset: 'assets/brand/ld-mark.svg',
  darkThumbnailAsset: 'assets/brand/ld-mark-inverse.svg',
);
