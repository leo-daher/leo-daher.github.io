import 'dart:ui';

import '../../generated/world_map_overlay_data.dart';

const worldMapSourceSize = Size(worldMapWidth, worldMapHeight);

/// Cached native geometry for the five countries with visible map polygons.
///
/// The generated input contains only numeric commands. Paths are created once
/// in source coordinates and then reused for paint and hit testing.
class PortfolioWorldMapGeometry {
  PortfolioWorldMapGeometry._()
    : _paths = Map.unmodifiable({
        for (final entry in worldMapInteractivePathCommands.entries)
          entry.key: _buildPath(entry.value),
      });

  static final shared = PortfolioWorldMapGeometry._();

  final Map<String, Path> _paths;

  Iterable<String> get countryIds => worldMapInteractiveCountryOrder;

  int get countryCount => _paths.length;

  Path? pathFor(String countryId) => _paths[countryId];

  String? hitTest(Offset position, Rect mapRect) {
    if (!mapRect.contains(position)) return null;

    final sourcePosition = Offset(
      (position.dx - mapRect.left) * worldMapWidth / mapRect.width,
      (position.dy - mapRect.top) * worldMapHeight / mapRect.height,
    );
    for (final countryId in worldMapInteractiveCountryOrder.reversed) {
      if (_paths[countryId]!.contains(sourcePosition)) return countryId;
    }
    return null;
  }
}

Rect worldMapRectFor(Size size) {
  final mapAspect = worldMapWidth / worldMapHeight;
  final availableAspect = size.width / size.height;
  late final Rect fittedMap;

  if (availableAspect > mapAspect) {
    final width = size.height * mapAspect;
    fittedMap = Rect.fromLTWH((size.width - width) / 2, 0, width, size.height);
  } else {
    final height = size.width / mapAspect;
    fittedMap = Rect.fromLTWH(
      0,
      (size.height - height) / 2,
      size.width,
      height,
    );
  }

  const zoom = 1.55;
  return Rect.fromCenter(
    center: fittedMap.center,
    width: fittedMap.width * zoom,
    height: fittedMap.height * zoom,
  );
}

Path _buildPath(List<double> commands) {
  assert(commands.length % 3 == 0);
  final path = Path();
  for (var index = 0; index < commands.length; index += 3) {
    final command = commands[index].toInt();
    final x = commands[index + 1] * worldMapWidth;
    final y = commands[index + 2] * worldMapHeight;
    switch (command) {
      case 0:
        path.moveTo(x, y);
        break;
      case 1:
        path.lineTo(x, y);
        break;
      case 2:
        path.close();
        break;
      default:
        throw StateError('Unknown world-map path command: $command');
    }
  }
  return path;
}
