import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:leone_portfolio/brand/leone_brand.dart';
import 'package:leone_portfolio/features/articles/articles.dart';
import 'package:leone_portfolio/features/apps/production_apps.dart';
import 'package:leone_portfolio/features/certificates/certificate_catalog.dart';
import 'package:leone_portfolio/features/certificates/certifications_section.dart';
import 'package:leone_portfolio/features/clients/client_logo_cloud.dart';
import 'package:leone_portfolio/features/contact/portfolio_contact_links.dart';
import 'package:leone_portfolio/features/navigation/portfolio_fab_menu.dart';
import 'package:leone_portfolio/l10n/app_localizations.dart';
import 'package:leone_portfolio/main.dart';
import 'package:leone_portfolio/world_experience_map.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/link.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  testWidgets('paints the opening mark before mounting the portfolio home', (
    tester,
  ) async {
    await tester.pumpWidget(const LeonePortfolioApp());

    expect(find.byKey(const Key('ld-opening-transition')), findsOneWidget);
    expect(find.byKey(const Key('portfolio-home-page')), findsNothing);

    await tester.pump();

    expect(find.byKey(const Key('portfolio-home-page')), findsOneWidget);
    expect(find.byKey(const Key('ld-opening-transition')), findsOneWidget);
  });

  testWidgets(
    'mobile app routes follow system back without replaying the opening',
    (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(const LeonePortfolioApp());
      await _finishOpening(tester);

      final homeScroll = find.byKey(const Key('portfolio-scroll-view'));
      final homeScrollable = find.descendant(
        of: homeScroll,
        matching: find.byType(Scrollable),
      );
      await tester.scrollUntilVisible(
        find.byKey(const Key('view-all-apps-button')),
        500,
        scrollable: homeScrollable,
      );
      await tester.tap(find.byKey(const Key('view-all-apps-button')));
      await tester.pumpAndSettle();

      final catalog = find.byKey(const Key('all-apps-scroll-view'));
      expect(catalog, findsOneWidget);
      expect(
        ModalRoute.of(tester.element(catalog))?.settings.name,
        ProductionAppsRoutes.catalog,
      );

      await tester.tap(find.byKey(const Key('app-store-tile-van-cranenbroek')));
      await tester.pumpAndSettle();

      final detail = find.byKey(
        const Key('app-detail-scroll-view-van-cranenbroek'),
      );
      expect(detail, findsOneWidget);
      expect(
        ModalRoute.of(tester.element(detail))?.settings.name,
        '/apps/van-cranenbroek',
      );

      expect(await tester.binding.handlePopRoute(), isTrue);
      await tester.pumpAndSettle();
      expect(catalog, findsOneWidget);

      expect(await tester.binding.handlePopRoute(), isTrue);
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('portfolio-home-page')), findsOneWidget);
      expect(find.byKey(const Key('ld-opening-transition')), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'system back scrolls home to the top before leaving the portfolio',
    (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(const LeonePortfolioApp());
      await _finishOpening(tester);

      final homeScroll = find.byKey(const Key('portfolio-scroll-view'));
      await tester.drag(homeScroll, const Offset(0, -700));
      await tester.pumpAndSettle();
      expect(
        tester
            .state<ScrollableState>(
              find.descendant(
                of: homeScroll,
                matching: find.byType(Scrollable),
              ),
            )
            .position
            .pixels,
        greaterThan(0),
      );

      expect(await tester.binding.handlePopRoute(), isTrue);
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('portfolio-home-page')), findsOneWidget);
      expect(
        tester
            .state<ScrollableState>(
              find.descendant(
                of: homeScroll,
                matching: find.byType(Scrollable),
              ),
            )
            .position
            .pixels,
        closeTo(0, .01),
      );
      expect(await tester.binding.handlePopRoute(), isFalse);
    },
  );

  testWidgets('direct app links return home before releasing system back', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const LeonePortfolioApp(initialRoute: '/apps/mag-venda-digital'),
    );
    await tester.pumpAndSettle();

    expect(
      find.byKey(const Key('app-detail-scroll-view-mag-venda-digital')),
      findsOneWidget,
    );
    expect(find.byKey(const Key('article-back-button')), findsOneWidget);
    expect(find.byKey(const Key('ld-opening-transition')), findsNothing);

    expect(await tester.binding.handlePopRoute(), isTrue);
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('portfolio-home-page')), findsOneWidget);
    expect(find.byKey(const Key('ld-opening-transition')), findsNothing);
    expect(await tester.binding.handlePopRoute(), isFalse);
  });

  testWidgets('renders a simplified hero fixed on the mobile focus', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1440, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const LeonePortfolioApp());
    expect(find.byKey(const Key('ld-opening-transition')), findsOneWidget);
    await _finishOpening(tester);
    expect(find.byKey(const Key('ld-opening-transition')), findsNothing);

    expect(find.text('Leone'), findsOneWidget);
    expect(find.text('Mobile Software Engineer'), findsOneWidget);
    expect(find.byKey(const Key('ld-topbar-mark')), findsOneWidget);
    expect(find.byKey(const Key('ld-viewport-frame-action')), findsNothing);
    expect(find.byKey(const Key('ld-viewport-frame-content')), findsOneWidget);
    expect(find.byKey(const Key('portfolio-floating-action')), findsOneWidget);
    expect(find.text('MOBILE'), findsNothing);
    expect(find.text('TABLET'), findsNothing);
    expect(find.text('DESKTOP'), findsNothing);
    expect(find.text('YOUR IDEAS. EVERYWHERE.'), findsOneWidget);
    expect(
      find.text('Mobile products powered by smart, connected systems.'),
      findsNothing,
    );
    expect(find.text('Mobile'), findsNothing);
    expect(find.text('AI + Automation'), findsNothing);
    expect(find.text('AI Automation Engineer'), findsNothing);
  });

  testWidgets('starts in dark mode and persists the theme choice', (
    tester,
  ) async {
    await tester.pumpWidget(const LeonePortfolioApp());
    await _finishOpening(tester);

    final home = find.byKey(const Key('portfolio-home-page'));
    expect(Theme.of(tester.element(home)).brightness, Brightness.dark);
    expect(find.bySemanticsLabel('Switch to light theme'), findsOneWidget);

    await tester.tap(find.byKey(const Key('theme-toggle')));
    await tester.pumpAndSettle();
    expect(Theme.of(tester.element(home)).brightness, Brightness.light);
    expect(find.bySemanticsLabel('Switch to dark theme'), findsOneWidget);

    final preferences = await SharedPreferences.getInstance();
    expect(preferences.getString('portfolio_theme'), 'light');
  });

  testWidgets('keeps the top app bar pinned without a section navbar', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1440, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const LeonePortfolioApp());
    await _finishOpening(tester);

    final fixedTopBar = find.byKey(const Key('portfolio-fixed-top-bar'));
    final initialRect = tester.getRect(fixedTopBar);
    expect(initialRect.top, 0);
    expect(initialRect.height, 72);
    expect(
      find.descendant(of: fixedTopBar, matching: find.byType(BackdropFilter)),
      findsOneWidget,
    );
    expect(find.byKey(const Key('top-nav-home')), findsNothing);
    expect(find.byKey(const Key('top-nav-apps')), findsNothing);
    expect(find.byKey(const Key('top-nav-system')), findsNothing);
    expect(find.byKey(const Key('top-nav-clients')), findsNothing);
    expect(find.byKey(const Key('top-nav-contact')), findsNothing);

    await tester.drag(
      find.byKey(const Key('portfolio-scroll-view')),
      const Offset(0, -600),
    );
    await tester.pumpAndSettle();

    expect(tester.getRect(fixedTopBar), initialRect);

    tester.platformDispatcher.accessibilityFeaturesTestValue =
        const FakeAccessibilityFeatures(highContrast: true);
    addTearDown(tester.platformDispatcher.clearAccessibilityFeaturesTestValue);
    await tester.pumpAndSettle();

    final highContrastBackground = tester.widget<ColoredBox>(
      find.descendant(of: fixedTopBar, matching: find.byType(ColoredBox)),
    );
    expect(highContrastBackground.color, LeonePalette.glassDark.canvas);
    expect(
      find.descendant(of: fixedTopBar, matching: find.byType(BackdropFilter)),
      findsNothing,
    );
  });

  testWidgets('top CTA opens four contact options without assuming a channel', (
    tester,
  ) async {
    await tester.pumpWidget(const LeonePortfolioApp());
    await _finishOpening(tester);

    final contactButton = find.byKey(const Key('header-contact-button'));
    final collapsedSemantics = tester.getSemantics(
      find.bySemanticsLabel('Contact options'),
    );
    expect(contactButton, findsOneWidget);
    expect(tester.getSize(contactButton).height, 48);
    expect(
      collapsedSemantics.getSemanticsData().flagsCollection.isButton,
      true,
    );
    expect(collapsedSemantics.getSemanticsData().flagsCollection.isLink, false);
    expect(
      collapsedSemantics
          .getSemanticsData()
          .flagsCollection
          .isExpanded
          .toBoolOrNull(),
      false,
    );
    expect(find.byKey(const Key('header-contact-link-whatsapp')), findsNothing);

    await tester.tap(contactButton);
    await tester.pumpAndSettle();

    final expectedLinks = {
      'whatsapp': PortfolioContactLinks.whatsApp,
      'calendly': PortfolioContactLinks.calendly,
      'linkedin': PortfolioContactLinks.linkedin,
      'github': PortfolioContactLinks.github,
    };
    for (final entry in expectedLinks.entries) {
      final item = find.byKey(Key('header-contact-item-${entry.key}'));
      final link = tester.widget<Link>(
        find.byKey(Key('header-contact-link-${entry.key}')),
      );
      expect(item, findsOneWidget);
      expect(tester.getSize(item).height, greaterThanOrEqualTo(48));
      expect(link.uri, entry.value);
      expect(link.target, LinkTarget.blank);
    }
    final expandedSemantics = tester.getSemantics(
      find.bySemanticsLabel('Contact options'),
    );
    expect(
      expandedSemantics
          .getSemanticsData()
          .flagsCollection
          .isExpanded
          .toBoolOrNull(),
      true,
    );

    final itemOrder = expectedLinks.keys
        .map(
          (id) =>
              tester.getTopLeft(find.byKey(Key('header-contact-item-$id'))).dy,
        )
        .toList();
    expect(itemOrder, orderedEquals([...itemOrder]..sort()));

    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('header-contact-item-whatsapp')), findsNothing);

    await tester.drag(
      find.byKey(const Key('portfolio-scroll-view')),
      const Offset(0, -10000),
    );
    await tester.pumpAndSettle();
    final calendlyLink = tester.widget<Link>(
      find.byKey(const Key('contact-link-schedule')),
    );
    expect(calendlyLink.uri, PortfolioContactLinks.calendly);
    expect(calendlyLink.target, LinkTarget.blank);
  });

  testWidgets('article moves horizontally while the top header stays fixed', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1440, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const LeonePortfolioApp());
    await _finishOpening(tester);

    final fixedHeader = find.byKey(const Key('portfolio-fixed-top-bar'));
    final headerRect = tester.getRect(fixedHeader);
    final contentRect = tester.getRect(
      find.descendant(
        of: fixedHeader,
        matching: find.byKey(const Key('portfolio-top-bar-content')),
      ),
    );
    final markRect = tester.getRect(find.byKey(const Key('ld-topbar-mark')));
    final controlRects = {
      for (final key in const [
        Key('language-toggle'),
        Key('theme-toggle'),
        Key('header-contact-button'),
      ])
        key: tester.getRect(find.byKey(key)),
    };

    final navigator = tester.state<NavigatorState>(find.byType(Navigator));
    navigator.pushNamed(ArticlesPage.routeName);
    await tester.pump();
    await tester.pump();

    expect(find.byKey(const Key('articles-page')), findsOneWidget);
    final route = ModalRoute.of(
      tester.element(find.byKey(const Key('articles-page'))),
    )!;
    expect(route.transitionDuration, LeoneBrandMotion.pageTransitionForward);
    expect(
      route.reverseTransitionDuration,
      LeoneBrandMotion.pageTransitionReverse,
    );

    final articleBackButton = find.byKey(const Key('article-back-button'));
    final movingSurface = find.byKey(
      const Key('article-page-transition-surface'),
    );
    final homePage = find.byKey(
      const Key('portfolio-home-page'),
      skipOffstage: false,
    );

    final startX = tester.getTopLeft(movingSurface).dx;
    expect(startX, closeTo(1440, .01));
    expect(find.byKey(const Key('portfolio-page-app-bar')), findsNothing);
    expect(tester.getRect(fixedHeader), headerRect);
    expect(tester.getRect(articleBackButton), markRect);
    for (final entry in controlRects.entries) {
      expect(tester.getRect(find.byKey(entry.key)), entry.value);
    }
    expect(tester.getTopLeft(homePage).dx, closeTo(0, .01));

    await tester.pump(const Duration(milliseconds: 175));

    final middleX = tester.getTopLeft(movingSurface).dx;
    final homeMiddleX = tester.getTopLeft(homePage).dx;
    expect(middleX, greaterThan(0));
    expect(middleX, lessThan(startX));
    expect(homeMiddleX, greaterThan(-1440));
    expect(homeMiddleX, lessThan(0));
    expect(tester.getRect(fixedHeader), headerRect);
    expect(
      tester.getRect(
        find.descendant(
          of: fixedHeader,
          matching: find.byKey(const Key('portfolio-top-bar-content')),
        ),
      ),
      contentRect,
    );
    expect(tester.getRect(articleBackButton), markRect);
    for (final entry in controlRects.entries) {
      expect(tester.getRect(find.byKey(entry.key)), entry.value);
    }

    await tester.pump(const Duration(milliseconds: 175));

    expect(tester.getTopLeft(movingSurface).dx, closeTo(0, .01));
    expect(tester.getRect(fixedHeader), headerRect);
    expect(tester.getRect(articleBackButton), markRect);

    await tester.tap(articleBackButton);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 150));

    final reverseMiddleX = tester.getTopLeft(movingSurface).dx;
    final homeReverseMiddleX = tester.getTopLeft(homePage).dx;
    expect(reverseMiddleX, greaterThan(0));
    expect(reverseMiddleX, lessThan(startX));
    expect(homeReverseMiddleX, greaterThan(-1440));
    expect(homeReverseMiddleX, lessThan(0));
    expect(tester.getRect(fixedHeader), headerRect);
    expect(tester.getRect(articleBackButton), markRect);

    await tester.pumpAndSettle();

    expect(find.byKey(const Key('articles-page')), findsNothing);
    expect(tester.getRect(fixedHeader), headerRect);
    expect(tester.getRect(find.byKey(const Key('ld-topbar-mark'))), markRect);
  });

  for (final reducedMotion in const [
    ('disabled animations', FakeAccessibilityFeatures(disableAnimations: true)),
    ('reduced motion', FakeAccessibilityFeatures(reduceMotion: true)),
  ]) {
    testWidgets('article skips page motion with ${reducedMotion.$1}', (
      tester,
    ) async {
      tester.platformDispatcher.accessibilityFeaturesTestValue =
          reducedMotion.$2;
      addTearDown(
        tester.platformDispatcher.clearAccessibilityFeaturesTestValue,
      );

      tester.view.physicalSize = const Size(1440, 1000);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(const LeonePortfolioApp());
      await _finishOpening(tester);

      final navigator = tester.state<NavigatorState>(find.byType(Navigator));
      navigator.pushNamed(ArticlesPage.routeName);
      await tester.pump();
      await tester.pump();

      final page = find.byKey(const Key('articles-page'));
      expect(page, findsOneWidget);
      final route = ModalRoute.of(tester.element(page))!;
      expect(route.transitionDuration, Duration.zero);
      expect(route.reverseTransitionDuration, Duration.zero);
      expect(
        tester
            .getTopLeft(
              find.byKey(const Key('article-page-transition-surface')),
            )
            .dx,
        closeTo(0, .01),
      );
    });
  }

  testWidgets(
    'contact menu stays inside a compact viewport and dismisses outside',
    (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(const LeonePortfolioApp());
      await _finishOpening(tester);

      final button = find.byKey(const Key('header-contact-button'));
      expect(tester.getSize(button), const Size(48, 48));
      await tester.tap(button);
      await tester.pumpAndSettle();

      final buttonRect = tester.getRect(button);
      for (final id in const ['whatsapp', 'calendly', 'linkedin', 'github']) {
        final rect = tester.getRect(find.byKey(Key('header-contact-item-$id')));
        expect(rect.left, greaterThanOrEqualTo(8));
        expect(rect.right, lessThanOrEqualTo(382));
        expect(rect.top, greaterThan(buttonRect.bottom));
      }

      await tester.tapAt(const Offset(16, 500));
      await tester.pumpAndSettle();
      expect(
        find.byKey(const Key('header-contact-item-whatsapp')),
        findsNothing,
      );
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('returns to the top when the header mark is tapped', (
    tester,
  ) async {
    await tester.pumpWidget(const LeonePortfolioApp());
    await _finishOpening(tester);

    final scrollable = find.byKey(const Key('portfolio-scroll-view'));
    await tester.drag(scrollable, const Offset(0, -900));
    await tester.pumpAndSettle();

    final position = tester
        .state<ScrollableState>(find.byType(Scrollable).first)
        .position;
    expect(position.pixels, greaterThan(0));

    await tester.tap(find.byKey(const Key('ld-topbar-mark')));
    await tester.pumpAndSettle();

    expect(position.pixels, 0);
  });

  testWidgets('morphs the FAB-free frame and reflows its complete interface', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const LeonePortfolioApp());
    await _finishOpening(tester);

    final frame = find.byKey(const Key('ld-viewport-frame-content'));
    final stage = find.byKey(const Key('hero-viewport-stage'));
    final hero = find.byKey(const Key('portfolio-hero'));
    final navigation = find.byKey(const Key('hero-interface-navigation'));
    final message = find.byKey(const Key('hero-interface-message'));
    final desktopInput = find.byKey(const Key('hero-desktop-input-sketch'));

    expect(find.byKey(const Key('ld-viewport-frame-action')), findsNothing);
    expect(tester.getSize(hero).height, 620);
    expect(
      find.byKey(const Key('hero-interface-secondary-card')),
      findsOneWidget,
    );
    final messageText = tester.widget<Text>(
      find.descendant(
        of: message,
        matching: find.text('YOUR IDEAS.\nEVERYWHERE.'),
      ),
    );
    expect(messageText.maxLines, 2);

    final desktopSize = tester.getSize(frame);
    final desktopFrameOrigin = tester.getTopLeft(frame);
    final desktopNavigation =
        tester.getTopLeft(navigation) - desktopFrameOrigin;
    final desktopMessage = tester.getTopLeft(message) - desktopFrameOrigin;
    expect(desktopSize.width, greaterThan(desktopSize.height));
    expect(desktopInput, findsOneWidget);
    expect(tester.widget<Opacity>(desktopInput).opacity, closeTo(.38, .001));
    expect(
      tester.getTopLeft(desktopInput).dy,
      greaterThan(tester.getBottomLeft(frame).dy),
    );
    expect(desktopNavigation.dx, lessThan(desktopMessage.dx));
    expect(
      tester.getTopLeft(frame).dy,
      closeTo(tester.getTopLeft(stage).dy, .01),
    );
    expect(
      tester.getBottomRight(frame).dy,
      lessThanOrEqualTo(tester.view.physicalSize.height),
    );

    await tester.pump(LeoneBrandMotion.viewportHold);
    await tester.pump(LeoneBrandMotion.viewportTransition);

    final mobileSize = tester.getSize(frame);
    final mobileFrameOrigin = tester.getTopLeft(frame);
    final mobileNavigation = tester.getTopLeft(navigation) - mobileFrameOrigin;
    final mobileMessage = tester.getTopLeft(message) - mobileFrameOrigin;
    expect(mobileSize.height, greaterThan(mobileSize.width));
    expect(mobileSize.width / desktopSize.width, lessThan(.66));
    expect(tester.widget<Opacity>(desktopInput).opacity, 0);
    expect(mobileNavigation.dy, greaterThan(mobileMessage.dy));
    expect(find.text('YOUR IDEAS.\nEVERYWHERE.'), findsOneWidget);
    expect(
      tester.getBottomRight(frame).dy,
      lessThanOrEqualTo(tester.view.physicalSize.height),
    );
    expect(
      tester.getBottomRight(hero).dy - tester.getBottomRight(frame).dy,
      lessThan(110),
    );

    await tester.pump(LeoneBrandMotion.viewportHold);
    await tester.pump(LeoneBrandMotion.viewportTransition);

    final tabletSize = tester.getSize(frame);
    expect(tabletSize.width, greaterThan(tabletSize.height));
    expect(tabletSize.width / tabletSize.height, closeTo(316 / 240, .01));
    expect(
      tester.getBottomRight(frame).dy,
      lessThanOrEqualTo(tester.view.physicalSize.height),
    );
    expect(find.byKey(const Key('ld-mode-mobile')), findsNothing);
    expect(find.byKey(const Key('ld-mode-tablet')), findsNothing);
    expect(find.byKey(const Key('ld-mode-desktop')), findsNothing);
    expect(
      find.byKey(const Key('hero-interface-primary-card')),
      findsOneWidget,
    );
    expect(
      find.byKey(const Key('hero-interface-secondary-card')),
      findsOneWidget,
    );
    expect(find.byKey(const Key('hero-interface-identifiers')), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('opens an end-aligned Material 3 FAB menu with exact spacing', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1440, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const LeonePortfolioApp());
    await _finishOpening(tester);

    final fab = find.byKey(const Key('portfolio-floating-action'));
    expect(find.bySemanticsLabel('Open navigation menu'), findsOneWidget);
    expect(
      find.descendant(of: fab, matching: find.byIcon(Icons.menu_rounded)),
      findsOneWidget,
    );

    await tester.tap(fab);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.bySemanticsLabel('Close navigation menu'), findsOneWidget);
    expect(
      find.descendant(of: fab, matching: find.byIcon(Icons.close_rounded)),
      findsOneWidget,
    );
    const itemKeys = [
      Key('fab-menu-home'),
      Key('fab-menu-apps'),
      Key('fab-menu-system'),
      Key('fab-menu-clients'),
      Key('fab-menu-contact'),
    ];
    final itemRects = <Rect>[];
    for (final key in itemKeys) {
      final item = find.byKey(key);
      expect(item.hitTestable(), findsOneWidget);
      final rect = tester.getRect(item);
      expect(rect.height, closeTo(56, .01));
      itemRects.add(rect);
    }

    final fabRect = tester.getRect(fab);
    for (final rect in itemRects) {
      expect((rect.right - fabRect.right).abs(), lessThan(.01));
    }
    for (var index = 0; index < itemRects.length - 1; index++) {
      expect(
        itemRects[index + 1].top - itemRects[index].bottom,
        closeTo(4, .01),
      );
    }
    expect(fabRect.top - itemRects.last.bottom, closeTo(8, .01));
    expect(tester.takeException(), isNull);
  });

  testWidgets('FAB menu animates a light blur behind its controls', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1440, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const LeonePortfolioApp());
    await _finishOpening(tester);

    const backdropKey = Key('portfolio-menu-backdrop');
    final fab = find.byKey(const Key('portfolio-floating-action'));
    expect(find.byKey(backdropKey), findsNothing);

    await tester.tap(fab);
    await tester.pump();
    await tester.pump(LeoneBrandMotion.fabMenuExpand ~/ 2);

    final backdrop = find.byKey(backdropKey);
    expect(backdrop, findsOneWidget);
    expect(tester.getSize(backdrop), const Size(1440, 1000));
    expect(find.descendant(of: backdrop, matching: fab), findsNothing);
    expect(
      find.descendant(of: backdrop, matching: find.byType(ModalBarrier)),
      findsOneWidget,
    );

    await tester.tapAt(const Offset(24, 220));
    await tester.pump();
    expect(find.byKey(backdropKey), findsOneWidget);
    await tester.pump(LeoneBrandMotion.fabMenuCollapse);

    expect(find.byKey(backdropKey), findsNothing);
    expect(find.bySemanticsLabel('Open navigation menu'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('FAB menu navigates to the system section and closes', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1440, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const LeonePortfolioApp());
    await _finishOpening(tester);
    await tester.tap(find.byKey(const Key('portfolio-floating-action')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    await tester.tap(find.byKey(const Key('fab-menu-system')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 900));

    expect(
      find.byKey(const Key('fab-menu-system')).hitTestable(),
      findsNothing,
    );
    expect(find.bySemanticsLabel('Open navigation menu'), findsOneWidget);
    expect(find.text('Code with visible impact.'), findsNothing);
    final headingY = tester
        .getTopLeft(find.text('End-to-end product architecture.'))
        .dy;
    expect(headingY, inInclusiveRange(0, 180));
    expect(tester.takeException(), isNull);
  });

  testWidgets('FAB menu supports keyboard focus, Escape, and outside dismiss', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1440, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const LeonePortfolioApp());
    await _finishOpening(tester);

    final fabFinder = find.byKey(const Key('portfolio-floating-action'));
    await tester.tap(fabFinder);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    final fab = tester.widget<FloatingActionButton>(fabFinder);
    fab.focusNode!.requestFocus();
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.pump();

    final firstItemInk = find.descendant(
      of: find.byKey(const Key('fab-menu-home')),
      matching: find.byType(InkWell),
    );
    expect(tester.widget<InkWell>(firstItemInk).focusNode!.hasFocus, isTrue);

    await tester.sendKeyEvent(LogicalKeyboardKey.arrowUp);
    await tester.pump();
    expect(fab.focusNode!.hasFocus, isTrue);

    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 350));
    expect(find.bySemanticsLabel('Open navigation menu'), findsOneWidget);

    await tester.tap(fabFinder);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    await tester.tapAt(const Offset(24, 220));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 350));
    expect(find.bySemanticsLabel('Open navigation menu'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('FAB menu preserves the 16 px safe edge on mobile', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const LeonePortfolioApp());
    await _finishOpening(tester);
    await tester.tap(find.byKey(const Key('portfolio-floating-action')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    final fabRect = tester.getRect(
      find.byKey(const Key('portfolio-floating-action')),
    );
    final widestItemRect = tester.getRect(
      find.byKey(const Key('fab-menu-system')),
    );
    expect(fabRect.right, closeTo(374, .01));
    expect(fabRect.bottom, closeTo(828, .01));
    expect(widestItemRect.left, greaterThanOrEqualTo(16));
    expect(tester.takeException(), isNull);
  });

  testWidgets('keeps the left-aligned footer clear of the FAB', (tester) async {
    tester.view.physicalSize = const Size(1024, 1366);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const LeonePortfolioApp());
    await _finishOpening(tester);

    await tester.drag(
      find.byKey(const Key('portfolio-scroll-view')),
      const Offset(0, -10000),
    );
    await tester.pumpAndSettle();

    final signature = find.byKey(const Key('footer-signature'));
    final fab = find.byKey(const Key('portfolio-floating-action'));
    final signatureRect = tester.getRect(signature);

    expect(find.byKey(const Key('footer-invitation')), findsNothing);
    expect(signatureRect.left, closeTo(24, .01));
    expect(signatureRect.overlaps(tester.getRect(fab)), isFalse);
    expect(tester.takeException(), isNull);
  });

  testWidgets('anchors the wide footer to the left edge', (tester) async {
    tester.view.physicalSize = const Size(1440, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const LeonePortfolioApp());
    await _finishOpening(tester);
    await tester.drag(
      find.byKey(const Key('portfolio-scroll-view')),
      const Offset(0, -10000),
    );
    await tester.pumpAndSettle();

    final signatureRect = tester.getRect(
      find.byKey(const Key('footer-signature')),
    );

    expect(find.byKey(const Key('footer-invitation')), findsNothing);
    expect(signatureRect.left, closeTo(24, .01));
    expect(tester.takeException(), isNull);
  });

  testWidgets('keeps the map full-width with details and client logos below', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1440, 1800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(child: WorldExperienceMap()),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Clients'), findsOneWidget);
    expect(find.text('5 BRANDS'), findsOneWidget);
    expect(find.text('10 BRANDS'), findsOneWidget);
    expect(find.text('VIA LATITUDDE / CONKORD'), findsOneWidget);
    expect(find.text('LINELINKER PRO'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('does not mount the world map on the home page', (tester) async {
    tester.view.physicalSize = const Size(1440, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const LeonePortfolioApp());
    await _finishOpening(tester);
    await tester.pumpAndSettle();

    expect(find.byType(WorldExperienceMap), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('shows client banners independently from the map', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1440, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        theme: LeoneBrandTheme.dark(),
        localizationsDelegates: const [AppLocalizations.delegate],
        supportedLocales: AppLocalizations.supportedLocales,
        home: const Scaffold(
          body: SizedBox(width: 1200, child: ClientLogoCloud()),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('client-logo-cloud')), findsOneWidget);
    expect(find.text('Clients'), findsOneWidget);
    expect(find.text('13 BRANDS'), findsNothing);
    expect(find.text('DIRECT'), findsOneWidget);
    expect(find.text('VIA LATITUDDE / CONKORD'), findsOneWidget);
    expect(find.text('CLIENTS SERVED'), findsNothing);
    expect(find.text('5 BRANDS'), findsOneWidget);
    expect(find.text('10 BRANDS'), findsOneWidget);
    expect(find.textContaining('A brand indicates'), findsNothing);

    final directGroup = find.byKey(const Key('client-logo-group-direct'));
    final latituddeGroup = find.byKey(const Key('client-logo-group-latitudde'));
    for (final id in const [
      'mag-seguros',
      'human-robotics',
      'visagio',
      'radix',
      'conkord',
    ]) {
      expect(
        find.descendant(
          of: directGroup,
          matching: find.byKey(Key('client-logo-$id')),
        ),
        findsOneWidget,
      );
    }
    for (final id in const [
      'van-cranenbroek',
      'lyzer',
      'ctt',
      'ey',
      'iberdrola',
      'aguas-de-portugal',
      'agua-monchique',
      'fullsix',
      'code-495',
      'ascendi',
    ]) {
      expect(
        find.descendant(
          of: latituddeGroup,
          matching: find.byKey(Key('client-logo-$id')),
        ),
        findsOneWidget,
      );
    }
    expect(find.byType(WorldExperienceMap), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('shows certificates individually and animates filter changes', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1440, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final catalog = CertificateCatalog([
      _testCertificate(
        id: 'demo-credential',
        issuer: 'Anthropic Education',
        title: 'AI Fluency: AI Capabilities & Limitations',
        year: 2026,
        technologies: const ['AI', 'LLMs'],
      ),
      _testCertificate(
        id: 'mcp-credential',
        issuer: 'Anthropic Education',
        title: 'Model Context Protocol: Advanced Topics',
        year: 2026,
        technologies: const ['MCP', 'AI'],
      ),
      _testCertificate(
        id: 'claude-code-credential',
        issuer: 'Anthropic Education',
        title: 'Claude Code in Action',
        year: 2026,
        technologies: const ['Claude Code', 'AI Agents'],
      ),
      _testCertificate(
        id: 'flutter-credential',
        issuer: 'Udemy',
        title: 'The Complete Flutter Development Bootcamp with Dart',
        year: 2021,
        technologies: const ['Flutter', 'Dart'],
      ),
    ]);

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        theme: LeoneBrandTheme.dark(),
        localizationsDelegates: const [AppLocalizations.delegate],
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: SingleChildScrollView(
            child: CertificationsSection(catalog: catalog),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('CERTIFICATIONS'), findsOneWidget);
    final title = find.text('Continuous learning, backed by proof.');
    final copy = find.text(
      'Official course records available for consultation, with source '
      'verification and archived certificates.',
    );
    expect(
      tester.getTopLeft(copy).dx,
      closeTo(tester.getTopLeft(title).dx, .01),
    );
    expect(
      tester.getTopLeft(copy).dy,
      greaterThan(tester.getBottomLeft(title).dy),
    );
    expect(
      tester.getTopLeft(find.text('CERTIFICATIONS')).dx,
      closeTo(124, .01),
    );

    await tester.tap(find.byKey(const Key('certificates-view-all-card')));
    await tester.pumpAndSettle();

    expect(
      find.byKey(const Key('certificate-group-anthropic-academy')),
      findsNothing,
    );
    expect(find.byKey(const Key('certificate-filter-flutter')), findsOneWidget);
    for (final id in [
      'demo-credential',
      'mcp-credential',
      'claude-code-credential',
      'flutter-credential',
    ]) {
      expect(find.byKey(Key('certificate-card-$id')), findsOneWidget);
    }
    expect(find.text('VERIFIED'), findsNothing);
    expect(find.byIcon(Icons.verified_rounded), findsNothing);
    expect(
      tester
          .getSize(find.byKey(const Key('certificate-card-demo-credential')))
          .height,
      closeTo(200, .01),
    );
    expect(
      find.byKey(const Key('certificate-filter-results-all')),
      findsOneWidget,
    );

    await tester.tap(find.byKey(const Key('certificate-filter-flutter')));
    await tester.pump();
    expect(
      find.byKey(const Key('certificate-filter-results-all')),
      findsOneWidget,
    );
    expect(
      find.byKey(const Key('certificate-filter-results-flutter')),
      findsOneWidget,
    );
    await tester.pump(const Duration(milliseconds: 220));
    expect(
      find.byKey(const Key('certificate-card-flutter-credential')),
      findsOneWidget,
    );
    expect(
      find.byKey(const Key('certificate-card-demo-credential')),
      findsNothing,
    );

    await tester.tap(find.byKey(const Key('certificate-clear-filters')));
    await tester.pump(const Duration(milliseconds: 220));
    expect(
      find.byKey(const Key('certificate-card-demo-credential')),
      findsOneWidget,
    );

    await tester.tap(find.byKey(const Key('certificate-card-demo-credential')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('certificate-preview-dialog')), findsOneWidget);
    expect(find.text('Verify credential'), findsOneWidget);
    await _closeDialog(tester);
    await _closeDialog(tester);
    expect(tester.takeException(), isNull);
  });

  testWidgets('keeps the individual certificate gallery usable on mobile', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final catalog = CertificateCatalog([
      _testCertificate(
        id: 'mobile-first',
        issuer: 'Anthropic Education',
        title: 'Model Context Protocol: Advanced Topics',
        year: 2026,
        technologies: const ['MCP', 'AI'],
      ),
      _testCertificate(
        id: 'mobile-second',
        issuer: 'Anthropic Education',
        title: 'Claude Code in Action',
        year: 2026,
        technologies: const ['Claude Code', 'AI Agents'],
      ),
      _testCertificate(
        id: 'mobile-third',
        issuer: 'Anthropic Education',
        title: 'Introduction to agent skills',
        year: 2026,
        technologies: const ['Agent Skills', 'Claude'],
      ),
    ]);
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        theme: LeoneBrandTheme.dark(),
        localizationsDelegates: const [AppLocalizations.delegate],
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(body: CertificationsSection(catalog: catalog)),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    final highlightScroll = tester.widget<SingleChildScrollView>(
      find.byKey(const Key('certificate-highlights-scroll')),
    );
    expect(highlightScroll.clipBehavior, Clip.none);
    expect(
      tester
          .getSize(
            find.byKey(const Key('certificate-highlight-card-mobile-first')),
          )
          .height,
      144,
    );
    expect(find.text('Certificate issued to Leone Souza'), findsNothing);

    await tester.drag(
      find.byKey(const Key('certificate-highlights-scroll')),
      const Offset(-900, 0),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('certificates-view-all-card')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    final compactFilter = find.byKey(const Key('certificate-filter-toggle'));
    expect(compactFilter, findsOneWidget);
    expect(find.byKey(const Key('certificate-filter-mcp')), findsNothing);
    await tester.tap(compactFilter);
    await tester.pump(const Duration(milliseconds: 220));
    expect(find.byKey(const Key('certificate-filter-mcp')), findsOneWidget);
    await tester.tap(compactFilter);
    await tester.pump(const Duration(milliseconds: 220));
    expect(find.byKey(const Key('certificate-filter-mcp')), findsNothing);

    await tester.drag(
      find.descendant(
        of: find.byKey(const Key('certificate-register-dialog')),
        matching: find.byType(CustomScrollView),
      ),
      const Offset(0, -320),
    );
    await tester.pumpAndSettle();
    final secondCard = find.byKey(const Key('certificate-card-mobile-second'));
    expect(
      find.byKey(const Key('certificate-group-anthropic-academy')),
      findsNothing,
    );
    expect(secondCard, findsOneWidget);
    await tester.tap(secondCard);
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('certificate-preview-dialog')), findsOneWidget);
    expect(find.text('Certificate issued to Leone Souza'), findsNothing);
    await _closeDialog(tester);
    await _closeDialog(tester);
    expect(tester.takeException(), isNull);
  });

  testWidgets('switches between Portuguese and English and saves preference', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({'portfolio_locale': 'pt'});
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const LeonePortfolioApp());
    await _finishOpening(tester);

    expect(find.text('Engenheiro de Software Mobile'), findsOneWidget);
    expect(
      tester.getSize(find.byKey(const Key('language-toggle'))).height,
      greaterThanOrEqualTo(48),
    );
    expect(
      tester.getSize(find.byKey(const Key('language-toggle'))).width,
      lessThanOrEqualTo(64),
    );
    expect(tester.takeException(), isNull);

    await tester.tap(find.byKey(const Key('language-toggle')));
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('Mobile Software Engineer'), findsOneWidget);
    expect(find.text('OPEN TO NEW CHALLENGES'), findsNothing);
    final preferences = await SharedPreferences.getInstance();
    expect(preferences.getString('portfolio_locale'), 'en');

    await tester.tap(find.byKey(const Key('language-toggle')));
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('Engenheiro de Software Mobile'), findsOneWidget);
    expect(preferences.getString('portfolio_locale'), 'pt');
    expect(tester.takeException(), isNull);
  });

  testWidgets('opening the FAB menu does not rebuild its body', (tester) async {
    var bodyBuilds = 0;

    await tester.pumpWidget(
      MaterialApp(
        theme: LeoneBrandTheme.dark(),
        localizationsDelegates: const [AppLocalizations.delegate],
        supportedLocales: AppLocalizations.supportedLocales,
        home: PortfolioFabMenuScaffold(
          showFloatingActionButton: true,
          floatingActionButtonEnabled: true,
          onSelected: (_) {},
          body: _BuildCounter(onBuild: () => bodyBuilds++),
        ),
      ),
    );
    expect(bodyBuilds, 1);

    await tester.tap(find.byKey(const Key('portfolio-floating-action')));
    await tester.pump();
    await tester.pump(LeoneBrandMotion.fabMenuExpand);

    expect(bodyBuilds, 1);
    expect(find.bySemanticsLabel('Close navigation menu'), findsOneWidget);
  });
}

Future<void> _finishOpening(WidgetTester tester) async {
  await tester.pump();
  await tester.pumpAndSettle(const Duration(milliseconds: 100));
}

Future<void> _closeDialog(WidgetTester tester) async {
  await tester.tap(find.byTooltip('Close dialog').last);
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 300));
}

CertificateRecord _testCertificate({
  required String id,
  required String issuer,
  required String title,
  required int year,
  required List<String> technologies,
}) => CertificateRecord(
  id: id,
  issuer: issuer,
  title: title,
  holder: 'Leone Souza',
  completedOn: DateTime(year, 7, 17),
  verificationUrl: Uri.parse('https://verify.skilljar.com/c/$id'),
  imageAssetPath: 'assets/certificates/originals/anthropic-ai-capabilities-and-limitations.jpg',
  pdfAssetPath: 'assets/certificates/originals/anthropic-ai-capabilities-and-limitations.pdf',
  technologies: technologies,
);

class _BuildCounter extends StatelessWidget {
  const _BuildCounter({required this.onBuild});

  final VoidCallback onBuild;

  @override
  Widget build(BuildContext context) {
    onBuild();
    return const SizedBox.expand();
  }
}
