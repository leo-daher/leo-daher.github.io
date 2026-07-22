import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'brand/leone_brand.dart';
import 'l10n/l10n.dart';

const ldFloatingActionColor = LeoneBrandColors.action;
const ldFloatingActionSize = LeoneBrandGeometry.fabSize;
const ldFloatingActionRadius = LeoneBrandGeometry.fabCollapsedRadius;

class LdFloatingActionGlyph extends StatelessWidget {
  const LdFloatingActionGlyph({
    super.key,
    this.size = ldFloatingActionSize,
    this.radius = ldFloatingActionRadius,
    this.color = ldFloatingActionColor,
    this.elevation = LeoneBrandGeometry.fabElevation,
  });

  final double size;
  final double radius;
  final Color color;
  final double elevation;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: size,
      child: Material(
        color: color,
        elevation: elevation,
        shadowColor: Colors.black.withValues(alpha: .28),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }
}

class LdOpeningTransition extends StatefulWidget {
  const LdOpeningTransition({
    super.key,
    required this.onCompleted,
    this.start = true,
  });

  final VoidCallback onCompleted;
  final bool start;

  @override
  State<LdOpeningTransition> createState() => _LdOpeningTransitionState();
}

class _LdOpeningTransitionState extends State<LdOpeningTransition>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: LeoneBrandMotion.openingTotal,
  );
  Timer? _completionFallback;
  bool _startScheduled = false;
  bool _started = false;
  bool _completed = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.start) _scheduleStartAfterFrame();
  }

  @override
  void didUpdateWidget(covariant LdOpeningTransition oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.start && !oldWidget.start) _start();
  }

  void _scheduleStartAfterFrame() {
    if (_started || _startScheduled) return;
    _startScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startScheduled = false;
      if (mounted && widget.start) _start();
    });
  }

  void _start() {
    if (_started) return;
    _started = true;
    _completionFallback = Timer(
      LeoneBrandMotion.openingTotal + const Duration(seconds: 1),
      () {
        if (mounted) _complete();
      },
    );
    final disableAnimations = MediaQuery.disableAnimationsOf(context);
    if (disableAnimations) {
      _controller.value = 1;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _complete();
      });
      return;
    }
    _controller.forward().whenComplete(() {
      if (mounted) _complete();
    });
  }

  void _complete() {
    if (_completed) return;
    _completed = true;
    _completionFallback?.cancel();
    widget.onCompleted();
  }

  @override
  void dispose() {
    _completionFallback?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewPadding = MediaQuery.viewPaddingOf(context);
    return Positioned.fill(
      child: Semantics(
        image: true,
        label: context.l10n.openingSemantics,
        child: AbsorbPointer(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final viewport = Size(
                constraints.maxWidth,
                constraints.maxHeight,
              );
              return AnimatedBuilder(
                animation: _controller,
                builder: (context, _) {
                  final fab = _LdOpeningFabPlacement.resolve(
                    viewport,
                    viewPadding,
                    _controller.value,
                  );
                  return Stack(
                    key: const Key('ld-opening-transition'),
                    children: [
                      CustomPaint(
                        painter: _LdOpeningPainter(
                          progress: _controller.value,
                          viewPadding: viewPadding,
                        ),
                        size: viewport,
                      ),
                      Positioned(
                        left: fab.center.dx - fab.size / 2,
                        top: fab.center.dy - fab.size / 2,
                        child: ExcludeSemantics(
                          child: LdFloatingActionGlyph(
                            key: const Key('ld-opening-floating-action'),
                            size: fab.size,
                            radius: fab.radius,
                            color: ldFloatingActionColor.withValues(
                              alpha: fab.opacity,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

class _LdOpeningFabPlacement {
  const _LdOpeningFabPlacement({
    required this.center,
    required this.size,
    required this.radius,
    required this.opacity,
  });

  final Offset center;
  final double size;
  final double radius;
  final double opacity;

  static _LdOpeningFabPlacement resolve(
    Size size,
    EdgeInsets viewPadding,
    double progress,
  ) {
    if (size.isEmpty) {
      return const _LdOpeningFabPlacement(
        center: Offset.zero,
        size: 0,
        radius: 0,
        opacity: 0,
      );
    }

    const holdFraction = LeoneBrandMotion.openingHoldFraction;
    final motionProgress = _interval(progress, holdFraction, 1, Curves.linear);
    final travel = _interval(
      motionProgress,
      LeoneBrandMotion.openingFabStart,
      LeoneBrandMotion.openingViewportArrival,
      Curves.easeInOutCubic,
    );
    final shortest = math.min(size.width, size.height);
    final compactSide = (shortest * .46).clamp(136.0, 204.0);
    final initialFrameRect = Rect.fromCenter(
      center: size.center(Offset.zero),
      width: compactSide,
      height: compactSide,
    );
    final initialRadius = compactSide * .18;
    final initialButtonSize = (compactSide * .19).clamp(26.0, 38.0);
    final initialButtonRadius = initialButtonSize * .35;
    final initialCornerCenter = Offset(
      initialFrameRect.right - initialRadius,
      initialFrameRect.bottom - initialRadius,
    );
    final initialButtonTopLeft = Offset(
      initialCornerCenter.dx - (initialButtonSize - initialButtonRadius),
      initialCornerCenter.dy - (initialButtonSize - initialButtonRadius),
    );
    final initialButtonCenter =
        initialButtonTopLeft +
        Offset(initialButtonSize / 2, initialButtonSize / 2);
    final finalButtonCenter = Offset(
      size.width -
          viewPadding.right -
          LeoneBrandGeometry.fabEdgeInset -
          ldFloatingActionSize / 2,
      size.height -
          LeoneBrandGeometry.fabEdgeInset -
          viewPadding.bottom -
          ldFloatingActionSize / 2,
    );

    return _LdOpeningFabPlacement(
      center: Offset.lerp(initialButtonCenter, finalButtonCenter, travel)!,
      size: _lerp(initialButtonSize, ldFloatingActionSize, travel),
      radius: _lerp(initialButtonRadius, ldFloatingActionRadius, travel),
      opacity: 1,
    );
  }

  static double _interval(double value, double begin, double end, Curve curve) {
    final normalized = ((value - begin) / (end - begin)).clamp(0.0, 1.0);
    return curve.transform(normalized);
  }

  static double _lerp(double begin, double end, double t) {
    return begin + (end - begin) * t;
  }
}

@immutable
class LdOpeningFrameGeometry {
  const LdOpeningFrameGeometry({
    required this.frameRect,
    required this.stroke,
    required this.radius,
    required this.bottomRightRadiusX,
    required this.bottomRightRadiusY,
    required this.fabBottomRightCornerCenter,
    required this.backgroundOpacity,
  });

  final Rect frameRect;
  final double stroke;
  final double radius;
  final double bottomRightRadiusX;
  final double bottomRightRadiusY;
  final Offset fabBottomRightCornerCenter;
  final double backgroundOpacity;

  static LdOpeningFrameGeometry resolve(
    Size size,
    double progress, {
    EdgeInsets viewPadding = EdgeInsets.zero,
  }) {
    if (size.isEmpty) {
      return const LdOpeningFrameGeometry(
        frameRect: Rect.zero,
        stroke: 0,
        radius: 0,
        bottomRightRadiusX: 0,
        bottomRightRadiusY: 0,
        fabBottomRightCornerCenter: Offset.zero,
        backgroundOpacity: 0,
      );
    }

    const holdFraction = LeoneBrandMotion.openingHoldFraction;
    final motionProgress = _interval(progress, holdFraction, 1, Curves.linear);
    final backgroundFade = _interval(
      motionProgress,
      LeoneBrandMotion.openingViewportExit,
      1,
      Curves.easeInCubic,
    );
    final viewportProgress = _interval(
      motionProgress,
      LeoneBrandMotion.openingFrameStart,
      LeoneBrandMotion.openingViewportArrival,
      Curves.easeInOutCubic,
    );
    final exitProgress = _interval(
      motionProgress,
      LeoneBrandMotion.openingViewportExit,
      1,
      Curves.easeInCubic,
    );
    final shortest = math.min(size.width, size.height);
    final compactSide = (shortest * .46).clamp(136.0, 204.0);
    final initialFrameRect = Rect.fromCenter(
      center: size.center(Offset.zero),
      width: compactSide,
      height: compactSide,
    );
    final viewportFrameRect = Offset.zero & size;
    final overshoot = (shortest * .1).clamp(56.0, 96.0);
    final expandedFrameRect = Rect.fromLTRB(
      -overshoot,
      -overshoot,
      size.width + overshoot,
      size.height + overshoot,
    );
    final fittedFrameRect = Rect.lerp(
      initialFrameRect,
      viewportFrameRect,
      viewportProgress,
    )!;
    final frameRect = Rect.lerp(
      fittedFrameRect,
      expandedFrameRect,
      exitProgress,
    )!;
    // Keep the frame at the optical weight of the original mark. Scaling the
    // stroke with the viewport made it consume the FAB's 16 dp visual gap on
    // large screens even though their centerline geometry was correct.
    final stroke = (compactSide * .058).clamp(8.0, 12.0);
    final fab = _LdOpeningFabPlacement.resolve(size, viewPadding, progress);
    final fabCornerCenterOffset = fab.size / 2 - fab.radius;
    final fabBottomRightCornerCenter = fab.center.translate(
      fabCornerCenterOffset,
      fabCornerCenterOffset,
    );
    final bottomRightRadiusX = (frameRect.right - fabBottomRightCornerCenter.dx)
        .clamp(0.0, frameRect.width / 2);
    final bottomRightRadiusY =
        (frameRect.bottom - fabBottomRightCornerCenter.dy).clamp(
          0.0,
          frameRect.height / 2,
        );

    return LdOpeningFrameGeometry(
      frameRect: frameRect,
      stroke: stroke,
      radius: math.min(bottomRightRadiusX, bottomRightRadiusY),
      bottomRightRadiusX: bottomRightRadiusX,
      bottomRightRadiusY: bottomRightRadiusY,
      fabBottomRightCornerCenter: fabBottomRightCornerCenter,
      backgroundOpacity: 1 - backgroundFade,
    );
  }

  static double _interval(double value, double begin, double end, Curve curve) {
    final normalized = ((value - begin) / (end - begin)).clamp(0.0, 1.0);
    return curve.transform(normalized);
  }
}

class _LdOpeningPainter extends CustomPainter {
  const _LdOpeningPainter({required this.progress, required this.viewPadding});

  final double progress;
  final EdgeInsets viewPadding;

  static const _background = LeoneBrandColors.canvas;
  static const _lColor = LeoneBrandColors.structureOnDark;
  static const _dColor = LeoneBrandColors.surfaceOnDark;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) return;

    final geometry = LdOpeningFrameGeometry.resolve(
      size,
      progress,
      viewPadding: viewPadding,
    );
    canvas.drawRect(
      Offset.zero & size,
      Paint()
        ..color = _background.withValues(alpha: geometry.backgroundOpacity),
    );

    final frameRect = geometry.frameRect;
    final stroke = geometry.stroke;
    final radius = geometry.radius;
    final bottomRightRadiusX = geometry.bottomRightRadiusX;
    final bottomRightRadiusY = geometry.bottomRightRadiusY;
    final opening = math.max(stroke * 1.55, radius * .58);
    final joinX = frameRect.right - bottomRightRadiusX - stroke * .18;
    final lRadius = radius * .76;
    const logoOpacity = 1.0;

    final lPath = Path()
      ..moveTo(frameRect.left, frameRect.top + opening)
      ..lineTo(frameRect.left, frameRect.bottom - lRadius)
      ..quadraticBezierTo(
        frameRect.left,
        frameRect.bottom,
        frameRect.left + lRadius,
        frameRect.bottom,
      )
      ..lineTo(joinX, frameRect.bottom);
    final dPath = Path()
      ..moveTo(frameRect.left + opening, frameRect.top)
      ..lineTo(frameRect.right - radius, frameRect.top)
      ..quadraticBezierTo(
        frameRect.right,
        frameRect.top,
        frameRect.right,
        frameRect.top + radius,
      )
      ..lineTo(frameRect.right, frameRect.bottom - bottomRightRadiusY)
      ..quadraticBezierTo(
        frameRect.right,
        frameRect.bottom,
        frameRect.right - bottomRightRadiusX,
        frameRect.bottom,
      )
      ..lineTo(joinX, frameRect.bottom);

    canvas.drawPath(lPath, _strokePaint(_lColor, stroke, logoOpacity));
    canvas.drawPath(dPath, _strokePaint(_dColor, stroke, logoOpacity));
  }

  Paint _strokePaint(Color color, double width, double opacity) => Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = width
    ..strokeCap = StrokeCap.round
    ..strokeJoin = StrokeJoin.round
    ..color = color.withValues(alpha: opacity);

  @override
  bool shouldRepaint(covariant _LdOpeningPainter oldDelegate) =>
      oldDelegate.progress != progress ||
      oldDelegate.viewPadding != viewPadding;
}

enum LdViewportPreset { mobile, tablet, desktop }

extension on LdViewportPreset {
  Size get designSize => switch (this) {
    LdViewportPreset.mobile => const Size(178, 308),
    LdViewportPreset.tablet => const Size(316, 240),
    LdViewportPreset.desktop => const Size(620, 260),
  };
}

@immutable
class LdViewportMorph {
  const LdViewportMorph({
    required this.from,
    required this.to,
    required this.progress,
  });

  final LdViewportPreset from;
  final LdViewportPreset to;
  final double progress;
}

typedef LdViewportBuilder =
    Widget Function(BuildContext context, LdViewportMorph morph);

@immutable
class LdViewportFrameSpec {
  const LdViewportFrameSpec({
    required this.id,
    required this.builder,
    this.showActionButton = true,
  });

  final String id;
  final LdViewportBuilder builder;
  final bool showActionButton;
}

class LdViewportStage extends StatefulWidget {
  const LdViewportStage({
    super.key,
    required this.frames,
    this.autoPlay = true,
    this.initialPreset = LdViewportPreset.desktop,
    this.spacing = 18,
    this.alignment = Alignment.center,
  }) : assert(frames.length > 0);

  final List<LdViewportFrameSpec> frames;
  final bool autoPlay;
  final LdViewportPreset initialPreset;
  final double spacing;
  final Alignment alignment;

  @override
  State<LdViewportStage> createState() => _LdViewportStageState();
}

class _LdViewportStageState extends State<LdViewportStage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: LeoneBrandMotion.viewportTransition,
    value: 1,
  );
  Timer? _timer;
  late LdViewportPreset _from;
  late LdViewportPreset _to;
  bool _motionDisabled = false;

  @override
  void initState() {
    super.initState();
    _from = widget.initialPreset;
    _to = widget.initialPreset;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final disabled = MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    if (_motionDisabled != disabled) {
      _motionDisabled = disabled;
      if (disabled) _controller.value = 1;
    }
    _restartTimer();
  }

  @override
  void didUpdateWidget(covariant LdViewportStage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.autoPlay != widget.autoPlay) _restartTimer();
  }

  void _restartTimer() {
    _timer?.cancel();
    if (!widget.autoPlay || _motionDisabled) return;
    _timer = Timer.periodic(LeoneBrandMotion.viewportHold, (_) => _advance());
  }

  void _advance() {
    final next = switch (_to) {
      LdViewportPreset.desktop => LdViewportPreset.mobile,
      LdViewportPreset.mobile => LdViewportPreset.tablet,
      LdViewportPreset.tablet => LdViewportPreset.desktop,
    };
    setState(() {
      _from = _to;
      _to = next;
      _controller.value = 0;
    });
    _controller.forward();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bounds = Size(constraints.maxWidth, constraints.maxHeight);
        final totalSpacing = widget.spacing * (widget.frames.length - 1);
        final frameBounds = Size(
          bounds.width,
          math.max(0, (bounds.height - totalSpacing) / widget.frames.length),
        );
        return AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            final progress = _motionDisabled
                ? 1.0
                : LeoneBrandMotion.viewportCurve.transform(_controller.value);
            final fromSize = _fitDesignSize(_from.designSize, frameBounds);
            final toSize = _fitDesignSize(_to.designSize, frameBounds);
            final frameSize = Size.lerp(fromSize, toSize, progress)!;
            final morph = LdViewportMorph(
              from: _from,
              to: _to,
              progress: progress,
            );
            return Align(
              alignment: widget.alignment,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (
                    var index = 0;
                    index < widget.frames.length;
                    index++
                  ) ...[
                    if (index > 0) SizedBox(height: widget.spacing),
                    Semantics(
                      key: Key(
                        'ld-viewport-semantics-${widget.frames[index].id}',
                      ),
                      container: true,
                      label: context.l10n.everySurface,
                      value: _to.name,
                      child: SizedBox(
                        key: Key(
                          'ld-viewport-frame-${widget.frames[index].id}',
                        ),
                        width: frameSize.width,
                        height: frameSize.height,
                        child: LdFrame(
                          showActionButton:
                              widget.frames[index].showActionButton,
                          child: widget.frames[index].builder(context, morph),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            );
          },
        );
      },
    );
  }

  Size _fitDesignSize(Size design, Size bounds) {
    if (bounds.width <= 0 || bounds.height <= 0) return Size.zero;
    final scale = math.min(
      bounds.width / design.width,
      bounds.height / design.height,
    );
    return Size(design.width * scale, design.height * scale);
  }
}

@immutable
class LdFrameGeometry {
  const LdFrameGeometry({
    required this.stroke,
    required this.radius,
    required this.lRadius,
    required this.contentInset,
    required this.contentRadius,
    required this.contentLRadius,
  });

  factory LdFrameGeometry.resolve(Size size) {
    if (size.isEmpty) {
      return const LdFrameGeometry(
        stroke: 0,
        radius: 0,
        lRadius: 0,
        contentInset: 0,
        contentRadius: 0,
        contentLRadius: 0,
      );
    }
    final shortest = math.min(size.width, size.height);
    final stroke = (shortest * .052).clamp(8.0, 14.0);
    final radius = math.min((shortest * .22).clamp(24.0, 72.0), shortest * .24);
    final lRadius = radius * .76;
    final contentInset = stroke + 5;
    return LdFrameGeometry(
      stroke: stroke,
      radius: radius,
      lRadius: lRadius,
      contentInset: contentInset,
      contentRadius: math.max(0, radius + stroke / 2 - contentInset),
      contentLRadius: math.max(0, lRadius + stroke / 2 - contentInset),
    );
  }

  final double stroke;
  final double radius;
  final double lRadius;
  final double contentInset;
  final double contentRadius;
  final double contentLRadius;

  Offset outerTopRightCenter(Size size) =>
      Offset(size.width - stroke / 2 - radius, stroke / 2 + radius);

  Offset contentTopRightCenter(Size size) => Offset(
    size.width - contentInset - contentRadius,
    contentInset + contentRadius,
  );

  Offset outerBottomLeftCenter(Size size) =>
      Offset(stroke / 2 + lRadius, size.height - stroke / 2 - lRadius);

  Offset contentBottomLeftCenter(Size size) => Offset(
    contentInset + contentLRadius,
    size.height - contentInset - contentLRadius,
  );
}

class LdFrame extends StatelessWidget {
  const LdFrame({
    super.key,
    required this.child,
    this.lColor,
    this.dColor,
    this.actionButtonColor = LeoneBrandColors.action,
    this.backgroundColor = Colors.transparent,
    this.showActionButton = true,
  });

  final Widget child;
  final Color? lColor;
  final Color? dColor;
  final Color actionButtonColor;
  final Color backgroundColor;
  final bool showActionButton;

  static ({Color l, Color d}) brandColorsFor(Brightness brightness) =>
      brightness == Brightness.light
      ? (
          l: LeoneBrandColors.structureOnLight,
          d: LeoneBrandColors.surfaceOnLight,
        )
      : (
          l: LeoneBrandColors.structureOnDark,
          d: LeoneBrandColors.surfaceOnDark,
        );

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Size(constraints.maxWidth, constraints.maxHeight);
        final geometry = LdFrameGeometry.resolve(size);
        final brandColors = brandColorsFor(Theme.of(context).brightness);
        return Stack(
          fit: StackFit.expand,
          children: [
            Padding(
              padding: EdgeInsets.all(geometry.contentInset),
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(geometry.contentLRadius),
                  topRight: Radius.circular(geometry.contentRadius),
                  bottomRight: Radius.circular(geometry.contentRadius),
                  bottomLeft: Radius.circular(geometry.contentLRadius),
                ),
                child: ColoredBox(color: backgroundColor, child: child),
              ),
            ),
            IgnorePointer(
              child: CustomPaint(
                painter: _LdFramePainter(
                  stroke: geometry.stroke,
                  radius: geometry.radius,
                  lColor: lColor ?? brandColors.l,
                  dColor: dColor ?? brandColors.d,
                  actionButtonColor: actionButtonColor,
                  showActionButton: showActionButton,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _LdFramePainter extends CustomPainter {
  const _LdFramePainter({
    required this.stroke,
    required this.radius,
    required this.lColor,
    required this.dColor,
    required this.actionButtonColor,
    required this.showActionButton,
  });

  final double stroke;
  final double radius;
  final Color lColor;
  final Color dColor;
  final Color actionButtonColor;
  final bool showActionButton;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) return;

    final halfStroke = stroke / 2;
    final left = halfStroke;
    final top = halfStroke;
    final right = size.width - halfStroke;
    final bottom = size.height - halfStroke;
    final r = math.min(radius, math.min(size.width, size.height) * .24);
    final lRadius = r * .76;
    final opening = math.max(stroke * 1.55, r * .58);
    final joinX = math.max(left + lRadius + stroke, right - r - stroke * .18);

    final lPath = Path()
      ..moveTo(left, top + opening)
      ..lineTo(left, bottom - lRadius)
      ..quadraticBezierTo(left, bottom, left + lRadius, bottom)
      ..lineTo(joinX, bottom);

    final dPath = Path()
      ..moveTo(left + opening, top)
      ..lineTo(right - r, top)
      ..quadraticBezierTo(right, top, right, top + r)
      ..lineTo(right, bottom - r)
      ..quadraticBezierTo(right, bottom, right - r, bottom)
      ..lineTo(joinX, bottom);

    canvas.saveLayer(Offset.zero & size, Paint());
    canvas.drawPath(lPath, _strokePaint(lColor));
    canvas.drawPath(dPath, _strokePaint(dColor));
    canvas.drawLine(
      Offset(joinX - stroke * .29, bottom + stroke * .57),
      Offset(joinX + stroke * .57, bottom - stroke * .57),
      Paint()
        ..blendMode = BlendMode.clear
        ..strokeWidth = stroke * (4 / 14)
        ..strokeCap = StrokeCap.round,
    );
    canvas.restore();

    if (showActionButton) {
      _paintActionButton(canvas, size, right, bottom);
    }
  }

  void _paintActionButton(
    Canvas canvas,
    Size size,
    double right,
    double bottom,
  ) {
    final frameRadius = math.min(
      radius,
      math.min(size.width, size.height) * .24,
    );
    final cornerCenter = Offset(right - frameRadius, bottom - frameRadius);
    final buttonSize = (frameRadius * 1.04).clamp(22.0, 52.0);
    final buttonRadius = buttonSize * .35;
    final buttonRect = Rect.fromLTWH(
      cornerCenter.dx - (buttonSize - buttonRadius),
      cornerCenter.dy - (buttonSize - buttonRadius),
      buttonSize,
      buttonSize,
    );
    final button = RRect.fromRectAndRadius(
      buttonRect,
      Radius.circular(buttonRadius),
    );

    canvas.drawRRect(
      button.shift(Offset(0, buttonSize * .08)),
      Paint()
        ..color = const Color(0xFF000000).withValues(alpha: .32)
        ..maskFilter = MaskFilter.blur(
          BlurStyle.normal,
          math.max(3, buttonSize * .16),
        ),
    );
    canvas.drawRRect(button, Paint()..color = actionButtonColor);
  }

  Paint _strokePaint(Color color) => Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = stroke
    ..strokeCap = StrokeCap.round
    ..strokeJoin = StrokeJoin.round
    ..color = color;

  @override
  bool shouldRepaint(covariant _LdFramePainter oldDelegate) =>
      oldDelegate.stroke != stroke ||
      oldDelegate.radius != radius ||
      oldDelegate.lColor != lColor ||
      oldDelegate.dColor != dColor ||
      oldDelegate.actionButtonColor != actionButtonColor ||
      oldDelegate.showActionButton != showActionButton;
}
