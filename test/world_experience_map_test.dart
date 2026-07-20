import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:leone_portfolio/features/experience/world_map_geometry.dart';
import 'package:leone_portfolio/world_experience_map.dart';
import 'package:vector_graphics/vector_graphics.dart';

void main() {
  testWidgets('renders an isolated raster base and interactive overlay', (
    tester,
  ) async {
    await _pumpMap(tester);

    final baseFinder = find.byKey(const Key('world-map-base-vector'));
    final vector = tester.widget<VectorGraphic>(baseFinder);
    final loader = vector.loader as AssetBytesLoader;

    expect(baseFinder, findsOneWidget);
    expect(loader.assetName, 'assets/maps/world-map-base.svg.vec');
    expect(vector.strategy.name, 'raster');
    expect(find.byKey(const Key('world-map-base-boundary')), findsOneWidget);
    expect(find.byKey(const Key('world-map-overlay-boundary')), findsOneWidget);
    expect(
      find.byKey(const Key('world-map-interactive-overlay')),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('selects map countries and Singapore through its inset', (
    tester,
  ) async {
    await _pumpMap(tester);

    expect(find.byKey(const Key('selected-country-br')), findsOneWidget);

    final overlay = find.byKey(const Key('world-map-interactive-overlay'));
    final overlayRect = tester.getRect(overlay);
    final mapRect = worldMapRectFor(overlayRect.size);
    final usPosition =
        overlayRect.topLeft +
        Offset(
          mapRect.left + mapRect.width * .195,
          mapRect.top + mapRect.height * .525,
        );

    await tester.tapAt(usPosition);
    await tester.pump();

    expect(find.byKey(const Key('selected-country-us')), findsOneWidget);

    final singaporeInset = find.byKey(const Key('world-map-singapore-inset'));
    expect(singaporeInset, findsOneWidget);
    await tester.tap(singaporeInset);
    await tester.pump();

    expect(find.byKey(const Key('selected-country-sg')), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('excludes China from the country list and detail card', (
    tester,
  ) async {
    await _pumpMap(tester);

    expect(find.byKey(const Key('world-map-country-cn')), findsNothing);
    expect(find.byKey(const Key('selected-country-cn')), findsNothing);
    expect(find.text('China'), findsNothing);
    expect(tester.takeException(), isNull);
  });
}

Future<void> _pumpMap(WidgetTester tester) async {
  tester.view.physicalSize = const Size(1440, 1800);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  await tester.pumpWidget(
    const MaterialApp(
      home: Scaffold(body: SingleChildScrollView(child: WorldExperienceMap())),
    ),
  );
  await tester.pumpAndSettle();
}
