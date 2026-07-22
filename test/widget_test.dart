import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:leone_portfolio/brand/leone_brand.dart';
import 'package:leone_portfolio/features/certificates/certificate_catalog.dart';
import 'package:leone_portfolio/features/certificates/certifications_section.dart';
import 'package:leone_portfolio/features/clients/client_logo_cloud.dart';
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

  testWidgets('renders a simplified hero and switches career focus', (
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
    expect(find.byKey(const Key('ld-viewport-frame-action')), findsOneWidget);
    expect(find.byKey(const Key('ld-viewport-frame-content')), findsOneWidget);
    expect(find.byKey(const Key('portfolio-floating-action')), findsOneWidget);
    expect(find.text('MOBILE'), findsNothing);
    expect(find.text('TABLET'), findsNothing);
    expect(find.text('DESKTOP'), findsNothing);
    expect(find.text('YOUR IDEAS. EVERYWHERE.'), findsNWidgets(2));
    expect(
      find.text('Mobile products powered by smart, connected systems.'),
      findsOneWidget,
    );

    await tester.tap(find.text('AI + Automation'));
    await tester.pumpAndSettle();

    expect(find.text('AI Automation Engineer'), findsOneWidget);
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

  testWidgets('links the direct hiring CTA to the 30 minute Calendly slot', (
    tester,
  ) async {
    await tester.pumpWidget(const LeonePortfolioApp());
    await _finishOpening(tester);

    final hireMeLink = tester.widget<Link>(
      find.byKey(const Key('hire-me-link')),
    );
    expect(hireMeLink.uri, Uri.parse('https://calendly.com/leonedaher/30min'));
    expect(hireMeLink.target, LinkTarget.blank);
    expect(find.bySemanticsLabel('Hire me here'), findsOneWidget);
    expect(tester.getSize(find.byKey(const Key('hire-me-button'))).height, 48);
  });

  testWidgets('morphs two frame variants and keeps action space clear', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const LeonePortfolioApp());
    await _finishOpening(tester);

    final frame = find.byKey(const Key('ld-viewport-frame-action'));
    final contentFrame = find.byKey(const Key('ld-viewport-frame-content'));
    final navigation = find.byKey(
      const Key('hero-interface-action-navigation'),
    );
    final message = find.byKey(const Key('hero-interface-action-message'));

    expect(
      tester.getTopLeft(frame).dy,
      lessThan(tester.getTopLeft(contentFrame).dy),
    );
    expect(tester.getSize(frame), tester.getSize(contentFrame));
    expect(
      find.byKey(const Key('hero-interface-action-secondary-card')),
      findsNothing,
    );
    expect(
      find.byKey(const Key('hero-interface-content-secondary-card')),
      findsOneWidget,
    );
    final actionMessageText = tester.widget<Text>(
      find.descendant(
        of: find.byKey(const Key('hero-interface-action-message')),
        matching: find.text('YOUR IDEAS.\nEVERYWHERE.'),
      ),
    );
    expect(actionMessageText.maxLines, 2);

    final desktopSize = tester.getSize(frame);
    final desktopFrameOrigin = tester.getTopLeft(frame);
    final desktopNavigation =
        tester.getTopLeft(navigation) - desktopFrameOrigin;
    final desktopMessage = tester.getTopLeft(message) - desktopFrameOrigin;
    final desktopIdentifiers = tester.getRect(
      find.byKey(const Key('hero-interface-action-identifiers')),
    );
    final desktopFrameRect = tester.getRect(frame);
    expect(desktopSize.width, greaterThan(desktopSize.height));
    expect(desktopNavigation.dx, lessThan(desktopMessage.dx));
    expect(
      desktopIdentifiers.right,
      lessThan(desktopFrameRect.left + desktopFrameRect.width * .84),
    );

    await tester.pump(LeoneBrandMotion.viewportHold);
    await tester.pump(LeoneBrandMotion.viewportTransition);

    final mobileSize = tester.getSize(frame);
    final mobileFrameOrigin = tester.getTopLeft(frame);
    final mobileNavigation = tester.getTopLeft(navigation) - mobileFrameOrigin;
    final mobileMessage = tester.getTopLeft(message) - mobileFrameOrigin;
    final actionIdentifiers = tester.getRect(
      find.byKey(const Key('hero-interface-action-identifiers')),
    );
    final actionPrimaryCard = tester.getRect(
      find.byKey(const Key('hero-interface-action-primary-card')),
    );
    final actionFrameRect = tester.getRect(frame);
    expect(mobileSize.height, greaterThan(mobileSize.width));
    expect(mobileNavigation.dy, greaterThan(mobileMessage.dy));
    expect(find.text('YOUR IDEAS.\nEVERYWHERE.'), findsNWidgets(2));
    expect(
      actionIdentifiers.right,
      lessThan(actionFrameRect.left + actionFrameRect.width * .65),
    );
    expect(
      actionPrimaryCard.right,
      lessThan(actionFrameRect.left + actionFrameRect.width * .72),
    );

    await tester.pump(LeoneBrandMotion.viewportHold);
    await tester.pump(LeoneBrandMotion.viewportTransition);

    final tabletSize = tester.getSize(frame);
    expect(tabletSize.width, greaterThan(tabletSize.height));
    expect(tabletSize.width / tabletSize.height, closeTo(316 / 240, .01));
    expect(find.byKey(const Key('ld-mode-mobile')), findsNothing);
    expect(find.byKey(const Key('ld-mode-tablet')), findsNothing);
    expect(find.byKey(const Key('ld-mode-desktop')), findsNothing);
    expect(
      find.byKey(const Key('hero-interface-action-primary-card')),
      findsOneWidget,
    );
    expect(
      find.byKey(const Key('hero-interface-content-secondary-card')),
      findsOneWidget,
    );
    expect(
      find.byKey(const Key('hero-interface-content-identifiers')),
      findsOneWidget,
    );
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
    const itemKeys = [Key('fab-menu-home'), Key('fab-menu-system')];
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
        .getTopLeft(find.text('Mobile, services and intelligence connected.'))
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

    expect(find.text('CLIENTS SERVED'), findsOneWidget);
    expect(find.text('13 BRANDS'), findsOneWidget);
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
    expect(find.text('CLIENTS SERVED'), findsOneWidget);
    expect(find.text('13 BRANDS'), findsOneWidget);
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
    expect(find.text('4 VERIFIED CREDENTIALS'), findsOneWidget);

    await tester.tap(find.byKey(const Key('certificates-open-register')));
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
    await tester.tap(find.byKey(const Key('certificates-open-register')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

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
  imageAssetPath:
      'assets/certificates/originals/anthropic-ai-capabilities-and-limitations.jpg',
  pdfAssetPath:
      'assets/certificates/originals/anthropic-ai-capabilities-and-limitations.pdf',
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
