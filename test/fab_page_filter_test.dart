import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:leone_portfolio/brand/leone_brand.dart';
import 'package:leone_portfolio/brand/leone_glass.dart';
import 'package:leone_portfolio/features/navigation/portfolio_fab_menu.dart';
import 'package:leone_portfolio/l10n/app_localizations.dart';

const _toggle = Key('portfolio-floating-action');
const _menu = Key('portfolio-fab-menu');
const _filter = Key('portfolio-menu-page-filter');
const _backdrop = Key('portfolio-menu-backdrop');
const _barrier = Key('portfolio-menu-backdrop-barrier');
const _body = Key('test-portfolio-body');

Future<void> _pumpMenu(
  WidgetTester tester, {
  required Size size,
  bool reduceMotion = false,
  VoidCallback? onBodyBuild,
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  await tester.pumpWidget(
    MaterialApp(
      theme: LeoneBrandTheme.dark(),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(disableAnimations: reduceMotion),
        child: child!,
      ),
      home: LeoneGlassExperience(
        child: PortfolioFabMenuScaffold(
          showFloatingActionButton: true,
          floatingActionButtonEnabled: true,
          onSelected: (_) {},
          body: Builder(
            key: _body,
            builder: (_) {
              onBodyBuild?.call();
              return const SizedBox.expand(
                child: Center(child: Text('Portfolio content')),
              );
            },
          ),
        ),
      ),
    ),
  );
}

void _expectPillFiltersUnchanged(WidgetTester tester) {
  final filters = find.byType(BackdropFilter);
  final menuFilters = find.descendant(of: find.byKey(_menu), matching: filters);
  expect(filters, findsNWidgets(5));
  expect(menuFilters, findsNWidgets(5));
  for (final filter in tester.renderObjectList<RenderBackdropFilter>(filters)) {
    expect(filter.backdropKey, isNull);
  }
}

void main() {
  for (final size in [const Size(390, 844), const Size(1440, 1000)]) {
    testWidgets('page-only FAB filter preserves its child at $size', (
      tester,
    ) async {
      var bodyBuilds = 0;
      await _pumpMenu(tester, size: size, onBodyBuild: () => bodyBuilds++);
      final bodyElement = tester.element(find.byKey(_body));
      final filterElement = tester.element(find.byKey(_filter));
      expect(
        tester.widget<ImageFiltered>(find.byKey(_filter)).enabled,
        isFalse,
      );
      expect(tester.getSize(find.byKey(_filter)), size);
      expect(bodyBuilds, 1);
      _expectPillFiltersUnchanged(tester);

      await tester.tap(find.byKey(_toggle));
      await tester.pump();
      await tester.pump(LeoneBrandMotion.fabMenuExpand ~/ 2);
      expect(tester.widget<ImageFiltered>(find.byKey(_filter)).enabled, isTrue);
      expect(tester.element(find.byKey(_body)), same(bodyElement));
      expect(tester.element(find.byKey(_filter)), same(filterElement));
      expect(bodyBuilds, 1);

      // The old scene-wide BackdropFilter is gone. Glass remains local to the
      // five pills, and neither the FAB nor the dismiss barrier is filtered.
      _expectPillFiltersUnchanged(tester);
      expect(tester.getSize(find.byKey(_backdrop)), size);
      for (final key in [_toggle, _barrier, _backdrop]) {
        expect(
          find.descendant(of: find.byKey(_filter), matching: find.byKey(key)),
          findsNothing,
        );
      }
      expect(
        find.descendant(of: find.byKey(_filter), matching: find.byKey(_body)),
        findsOneWidget,
      );
      expect(
        find.ancestor(of: find.byKey(_filter), matching: find.byType(ClipRect)),
        findsWidgets,
      );

      await tester.pumpAndSettle();
      await tester.tapAt(const Offset(24, 24));
      await tester.pump();
      await tester.pump(LeoneBrandMotion.fabMenuCollapse ~/ 2);
      expect(tester.widget<ImageFiltered>(find.byKey(_filter)).enabled, isTrue);
      expect(
        tester.widget<ModalBarrier>(find.byKey(_barrier)).dismissible,
        isFalse,
      );
      expect(bodyBuilds, 1);

      await tester.pumpAndSettle();
      expect(
        tester.widget<ImageFiltered>(find.byKey(_filter)).enabled,
        isFalse,
      );
      expect(find.byKey(_barrier), findsNothing);
      expect(tester.element(find.byKey(_body)), same(bodyElement));
      expect(tester.element(find.byKey(_filter)), same(filterElement));
      expect(bodyBuilds, 1);

      await tester.tap(find.byKey(_toggle));
      await tester.pumpAndSettle();
      expect(tester.widget<ImageFiltered>(find.byKey(_filter)).enabled, isTrue);
      expect(tester.element(find.byKey(_body)), same(bodyElement));
      expect(tester.element(find.byKey(_filter)), same(filterElement));
      _expectPillFiltersUnchanged(tester);
      expect(bodyBuilds, 1);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('reduced motion resolves the page filter without a transition', (
    tester,
  ) async {
    await _pumpMenu(tester, size: const Size(390, 844), reduceMotion: true);
    final bodyElement = tester.element(find.byKey(_body));
    expect(tester.widget<ImageFiltered>(find.byKey(_filter)).enabled, isFalse);

    await tester.tap(find.byKey(_toggle));
    await tester.pump();
    expect(tester.widget<ImageFiltered>(find.byKey(_filter)).enabled, isTrue);
    expect(
      find.byKey(const Key('fab-menu-home')).hitTestable(),
      findsOneWidget,
    );
    expect(find.byKey(_barrier), findsOneWidget);
    _expectPillFiltersUnchanged(tester);

    await tester.tapAt(const Offset(24, 24));
    await tester.pump();
    expect(tester.widget<ImageFiltered>(find.byKey(_filter)).enabled, isFalse);
    expect(find.byKey(_barrier), findsNothing);
    expect(find.byKey(const Key('fab-menu-home')).hitTestable(), findsNothing);
    expect(tester.element(find.byKey(_body)), same(bodyElement));
    expect(tester.takeException(), isNull);
  });
}
