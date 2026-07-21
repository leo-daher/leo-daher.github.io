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

  testWidgets('renders centered positioning and switches career focus', (
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
    expect(find.byKey(const Key('ld-viewport-frame')), findsOneWidget);
    expect(find.byKey(const Key('portfolio-floating-action')), findsOneWidget);
    expect(find.text('MOBILE'), findsOneWidget);
    expect(find.text('TABLET'), findsOneWidget);
    expect(find.text('DESKTOP'), findsOneWidget);
    expect(
      find.text('Mobile products powered by smart, connected systems.'),
      findsOneWidget,
    );

    await tester.tap(find.text('AI + Automation'));
    await tester.pumpAndSettle();

    expect(find.text('AI Automation Engineer'), findsOneWidget);
  });

  testWidgets('morphs the branded viewport without leaving its stage', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const LeonePortfolioApp());
    await _finishOpening(tester);

    final frame = find.byKey(const Key('ld-viewport-frame'));
    final mobileSize = tester.getSize(frame);
    expect(mobileSize.width, lessThan(390));
    expect(mobileSize.height, greaterThan(mobileSize.width));

    await tester.tap(find.byKey(const Key('ld-mode-tablet')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 1000));
    final tabletSize = tester.getSize(frame);
    expect(tabletSize.width, greaterThan(mobileSize.width));
    expect(tabletSize.height, lessThan(mobileSize.height));

    await tester.tap(find.byKey(const Key('ld-mode-desktop')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 1000));
    final desktopSize = tester.getSize(frame);
    expect(desktopSize.width, greaterThanOrEqualTo(tabletSize.width));
    expect(desktopSize.height, lessThan(tabletSize.height));
    expect(desktopSize.width, lessThanOrEqualTo(354));
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
      Key('fab-menu-system'),
      Key('fab-menu-projects'),
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

  testWidgets('FAB menu navigates to a section and closes', (tester) async {
    tester.view.physicalSize = const Size(1440, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const LeonePortfolioApp());
    await _finishOpening(tester);
    await tester.tap(find.byKey(const Key('portfolio-floating-action')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    await tester.tap(find.byKey(const Key('fab-menu-projects')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 900));

    expect(
      find.byKey(const Key('fab-menu-projects')).hitTestable(),
      findsNothing,
    );
    expect(find.bySemanticsLabel('Open navigation menu'), findsOneWidget);
    final headingY = tester.getTopLeft(find.text('FEATURED SOLUTIONS')).dy;
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
      find.byKey(const Key('fab-menu-projects')),
    );
    expect(fabRect.right, closeTo(374, .01));
    expect(fabRect.bottom, closeTo(828, .01));
    expect(widestItemRect.left, greaterThanOrEqualTo(16));
    expect(tester.takeException(), isNull);
  });

  testWidgets('stacks the three neon solution panels on a narrow viewport', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const LeonePortfolioApp());
    await _finishOpening(tester);
    await tester.drag(find.byType(CustomScrollView), const Offset(0, -1450));
    await tester.pumpAndSettle();

    expect(find.text('Mobile Systems'), findsOneWidget);
    expect(find.text('Agentic Workflows'), findsOneWidget);
    expect(find.text('Automation Lab'), findsOneWidget);
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

  testWidgets(
    'shows a year-grouped certificate gallery and official preview on demand',
    (tester) async {
      tester.view.physicalSize = const Size(1440, 1000);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final catalog = CertificateCatalog([
        CertificateRecord(
          id: 'demo-credential',
          issuer: 'Anthropic Education',
          title: 'AI Fluency: AI Capabilities & Limitations',
          holder: 'Leone Souza',
          completedOn: DateTime(2026, 7, 17),
          verificationUrl: Uri.parse('https://verify.skilljar.com/c/demo'),
          imageAssetPath:
              'assets/certificates/originals/anthropic-ai-capabilities-and-limitations.jpg',
          pdfAssetPath:
              'assets/certificates/originals/anthropic-ai-capabilities-and-limitations.pdf',
          technologies: const ['AI', 'LLMs'],
        ),
        CertificateRecord(
          id: 'flutter-credential',
          issuer: 'Udemy',
          title: 'The Complete Flutter Development Bootcamp with Dart',
          holder: 'Leone Souza',
          completedOn: DateTime(2021, 8, 16),
          verificationUrl: Uri.parse('https://www.udemy.com/certificate/demo'),
          imageAssetPath:
              'assets/certificates/originals/udemy-complete-flutter-development-bootcamp-with-dart.jpg',
          pdfAssetPath:
              'assets/certificates/originals/udemy-complete-flutter-development-bootcamp-with-dart.pdf',
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
      expect(find.text('2 VERIFIED CREDENTIALS'), findsOneWidget);

      await tester.tap(find.byKey(const Key('certificates-open-register')));
      await tester.pumpAndSettle();
      expect(
        find.byKey(const Key('certificate-register-dialog')),
        findsOneWidget,
      );
      expect(find.text('2026'), findsOneWidget);
      expect(find.text('2021'), findsOneWidget);
      expect(find.text('AI'), findsOneWidget);
      expect(find.text('Flutter'), findsOneWidget);
      expect(
        find.byKey(const Key('certificate-card-demo-credential')),
        findsOneWidget,
      );
      expect(
        find.byKey(const Key('certificate-card-flutter-credential')),
        findsOneWidget,
      );

      await tester.tap(
        find.byKey(const Key('certificate-card-demo-credential')),
      );
      await tester.pumpAndSettle();
      expect(
        find.byKey(const Key('certificate-preview-dialog')),
        findsOneWidget,
      );
      expect(find.text('Verify credential'), findsOneWidget);
      await tester.tap(find.byTooltip('Close dialog').last);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      await tester.tap(find.byTooltip('Close dialog').last);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('keeps certificate gallery cards in a single mobile column', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final catalog = CertificateCatalog([
      CertificateRecord(
        id: 'mobile-first',
        issuer: 'Anthropic Education',
        title: 'Model Context Protocol: Advanced Topics',
        holder: 'Leone Souza',
        completedOn: DateTime(2026, 7, 17),
        verificationUrl: Uri.parse(
          'https://verify.skilljar.com/c/mobile-first',
        ),
        imageAssetPath:
            'assets/certificates/originals/anthropic-model-context-protocol-advanced-topics.jpg',
        pdfAssetPath:
            'assets/certificates/originals/anthropic-model-context-protocol-advanced-topics.pdf',
        technologies: const ['MCP', 'AI'],
      ),
      CertificateRecord(
        id: 'mobile-second',
        issuer: 'Anthropic Education',
        title: 'Claude Code in Action',
        holder: 'Leone Souza',
        completedOn: DateTime(2026, 7, 10),
        verificationUrl: Uri.parse(
          'https://verify.skilljar.com/c/mobile-second',
        ),
        imageAssetPath:
            'assets/certificates/originals/anthropic-claude-code-in-action.jpg',
        pdfAssetPath:
            'assets/certificates/originals/anthropic-claude-code-in-action.pdf',
        technologies: const ['Claude Code', 'AI Agents'],
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

    final firstCard = find.byKey(const Key('certificate-card-mobile-first'));
    final secondCard = find.byKey(const Key('certificate-card-mobile-second'));
    expect(firstCard, findsOneWidget);
    expect(secondCard, findsOneWidget);
    expect(tester.getTopLeft(firstCard).dx, tester.getTopLeft(secondCard).dx);
    expect(
      tester.getTopLeft(secondCard).dy,
      greaterThan(tester.getBottomLeft(firstCard).dy),
    );
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

class _BuildCounter extends StatelessWidget {
  const _BuildCounter({required this.onBuild});

  final VoidCallback onBuild;

  @override
  Widget build(BuildContext context) {
    onBuild();
    return const SizedBox.expand();
  }
}
