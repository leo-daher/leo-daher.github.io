import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:leone_portfolio/main.dart';
import 'package:leone_portfolio/world_experience_map.dart';

void main() {
  testWidgets('renders centered positioning and switches career focus', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1440, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const LeonePortfolioApp());
    expect(find.byKey(const Key('ld-opening-transition')), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 3200));
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
    await tester.pump(const Duration(milliseconds: 3800));
    await tester.pump(const Duration(milliseconds: 400));

    final fab = find.byKey(const Key('portfolio-floating-action'));
    expect(find.bySemanticsLabel('Abrir menu de navegação'), findsOneWidget);
    expect(
      find.descendant(of: fab, matching: find.byIcon(Icons.menu_rounded)),
      findsOneWidget,
    );

    await tester.tap(fab);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.bySemanticsLabel('Fechar menu de navegação'), findsOneWidget);
    expect(
      find.descendant(of: fab, matching: find.byIcon(Icons.close_rounded)),
      findsOneWidget,
    );
    const itemKeys = [
      Key('fab-menu-home'),
      Key('fab-menu-system'),
      Key('fab-menu-projects'),
      Key('fab-menu-experience'),
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
    await tester.pump(const Duration(milliseconds: 3800));
    await tester.pump(const Duration(milliseconds: 400));
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
    expect(find.bySemanticsLabel('Abrir menu de navegação'), findsOneWidget);
    final headingY = tester.getTopLeft(find.text('SOLUÇÕES EM DESTAQUE')).dy;
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
    await tester.pump(const Duration(milliseconds: 3800));
    await tester.pump(const Duration(milliseconds: 400));

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
    expect(find.bySemanticsLabel('Abrir menu de navegação'), findsOneWidget);

    await tester.tap(fabFinder);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    await tester.tapAt(const Offset(24, 220));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 350));
    expect(find.bySemanticsLabel('Abrir menu de navegação'), findsOneWidget);
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
    await tester.pump(const Duration(milliseconds: 3800));
    await tester.pump(const Duration(milliseconds: 400));
    await tester.tap(find.byKey(const Key('portfolio-floating-action')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    final fabRect = tester.getRect(
      find.byKey(const Key('portfolio-floating-action')),
    );
    final widestItemRect = tester.getRect(
      find.byKey(const Key('fab-menu-experience')),
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

    expect(find.text('CLIENTES ATENDIDOS'), findsOneWidget);
    expect(find.text('13 MARCAS'), findsOneWidget);
    expect(find.text('LINELINKER PRO'), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
