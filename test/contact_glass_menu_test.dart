import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:leone_portfolio/brand/leone_brand.dart';
import 'package:leone_portfolio/features/navigation/portfolio_header_actions.dart';
import 'package:leone_portfolio/l10n/app_localizations.dart';

const _button = Key('header-contact-button');
const _surface = Key('header-contact-glass-surface');

Future<void> _pumpMenu(
  WidgetTester tester, {
  bool reduceMotion = false,
  bool highContrast = false,
  bool compact = false,
  double textScale = 1,
}) async {
  await tester.pumpWidget(
    MaterialApp(
      theme: LeoneBrandTheme.glass(Brightness.light),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(
          disableAnimations: reduceMotion,
          highContrast: highContrast,
          textScaler: TextScaler.linear(textScale),
        ),
        child: child!,
      ),
      home: Scaffold(
        body: Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: PortfolioContactButton(compact: compact),
          ),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets(
    'morphs from its button and keeps the reverse animation mounted',
    (tester) async {
      await _pumpMenu(tester);
      final buttonRect = tester.getRect(find.byKey(_button));
      await tester.tap(find.byKey(_button));
      await tester.pump();
      expect(tester.getRect(find.byKey(_surface)), buttonRect);
      await tester.pump(const Duration(milliseconds: 100));
      final intermediate = tester.getRect(find.byKey(_surface));
      expect(intermediate.width, greaterThan(buttonRect.width));
      expect(intermediate.width, lessThan(288));
      await tester.pumpAndSettle();
      final openRect = tester.getRect(find.byKey(_surface));
      expect(openRect.width, 288);
      expect(openRect.top, greaterThan(buttonRect.bottom));
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byKey(_surface), findsOneWidget);
      expect(
        tester.getSize(find.byKey(_surface)).height,
        lessThan(openRect.height),
      );
      expect(
        tester.widget<TextButton>(find.byKey(_button)).focusNode!.hasFocus,
        isTrue,
      );
      await tester.pumpAndSettle();
      expect(find.byKey(_surface), findsNothing);
    },
  );

  testWidgets('reopening interrupts a pending close without losing the menu', (
    tester,
  ) async {
    await _pumpMenu(tester);
    await tester.tap(find.byKey(_button));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(_button));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 70));
    await tester.tap(find.byKey(_button));
    await tester.pumpAndSettle();
    expect(find.byKey(_surface), findsOneWidget);
    expect(tester.getSize(find.byKey(_surface)).width, 288);
    await tester.tapAt(const Offset(20, 400));
    await tester.pumpAndSettle();
    expect(find.byKey(_surface), findsNothing);
  });

  testWidgets('supports keyboard opening, arrow traversal, and return focus', (
    tester,
  ) async {
    await _pumpMenu(tester);
    final trigger = tester.widget<TextButton>(find.byKey(_button)).focusNode!;
    trigger.requestFocus();
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowUp);
    await tester.pumpAndSettle();
    FocusNode item(String id) => tester
        .widget<TextButton>(find.byKey(Key('header-contact-item-$id')))
        .focusNode!;
    expect(item('github').hasFocus, isTrue);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.pump();
    expect(item('whatsapp').hasFocus, isTrue);
    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();
    expect(trigger.hasFocus, isTrue);
    expect(find.byKey(_surface), findsNothing);
  });

  testWidgets('reduced motion is immediate and high contrast disables glass', (
    tester,
  ) async {
    await _pumpMenu(tester, reduceMotion: true, highContrast: true);
    await tester.tap(find.byKey(_button));
    await tester.pump();
    expect(tester.getSize(find.byKey(_surface)).width, 288);
    final tint = tester.widget<DecoratedBox>(
      find.byKey(const Key('header-contact-glass-tint')),
    );
    expect((tint.decoration as BoxDecoration).color!.a, 1);
    expect(
      tester.widget<BackdropFilter>(find.byType(BackdropFilter)).enabled,
      isFalse,
    );
    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pump();
    expect(find.byKey(_surface), findsNothing);
  });

  testWidgets('fits a narrow viewport and large system text', (tester) async {
    tester.view.physicalSize = const Size(320, 480);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await _pumpMenu(tester, compact: true, textScale: 2);
    await tester.tap(find.byKey(_button));
    await tester.pumpAndSettle();
    final rect = tester.getRect(find.byKey(_surface));
    expect(rect.left, greaterThanOrEqualTo(8));
    expect(rect.right, lessThanOrEqualTo(312));
    expect(rect.bottom, lessThanOrEqualTo(472));
    expect(tester.takeException(), isNull);
  });

  testWidgets('honors the separate iOS reduced motion preference', (
    tester,
  ) async {
    tester.platformDispatcher.accessibilityFeaturesTestValue =
        const FakeAccessibilityFeatures(reduceMotion: true);
    addTearDown(tester.platformDispatcher.clearAccessibilityFeaturesTestValue);
    await _pumpMenu(tester);
    await tester.tap(find.byKey(_button));
    await tester.pump();
    expect(tester.getSize(find.byKey(_surface)).width, 288);
    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pump();
    expect(find.byKey(_surface), findsNothing);
  });
}
