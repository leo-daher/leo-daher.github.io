import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../brand/leone_brand.dart';
import '../../ld_identity.dart';

class IdentityLogoFigure extends StatelessWidget {
  const IdentityLogoFigure({
    super.key,
    required this.caption,
    required this.semanticLabel,
  });

  final String caption;
  final String semanticLabel;

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return _ArticleFigure(
      figureKey: const Key('identity-logo-figure'),
      caption: caption,
      semanticLabel: semanticLabel,
      child: SizedBox(
        height: 300,
        child: Center(
          child: SvgPicture.asset(
            dark
                ? 'assets/brand/ld-mark-inverse.svg'
                : 'assets/brand/ld-mark.svg',
            width: 210,
            height: 210,
            excludeFromSemantics: true,
          ),
        ),
      ),
    );
  }
}

class IdentityExplodedFigure extends StatelessWidget {
  const IdentityExplodedFigure({
    super.key,
    required this.caption,
    required this.semanticLabel,
    required this.lLabel,
    required this.dLabel,
    required this.cutLabel,
    required this.dotLabel,
  });

  final String caption;
  final String semanticLabel;
  final String lLabel;
  final String dLabel;
  final String cutLabel;
  final String dotLabel;

  @override
  Widget build(BuildContext context) {
    final palette = context.leonePalette;
    final brightness = Theme.of(context).brightness;
    final brandColors = LdFrame.brandColorsFor(brightness);
    return _ArticleFigure(
      figureKey: const Key('identity-exploded-figure'),
      caption: caption,
      semanticLabel: semanticLabel,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 560;
          return Column(
            children: [
              AspectRatio(
                aspectRatio: compact ? 1.48 : 2.15,
                child: CustomPaint(
                  painter: _ExplodedMarkPainter(
                    background: palette.surfaceRaised,
                    guide: palette.mutedInk,
                    lColor: brandColors.l,
                    dColor: brandColors.d,
                  ),
                  size: Size.infinite,
                ),
              ),
              SizedBox(height: compact ? 14 : 20),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 8,
                runSpacing: 8,
                children: [
                  _FigureLegend(label: lLabel, color: brandColors.l),
                  _FigureLegend(label: dLabel, color: brandColors.d),
                  _FigureLegend(
                    label: cutLabel,
                    color: LeoneBrandColors.editorialWarm,
                  ),
                  _FigureLegend(
                    label: dotLabel,
                    color: LeoneBrandColors.action,
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

class IdentityFabFigure extends StatelessWidget {
  const IdentityFabFigure({
    super.key,
    required this.caption,
    required this.semanticLabel,
    required this.brandDotLabel,
    required this.functionalFabLabel,
  });

  final String caption;
  final String semanticLabel;
  final String brandDotLabel;
  final String functionalFabLabel;

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return _ArticleFigure(
      figureKey: const Key('identity-fab-figure'),
      caption: caption,
      semanticLabel: semanticLabel,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 520;
          final brandStage = _FigureStage(
            label: brandDotLabel,
            child: SizedBox.square(
              dimension: 142,
              child: SvgPicture.asset(
                dark
                    ? 'assets/brand/ld-mark-inverse.svg'
                    : 'assets/brand/ld-mark.svg',
                excludeFromSemantics: true,
              ),
            ),
          );
          final fabStage = _FigureStage(
            label: functionalFabLabel,
            child: IgnorePointer(
              child: FloatingActionButton(
                heroTag: null,
                onPressed: _noop,
                elevation: LeoneBrandGeometry.fabElevation,
                backgroundColor: LeoneBrandColors.action,
                foregroundColor: LeoneBrandColors.canvas,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    LeoneBrandGeometry.fabCollapsedRadius,
                  ),
                ),
                child: const Icon(Icons.menu_rounded, size: 24),
              ),
            ),
          );
          final arrow = Icon(
            compact
                ? Icons.arrow_downward_rounded
                : Icons.arrow_forward_rounded,
            color: LeoneBrandColors.interactive,
            size: 30,
          );
          if (compact) {
            return Column(
              children: [
                brandStage,
                const SizedBox(height: 14),
                arrow,
                const SizedBox(height: 14),
                fabStage,
              ],
            );
          }
          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(child: brandStage),
              const SizedBox(width: 18),
              arrow,
              const SizedBox(width: 18),
              Expanded(child: fabStage),
            ],
          );
        },
      ),
    );
  }

  static void _noop() {}
}

class IdentityOpeningSequenceFigure extends StatelessWidget {
  const IdentityOpeningSequenceFigure({
    super.key,
    required this.caption,
    required this.semanticLabel,
    required this.logoLabel,
    required this.expansionLabel,
    required this.viewportLabel,
    required this.interfaceLabel,
  });

  final String caption;
  final String semanticLabel;
  final String logoLabel;
  final String expansionLabel;
  final String viewportLabel;
  final String interfaceLabel;

  static double _motionProgress(double progress) {
    final hold = LeoneBrandMotion.openingHoldFraction;
    return hold + (1 - hold) * progress;
  }

  @override
  Widget build(BuildContext context) {
    final stages = [
      (label: logoLabel, progress: 0.0, interfaceVisible: false),
      (
        label: expansionLabel,
        progress: _motionProgress(.40),
        interfaceVisible: false,
      ),
      (
        label: viewportLabel,
        progress: _motionProgress(LeoneBrandMotion.openingViewportArrival),
        interfaceVisible: false,
      ),
      (label: interfaceLabel, progress: 1.0, interfaceVisible: true),
    ];
    return _ArticleFigure(
      figureKey: const Key('identity-opening-sequence-figure'),
      caption: caption,
      semanticLabel: semanticLabel,
      child: LayoutBuilder(
        builder: (context, constraints) {
          const gap = 12.0;
          final columns = constraints.maxWidth >= 720 ? 4 : 2;
          final itemWidth =
              (constraints.maxWidth - gap * (columns - 1)) / columns;
          return Wrap(
            spacing: gap,
            runSpacing: 18,
            children: [
              for (final stage in stages)
                SizedBox(
                  width: itemWidth,
                  child: _OpeningStage(
                    label: stage.label,
                    progress: stage.progress,
                    interfaceVisible: stage.interfaceVisible,
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _ArticleFigure extends StatelessWidget {
  const _ArticleFigure({
    required this.figureKey,
    required this.caption,
    required this.semanticLabel,
    required this.child,
  });

  final Key figureKey;
  final String caption;
  final String semanticLabel;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final palette = context.leonePalette;
    return Column(
      key: figureKey,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Semantics(
          image: true,
          label: semanticLabel,
          child: ExcludeFocus(
            excluding: true,
            child: IgnorePointer(
              child: ExcludeSemantics(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: palette.surfaceRaised,
                    border: Border.all(color: palette.outline),
                    borderRadius: BorderRadius.circular(28),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: child,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          caption,
          style: TextStyle(color: palette.mutedInk, fontSize: 13, height: 1.45),
        ),
      ],
    );
  }
}

class _FigureLegend extends StatelessWidget {
  const _FigureLegend({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final palette = context.leonePalette;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: palette.canvas.withValues(alpha: .5),
        border: Border.all(color: color.withValues(alpha: .38)),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              label,
              style: TextStyle(
                color: palette.ink,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FigureStage extends StatelessWidget {
  const _FigureStage({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final palette = context.leonePalette;
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 210),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: palette.canvas.withValues(alpha: .58),
        border: Border.all(color: palette.outline),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          child,
          const SizedBox(height: 18),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }
}

class _OpeningStage extends StatelessWidget {
  const _OpeningStage({
    required this.label,
    required this.progress,
    required this.interfaceVisible,
  });

  final String label;
  final double progress;
  final bool interfaceVisible;

  @override
  Widget build(BuildContext context) {
    final palette = context.leonePalette;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AspectRatio(
          aspectRatio: 4 / 3,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: palette.canvas,
                border: Border.all(color: palette.outline),
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (interfaceVisible)
                    CustomPaint(
                      painter: _InterfaceSketchPainter(
                        background: palette.canvas,
                        ink: palette.ink,
                        mutedInk: palette.mutedInk,
                      ),
                    ),
                  FittedBox(
                    fit: BoxFit.fill,
                    child: SizedBox(
                      width: 400,
                      height: 300,
                      child: LdOpeningSnapshot(
                        progress: progress,
                        viewPadding: EdgeInsets.zero,
                        fabChild: interfaceVisible
                            ? const Icon(
                                Icons.menu_rounded,
                                size: 24,
                                color: LeoneBrandColors.canvas,
                              )
                            : null,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: palette.mutedInk,
            fontSize: 12,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class _ExplodedMarkPainter extends CustomPainter {
  const _ExplodedMarkPainter({
    required this.background,
    required this.guide,
    required this.lColor,
    required this.dColor,
  });

  final Color background;
  final Color guide;
  final Color lColor;
  final Color dColor;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) return;
    final side = math.min(size.height * .72, size.width * .50);
    final scale = side / LeoneBrandGeometry.markArtboardSize;
    final origin = Offset((size.width - side) / 2, (size.height - side) / 2);
    final lShift = Offset(-side * .34, side * .08);
    final dShift = Offset(side * .26, -side * .08);
    final dotShift = Offset(side * .42, side * .12);

    final ghostL = _lPath(origin, scale, Offset.zero);
    final ghostD = _dPath(origin, scale, Offset.zero);
    canvas.drawPath(ghostL, _stroke(lColor.withValues(alpha: .10), scale));
    canvas.drawPath(ghostD, _stroke(dColor.withValues(alpha: .10), scale));
    _drawAction(
      canvas,
      origin,
      scale,
      Offset.zero,
      LeoneBrandColors.action.withValues(alpha: .10),
      shadow: false,
    );

    _drawGuide(canvas, origin + Offset(side * .28, side * .55), lShift);
    _drawGuide(canvas, origin + Offset(side * .68, side * .32), dShift);
    _drawGuide(canvas, origin + Offset(side * .70, side * .70), dotShift);

    canvas.drawPath(_lPath(origin, scale, lShift), _stroke(lColor, scale));
    canvas.drawPath(_dPath(origin, scale, dShift), _stroke(dColor, scale));
    _drawAction(
      canvas,
      origin,
      scale,
      dotShift,
      LeoneBrandColors.action,
      shadow: true,
    );

    final cutStart = _point(origin, scale, 176, 240);
    final cutEnd = _point(origin, scale, 188, 224);
    canvas.drawLine(
      cutStart,
      cutEnd,
      Paint()
        ..color = background
        ..strokeWidth = math.max(2, 4 * scale)
        ..strokeCap = StrokeCap.round,
    );
    final cutCenter = Offset.lerp(cutStart, cutEnd, .5)!;
    canvas.drawCircle(
      cutCenter,
      math.max(6, 11 * scale),
      Paint()
        ..color = LeoneBrandColors.editorialWarm
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
  }

  Paint _stroke(Color color, double scale) => Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = LeoneBrandGeometry.markStroke * scale
    ..strokeCap = StrokeCap.round
    ..strokeJoin = StrokeJoin.round
    ..color = color;

  void _drawGuide(Canvas canvas, Offset start, Offset shift) {
    final paint = Paint()
      ..color = guide.withValues(alpha: .22)
      ..strokeWidth = 1.2;
    const segments = 7;
    for (var index = 0; index < segments; index += 2) {
      final from = Offset.lerp(start, start + shift, index / segments)!;
      final to = Offset.lerp(
        start,
        start + shift,
        math.min(1, (index + 1) / segments),
      )!;
      canvas.drawLine(from, to, paint);
    }
  }

  void _drawAction(
    Canvas canvas,
    Offset origin,
    double scale,
    Offset shift,
    Color color, {
    required bool shadow,
  }) {
    final rect = Rect.fromLTWH(
      origin.dx + LeoneBrandGeometry.markActionOffset * scale + shift.dx,
      origin.dy + LeoneBrandGeometry.markActionOffset * scale + shift.dy,
      LeoneBrandGeometry.markActionSize * scale,
      LeoneBrandGeometry.markActionSize * scale,
    );
    final button = RRect.fromRectAndRadius(
      rect,
      Radius.circular(LeoneBrandGeometry.markActionRadius * scale),
    );
    if (shadow) {
      canvas.drawRRect(
        button.shift(Offset(0, 4 * scale)),
        Paint()
          ..color = Colors.black.withValues(alpha: .32)
          ..maskFilter = MaskFilter.blur(
            BlurStyle.normal,
            math.max(3, 8 * scale),
          ),
      );
    }
    canvas.drawRRect(button, Paint()..color = color);
  }

  Path _lPath(Offset origin, double scale, Offset shift) {
    Offset p(double x, double y) => _point(origin, scale, x, y) + shift;
    return Path()
      ..moveTo(p(24, 50).dx, p(24, 50).dy)
      ..lineTo(p(24, 196).dx, p(24, 196).dy)
      ..quadraticBezierTo(
        p(24, 232).dx,
        p(24, 232).dy,
        p(60, 232).dx,
        p(60, 232).dy,
      )
      ..lineTo(p(180, 232).dx, p(180, 232).dy);
  }

  Path _dPath(Offset origin, double scale, Offset shift) {
    Offset p(double x, double y) => _point(origin, scale, x, y) + shift;
    return Path()
      ..moveTo(p(50, 24).dx, p(50, 24).dy)
      ..lineTo(p(186, 24).dx, p(186, 24).dy)
      ..quadraticBezierTo(
        p(232, 24).dx,
        p(232, 24).dy,
        p(232, 70).dx,
        p(232, 70).dy,
      )
      ..lineTo(p(232, 186).dx, p(232, 186).dy)
      ..quadraticBezierTo(
        p(232, 232).dx,
        p(232, 232).dy,
        p(186, 232).dx,
        p(186, 232).dy,
      )
      ..lineTo(p(180, 232).dx, p(180, 232).dy);
  }

  Offset _point(Offset origin, double scale, double x, double y) =>
      Offset(origin.dx + x * scale, origin.dy + y * scale);

  @override
  bool shouldRepaint(covariant _ExplodedMarkPainter oldDelegate) =>
      oldDelegate.background != background ||
      oldDelegate.guide != guide ||
      oldDelegate.lColor != lColor ||
      oldDelegate.dColor != dColor;
}

class _InterfaceSketchPainter extends CustomPainter {
  const _InterfaceSketchPainter({
    required this.background,
    required this.ink,
    required this.mutedInk,
  });

  final Color background;
  final Color ink;
  final Color mutedInk;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = background);
    final guide = Paint()..color = mutedInk.withValues(alpha: .22);
    final accent = Paint()..color = LeoneBrandColors.interactive;
    final blue = Paint()..color = LeoneBrandColors.intelligence;

    final header = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        size.width * .08,
        size.height * .10,
        size.width * .66,
        size.height * .09,
      ),
      const Radius.circular(999),
    );
    canvas.drawRRect(header, guide);
    canvas.drawCircle(
      Offset(size.width * .12, size.height * .145),
      size.shortestSide * .018,
      accent,
    );

    final title = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        size.width * .08,
        size.height * .30,
        size.width * .46,
        size.height * .12,
      ),
      const Radius.circular(8),
    );
    canvas.drawRRect(title, Paint()..color = ink.withValues(alpha: .72));

    final primaryCard = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        size.width * .08,
        size.height * .52,
        size.width * .48,
        size.height * .29,
      ),
      const Radius.circular(12),
    );
    final secondaryCard = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        size.width * .61,
        size.height * .30,
        size.width * .23,
        size.height * .30,
      ),
      const Radius.circular(12),
    );
    canvas.drawRRect(
      primaryCard,
      accent..color = accent.color.withValues(alpha: .34),
    );
    canvas.drawRRect(
      secondaryCard,
      blue..color = blue.color.withValues(alpha: .28),
    );
  }

  @override
  bool shouldRepaint(covariant _InterfaceSketchPainter oldDelegate) =>
      oldDelegate.background != background ||
      oldDelegate.ink != ink ||
      oldDelegate.mutedInk != mutedInk;
}
