import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:leone_portfolio/features/experience/world_map_geometry.dart';
import 'package:leone_portfolio/generated/world_map_overlay_data.dart';

void main() {
  test('keeps only the five portfolio country paths in runtime data', () {
    expect(worldMapBaseShapeCount, 171);
    expect(worldMapInteractiveCommandCount, 818);
    expect(
      worldMapInteractivePathCommands.keys,
      unorderedEquals(const ['br', 'us', 'pt', 'es', 'nl']),
    );
    expect(worldMapInteractivePathCommands, isNot(contains('sg')));
    expect(worldMapInteractivePathCommands, isNot(contains('cn')));
    expect(PortfolioWorldMapGeometry.shared.countryCount, 5);
  });

  test('builds each native Path once and reuses it', () {
    final geometry = PortfolioWorldMapGeometry.shared;
    final firstBrazilPath = geometry.pathFor('br');

    expect(firstBrazilPath, isNotNull);
    expect(identical(firstBrazilPath, geometry.pathFor('br')), isTrue);

    final mapRect = Offset.zero & worldMapSourceSize;
    for (var iteration = 0; iteration < 20; iteration++) {
      geometry.hitTest(const Offset(327, 495), mapRect);
    }

    expect(identical(firstBrazilPath, geometry.pathFor('br')), isTrue);
  });

  test('hit-tests representative points for every interactive country', () {
    final geometry = PortfolioWorldMapGeometry.shared;
    final mapRect = Offset.zero & worldMapSourceSize;
    const points = <String, Offset>{
      'br': Offset(.324, .760),
      'us': Offset(.195, .525),
      'pt': Offset(.449, .526),
      'es': Offset(.461, .522),
      'nl': Offset(.487, .448),
    };

    for (final entry in points.entries) {
      final position = Offset(
        entry.value.dx * worldMapSourceSize.width,
        entry.value.dy * worldMapSourceSize.height,
      );
      expect(
        geometry.hitTest(position, mapRect),
        entry.key,
        reason: 'representative point for ${entry.key}',
      );
    }
    final chinaPosition = Offset(
      .761 * worldMapSourceSize.width,
      .538 * worldMapSourceSize.height,
    );
    final singaporePosition = Offset(
      .745 * worldMapSourceSize.width,
      .61 * worldMapSourceSize.height,
    );
    expect(geometry.hitTest(chinaPosition, mapRect), isNull);
    expect(geometry.hitTest(singaporePosition, mapRect), isNull);
    expect(geometry.hitTest(const Offset(-1, -1), mapRect), isNull);
  });

  test('keeps the fitted map aspect ratio before applying zoom', () {
    final wideRect = worldMapRectFor(const Size(1440, 640));
    final compactRect = worldMapRectFor(const Size(390, 280));

    expect(
      wideRect.width / wideRect.height,
      closeTo(worldMapSourceSize.aspectRatio, .0001),
    );
    expect(
      compactRect.width / compactRect.height,
      closeTo(worldMapSourceSize.aspectRatio, .0001),
    );
  });
}
