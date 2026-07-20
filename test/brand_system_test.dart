import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:leone_portfolio/brand/leone_brand.dart';
import 'package:leone_portfolio/ld_identity.dart';
import 'package:leone_portfolio/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  group('brand tokens', () {
    test('preserve the shared D and action anchor', () {
      const dAnchor =
          LeoneBrandGeometry.markArtboardSize -
          LeoneBrandGeometry.markOuterInset -
          LeoneBrandGeometry.markDCornerRadius;
      const actionAnchor =
          LeoneBrandGeometry.markActionOffset +
          LeoneBrandGeometry.markActionSize -
          LeoneBrandGeometry.markActionRadius;

      expect(dAnchor, 186);
      expect(actionAnchor, dAnchor);
      expect(
        LeoneBrandGeometry.markClearSpace,
        LeoneBrandGeometry.markStroke * 2,
      );
    });

    test('keeps the opening timeline internally consistent', () {
      expect(
        LeoneBrandMotion.openingHold + LeoneBrandMotion.openingTransform,
        LeoneBrandMotion.openingTotal,
      );
      expect(
        LeoneBrandMotion.openingFrameStart,
        lessThan(LeoneBrandMotion.openingFabStart),
      );
      expect(
        LeoneBrandMotion.openingFabStart,
        lessThan(LeoneBrandMotion.openingViewportArrival),
      );
      expect(
        LeoneBrandMotion.openingViewportArrival,
        lessThan(LeoneBrandMotion.openingViewportExit),
      );
    });

    test('makes the mark become the exact viewport before it exits', () {
      const viewport = Size(390, 844);
      const viewPadding = EdgeInsets.only(right: 7, bottom: 23);
      const motionProgress =
          (LeoneBrandMotion.openingViewportArrival +
              LeoneBrandMotion.openingViewportExit) /
          2;
      const controllerProgress =
          LeoneBrandMotion.openingHoldFraction +
          (1 - LeoneBrandMotion.openingHoldFraction) * motionProgress;

      final geometry = LdOpeningFrameGeometry.resolve(
        viewport,
        controllerProgress,
        viewPadding: viewPadding,
      );
      expect(geometry.frameRect, Offset.zero & viewport);
      expect(geometry.backgroundOpacity, 1);
      expect(geometry.radius, greaterThan(0));
      expect(
        geometry.frameRect.right - geometry.bottomRightRadiusX,
        closeTo(geometry.fabBottomRightCornerCenter.dx, .001),
      );
      expect(
        geometry.frameRect.bottom - geometry.bottomRightRadiusY,
        closeTo(geometry.fabBottomRightCornerCenter.dy, .001),
      );
      expect(
        geometry.bottomRightRadiusX - ldFloatingActionRadius,
        closeTo(viewPadding.right + LeoneBrandGeometry.fabEdgeInset, .001),
      );
      expect(
        geometry.bottomRightRadiusY - ldFloatingActionRadius,
        closeTo(viewPadding.bottom + LeoneBrandGeometry.fabEdgeInset, .001),
      );
      expect(
        geometry.stroke / 2,
        lessThan(LeoneBrandGeometry.fabEdgeInset),
        reason: 'The settled FAB must clear the viewport stroke.',
      );
    });

    test('anchors the frame arc to the FAB bottom-right corner in motion', () {
      const viewport = Size(390, 844);
      const viewPadding = EdgeInsets.only(right: 7, bottom: 23);

      for (final progress in [0.0, .34, .48, .62, .76, .9, 1.0]) {
        final geometry = LdOpeningFrameGeometry.resolve(
          viewport,
          progress,
          viewPadding: viewPadding,
        );

        expect(
          geometry.frameRect.right - geometry.bottomRightRadiusX,
          closeTo(geometry.fabBottomRightCornerCenter.dx, .001),
          reason: 'horizontal center at progress $progress',
        );
        expect(
          geometry.frameRect.bottom - geometry.bottomRightRadiusY,
          closeTo(geometry.fabBottomRightCornerCenter.dy, .001),
          reason: 'vertical center at progress $progress',
        );
      }
    });

    test('keeps the frame stroke stable and clear of the FAB', () {
      const settledProgress =
          LeoneBrandMotion.openingHoldFraction +
          (1 - LeoneBrandMotion.openingHoldFraction) *
              LeoneBrandMotion.openingViewportArrival;

      for (final viewport in const [Size(390, 844), Size(1440, 1000)]) {
        final initial = LdOpeningFrameGeometry.resolve(viewport, 0);
        final settled = LdOpeningFrameGeometry.resolve(
          viewport,
          settledProgress,
        );

        expect(settled.stroke, closeTo(initial.stroke, .001));
        expect(settled.stroke, lessThanOrEqualTo(12));
        expect(
          LeoneBrandGeometry.fabEdgeInset - settled.stroke / 2,
          greaterThanOrEqualTo(10),
          reason: 'visible FAB clearance at $viewport',
        );
      }
    });

    test('uses accessible foregrounds on the core palette', () {
      expect(
        _contrast(LeoneBrandColors.ink, LeoneBrandColors.canvas),
        greaterThanOrEqualTo(7),
      );
      expect(
        _contrast(LeoneBrandColors.surfaceOnDark, LeoneBrandColors.canvas),
        greaterThanOrEqualTo(7),
      );
      expect(
        _contrast(LeoneBrandColors.canvas, LeoneBrandColors.action),
        greaterThanOrEqualTo(7),
      );
      expect(
        _contrast(LeoneBrandColors.ink, LeoneBrandColors.action),
        lessThan(3),
        reason: 'Light content must not be used on the action coral.',
      );
    });

    test('keeps the approved SVG variants on the canonical geometry', () {
      const variants = [
        'assets/brand/ld-mark.svg',
        'assets/brand/ld-mark-inverse.svg',
        'assets/brand/ld-mark-mono.svg',
      ];

      for (final path in variants) {
        final svg = File(path).readAsStringSync();
        expect(svg, contains('viewBox="0 0 256 256"'), reason: path);
        expect(svg, contains('stroke-width="14"'), reason: path);
        expect(
          svg,
          contains('x="155" y="155" width="48" height="48" rx="17"'),
          reason: path,
        );
      }
    });

    test('builds the app theme from the brand source of truth', () {
      final theme = LeoneBrandTheme.dark();

      expect(theme.useMaterial3, isTrue);
      expect(theme.scaffoldBackgroundColor, LeoneBrandColors.canvas);
      expect(theme.colorScheme.surface, LeoneBrandColors.surface);
      expect(theme.textTheme.bodyMedium?.fontFamily, LeoneBrand.fontFamily);
    });
  });

  testWidgets('opening resolves immediately when motion is reduced', (
    tester,
  ) async {
    var completed = false;

    await tester.pumpWidget(
      MaterialApp(
        home: MediaQuery(
          data: const MediaQueryData(disableAnimations: true),
          child: Stack(
            children: [
              LdOpeningTransition(onCompleted: () => completed = true),
            ],
          ),
        ),
      ),
    );
    await tester.pump();

    expect(completed, isTrue);
  });

  testWidgets('viewport controls meet the minimum target and stop autoplay', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: LeoneBrandTheme.dark(),
        home: const MediaQuery(
          data: MediaQueryData(disableAnimations: true),
          child: Scaffold(
            body: SizedBox(
              width: 800,
              height: 600,
              child: LdViewportStage(child: SizedBox.expand()),
            ),
          ),
        ),
      ),
    );

    final frame = find.byKey(const Key('ld-viewport-frame'));
    final initialSize = tester.getSize(frame);
    for (final preset in ['mobile', 'tablet', 'desktop']) {
      final target = find.byKey(Key('ld-mode-$preset'));
      expect(tester.getSize(target).height, greaterThanOrEqualTo(48));
    }

    await tester.pump(LeoneBrandMotion.viewportHold * 2);
    expect(tester.getSize(frame), initialSize);
  });

  testWidgets('functional FAB adopts the Material 3 endpoint geometry', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1440, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const LeonePortfolioApp());
    await tester.pump(LeoneBrandMotion.openingTotal);
    await tester.pump();

    final finder = find.byKey(const Key('portfolio-floating-action'));
    final fab = tester.widget<FloatingActionButton>(finder);
    final shape = fab.shape! as RoundedRectangleBorder;
    final radius = shape.borderRadius.resolve(TextDirection.ltr).topLeft.x;

    expect(tester.getSize(finder), const Size.square(56));
    expect(radius, LeoneBrandGeometry.fabCollapsedRadius);
    expect(fab.backgroundColor, LeoneBrandColors.action);
  });
}

double _contrast(Color foreground, Color background) {
  final foregroundLuminance = foreground.computeLuminance();
  final backgroundLuminance = background.computeLuminance();
  final lighter = foregroundLuminance > backgroundLuminance
      ? foregroundLuminance
      : backgroundLuminance;
  final darker = foregroundLuminance > backgroundLuminance
      ? backgroundLuminance
      : foregroundLuminance;
  return (lighter + .05) / (darker + .05);
}
