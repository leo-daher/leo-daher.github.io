import 'dart:io';
import 'dart:ui' as ui;

import 'package:material_ui/material_ui.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:leone_portfolio/brand/leone_brand.dart';
import 'package:leone_portfolio/features/apps/production_apps.dart';
import 'package:leone_portfolio/l10n/app_localizations_en.dart';
import 'package:leone_portfolio/l10n/app_localizations_pt.dart';

void main() {
  setUpAll(() async {
    final loader = FontLoader('Inter');
    loader.addFont(rootBundle.load('assets/fonts/InterVariable.ttf'));
    await loader.load();
  });
  for (final width in [390.0, 1200.0]) {
    testWidgets('MAG team evidence expands at width $width', (tester) async {
      tester.view.physicalSize = Size(width, 3000);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final presentation = ProductionAppsPresentation.localized(
        width < 600 ? AppLocalizationsPt() : AppLocalizationsEn(),
      );
      final mag = presentation.apps.singleWhere(
        (app) => app.id == 'mag-venda-digital',
      );
      final evidence = mag.recognition!;
      final boundaryKey = GlobalKey();
      await tester.pumpWidget(
        MaterialApp(
          theme: LeoneBrandTheme.dark(),
          home: Scaffold(
            body: SingleChildScrollView(
              child: RepaintBoundary(
                key: boundaryKey,
                child: ColoredBox(
                  color: LeoneBrandColors.canvas,
                  child: ProductionAppsSection(
                    content: presentation.content,
                    apps: [mag],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.runAsync(() async {
        final context = boundaryKey.currentContext!;
        await Future.wait([
          for (final asset in [
            evidence.imageAssetPath,
            ...mag.iconAssetPaths,
            ...mag.screenshots.map((screenshot) => screenshot.assetPath),
          ])
            precacheImage(AssetImage(asset), context),
        ]);
      });
      await tester.pumpAndSettle();
      expect(find.text(evidence.text), findsNothing);
      await tester.tap(find.text(evidence.title));
      await tester.pumpAndSettle();
      expect(find.text(evidence.text), findsOneWidget);
      expect(evidence.text, contains('Leone Crespo Daher de Souza'));
      expect(evidence.text, contains('Venda Digital'));
      expect(evidence.text, contains('SERPRO'));
      expect(mag.stack, contains('SERPRO API'));
      expect(find.bySemanticsLabel(evidence.imageLabel), findsOneWidget);
      expect(tester.takeException(), isNull);
      final qaPath = Platform.environment['PORTFOLIO_QA_DIR'];
      if (qaPath != null) {
        await tester.runAsync(() async {
          final boundary =
              boundaryKey.currentContext!.findRenderObject()
                  as RenderRepaintBoundary;
          final image = await boundary.toImage();
          final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
          await Directory(qaPath).create(recursive: true);
          await File('$qaPath/mag-${width.toInt()}.png')
              .writeAsBytes(bytes!.buffer.asUint8List());
          image.dispose();
        });
      }
    });
  }
}
