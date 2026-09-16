import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:leone_portfolio/brand/leone_brand.dart';
import 'package:leone_portfolio/brand/leone_glass.dart';
import 'package:leone_portfolio/features/navigation/portfolio_fab_menu.dart';
import 'package:leone_portfolio/l10n/app_localizations.dart';

const _toggle = Key('portfolio-floating-action');
const _items = [
  Key('fab-menu-home'),
  Key('fab-menu-apps'),
  Key('fab-menu-system'),
  Key('fab-menu-clients'),
  Key('fab-menu-contact'),
];

Future<void> _pumpMenu(
  WidgetTester tester, {
  required Size size,
  Brightness brightness = Brightness.dark,
  bool glass = true,
  bool highContrast = false,
  bool reduceMotion = false,
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  final menu = PortfolioFabMenuScaffold(
    showFloatingActionButton: true,
    floatingActionButtonEnabled: true,
    onSelected: (_) {},
    body: const SizedBox.expand(),
  );
  await tester.pumpWidget(
    MaterialApp(
      theme: brightness == Brightness.light
          ? LeoneBrandTheme.light()
          : LeoneBrandTheme.dark(),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(
          context,
        ).copyWith(highContrast: highContrast, disableAnimations: reduceMotion),
        child: child!,
      ),
      home: glass ? LeoneGlassExperience(child: menu) : menu,
    ),
  );
}

Finder _pathBasedRenderObjects() => find.byElementPredicate(
  (element) =>
      element is RenderObjectElement &&
      (element.renderObject is RenderPhysicalShape ||
          element.renderObject is RenderClipPath),
);

void _expectGlassPill(WidgetTester tester, Key key) {
  final item = find.byKey(key);
  final material = tester.widget<Material>(item);
  expect(material.shape, isNull);
  expect(material.clipBehavior, Clip.none);
  expect(material.elevation, 0);
  expect(
    find.descendant(of: item, matching: _pathBasedRenderObjects()),
    findsNothing,
  );

  final surface = find.ancestor(
    of: item,
    matching: find.byType(LeoneGlassSurface),
  );
  final clip = find.descendant(of: surface, matching: find.byType(ClipRRect));
  expect(clip, findsOneWidget);
  expect(
    tester.widget<ClipRRect>(clip).borderRadius,
    BorderRadius.circular(999),
  );
  expect(tester.getRect(clip), tester.getRect(item));
  expect(
    find.descendant(of: surface, matching: find.byType(BackdropFilter)),
    findsOneWidget,
  );

  final outline = find.descendant(
    of: item,
    matching: find.byWidgetPredicate(
      (widget) =>
          widget is DecoratedBox &&
          widget.position == DecorationPosition.foreground,
    ),
  );
  expect(outline, findsOneWidget);
  final decoration =
      tester.widget<DecoratedBox>(outline).decoration as BoxDecoration;
  expect(decoration.borderRadius, BorderRadius.circular(999));
  expect(
    decoration.border,
    Border.all(color: tester.element(item).leonePalette.outline),
  );
}

void main() {
  for (final brightness in Brightness.values) {
    for (final size in [const Size(390, 844), const Size(1440, 1000)]) {
      testWidgets(
        'glass FAB pills use rounded-rect clips: $brightness, $size',
        (tester) async {
          await _pumpMenu(tester, size: size, brightness: brightness);
          await tester.tap(find.byKey(_toggle));
          await tester.pumpAndSettle();

          expect(find.byType(BackdropFilter), findsNWidgets(5));
          final fabRect = tester.getRect(find.byKey(_toggle));
          Rect? previous;
          for (final key in _items) {
            _expectGlassPill(tester, key);
            final rect = tester.getRect(find.byKey(key));
            expect(rect.height, closeTo(56, .01));
            expect(rect.right, closeTo(fabRect.right, .01));
            expect(rect.left, greaterThanOrEqualTo(16));
            if (previous != null) {
              expect(rect.top - previous.bottom, closeTo(4, .01));
            }
            previous = rect;
          }
          expect(fabRect.top - previous!.bottom, closeTo(8, .01));
          expect(tester.takeException(), isNull);
        },
      );
    }
  }

  for (final glass in [false, true]) {
    testWidgets('retains stadium clipping for glass=$glass, contrast=$glass', (
      tester,
    ) async {
      await _pumpMenu(
        tester,
        size: const Size(390, 844),
        glass: glass,
        highContrast: glass,
      );
      await tester.tap(find.byKey(_toggle));
      await tester.pumpAndSettle();

      expect(find.byType(BackdropFilter), findsNothing);
      for (final key in _items) {
        final item = find.byKey(key);
        final material = tester.widget<Material>(item);
        expect(material.shape, isA<StadiumBorder>());
        expect(material.clipBehavior, Clip.antiAlias);
        expect(material.elevation, glass ? 0 : 6);
        expect(
          find.descendant(of: item, matching: _pathBasedRenderObjects()),
          findsWidgets,
        );
        expect(tester.getSize(item).height, closeTo(56, .01));
      }
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('fast glass clipping preserves reduced-motion interaction', (
    tester,
  ) async {
    await _pumpMenu(tester, size: const Size(390, 844), reduceMotion: true);
    await tester.tap(find.byKey(_toggle));
    await tester.pump();
    for (final key in _items) {
      _expectGlassPill(tester, key);
      expect(find.byKey(key).hitTestable(), findsOneWidget);
    }
    await tester.tap(find.byKey(_items.first));
    await tester.pump();
    for (final key in _items) {
      expect(find.byKey(key).hitTestable(), findsNothing);
    }
    expect(tester.takeException(), isNull);
  });
}
