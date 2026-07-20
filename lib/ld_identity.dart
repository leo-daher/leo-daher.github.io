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
  const LdOpeningTransition({super.key, required this.onCompleted});

  final VoidCallback onCompleted;

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
  bool _started = false;
  bool _completed = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
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
    required this.fabCenter,
    required this.backgroundOpacity,
  });

  final Rect frameRect;
  final double stroke;
  final double radius;
  final double bottomRightRadiusX;
  final double bottomRightRadiusY;
  final Offset fabCenter;
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
        fabCenter: Offset.zero,
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
    final viewportStroke = (shortest * .04).clamp(18.0, 34.0);
    final stroke = _lerp(
      (compactSide * .058).clamp(8, 13),
      viewportStroke,
      viewportProgress,
    );
    final fab = _LdOpeningFabPlacement.resolve(size, viewPadding, progress);
    final bottomRightRadiusX = (frameRect.right - fab.center.dx).clamp(
      0.0,
      frameRect.width / 2,
    );
    final bottomRightRadiusY = (frameRect.bottom - fab.center.dy).clamp(
      0.0,
      frameRect.height / 2,
    );

    return LdOpeningFrameGeometry(
      frameRect: frameRect,
      stroke: stroke,
      radius: math.min(bottomRightRadiusX, bottomRightRadiusY),
      bottomRightRadiusX: bottomRightRadiusX,
      bottomRightRadiusY: bottomRightRadiusY,
      fabCenter: fab.center,
      backgroundOpacity: 1 - backgroundFade,
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
  String get label => switch (this) {
    LdViewportPreset.mobile => 'MOBILE',
    LdViewportPreset.tablet => 'TABLET',
    LdViewportPreset.desktop => 'DESKTOP',
  };

  String semanticsLabel(BuildContext context) => switch (this) {
    LdViewportPreset.mobile => context.l10n.mobileFormat,
    LdViewportPreset.tablet => context.l10n.tabletFormat,
    LdViewportPreset.desktop => context.l10n.desktopFormat,
  };

  Size get designSize => switch (this) {
    LdViewportPreset.mobile => const Size(178, 308),
    LdViewportPreset.tablet => const Size(316, 240),
    LdViewportPreset.desktop => const Size(620, 260),
  };
}

class LdViewportStage extends StatefulWidget {
  const LdViewportStage({
    super.key,
    required this.child,
    this.autoPlay = true,
    this.initialPreset = LdViewportPreset.mobile,
  });

  final Widget child;
  final bool autoPlay;
  final LdViewportPreset initialPreset;

  @override
  State<LdViewportStage> createState() => _LdViewportStageState();
}

class _LdViewportStageState extends State<LdViewportStage> {
  static const _holdDuration = LeoneBrandMotion.viewportHold;

  Timer? _timer;
  late LdViewportPreset _preset;
  bool _pointerInside = false;
  bool _focusInside = false;
  bool _motionDisabled = false;

  @override
  void initState() {
    super.initState();
    _preset = widget.initialPreset;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final disabled = MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    if (_motionDisabled == disabled && _timer != null) return;
    _motionDisabled = disabled;
    _restartTimer();
  }

  @override
  void didUpdateWidget(covariant LdViewportStage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.autoPlay != widget.autoPlay) _restartTimer();
  }

  void _restartTimer() {
    _timer?.cancel();
    if (!widget.autoPlay || _motionDisabled || _pointerInside || _focusInside) {
      return;
    }
    _timer = Timer.periodic(_holdDuration, (_) {
      if (!mounted) return;
      _select(_nextPreset(_preset), restartTimer: false);
    });
  }

  void _setPointerInside(bool value) {
    if (_pointerInside == value) return;
    _pointerInside = value;
    _restartTimer();
  }

  void _setFocusInside(bool value) {
    if (_focusInside == value) return;
    _focusInside = value;
    _restartTimer();
  }

  LdViewportPreset _nextPreset(LdViewportPreset value) => switch (value) {
    LdViewportPreset.mobile => LdViewportPreset.tablet,
    LdViewportPreset.tablet => LdViewportPreset.desktop,
    LdViewportPreset.desktop => LdViewportPreset.mobile,
  };

  void _select(LdViewportPreset value, {bool restartTimer = true}) {
    if (_preset != value) setState(() => _preset = value);
    if (restartTimer) _restartTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      canRequestFocus: false,
      skipTraversal: true,
      onFocusChange: _setFocusInside,
      child: MouseRegion(
        onEnter: (_) => _setPointerInside(true),
        onExit: (_) => _setPointerInside(false),
        child: Column(
          children: [
            _ViewportSelector(selected: _preset, onSelected: _select),
            const SizedBox(height: 16),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final target = _fitDesignSize(
                    _preset.designSize,
                    Size(constraints.maxWidth, constraints.maxHeight),
                  );
                  return Center(
                    child: Semantics(
                      container: true,
                      label: context.l10n.viewportInFormat(
                        _preset.semanticsLabel(context),
                      ),
                      child: AnimatedContainer(
                        key: const Key('ld-viewport-frame'),
                        duration: _motionDisabled
                            ? Duration.zero
                            : LeoneBrandMotion.viewportTransition,
                        curve: LeoneBrandMotion.viewportCurve,
                        width: target.width,
                        height: target.height,
                        child: LdFrame(child: widget.child),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
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

class _ViewportSelector extends StatelessWidget {
  const _ViewportSelector({required this.selected, required this.onSelected});

  final LdViewportPreset selected;
  final ValueChanged<LdViewportPreset> onSelected;

  @override
  Widget build(BuildContext context) {
    final motionDisabled = MediaQuery.disableAnimationsOf(context);
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .045),
        borderRadius: BorderRadius.circular(99),
        border: Border.all(color: Colors.white.withValues(alpha: .09)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final preset in LdViewportPreset.values)
            Semantics(
              button: true,
              selected: preset == selected,
              label: context.l10n.showFormat(preset.semanticsLabel(context)),
              child: InkWell(
                key: Key('ld-mode-${preset.name}'),
                onTap: () => onSelected(preset),
                borderRadius: BorderRadius.circular(99),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    minWidth: 64,
                    minHeight: 48,
                  ),
                  child: AnimatedContainer(
                    duration: motionDisabled
                        ? Duration.zero
                        : const Duration(milliseconds: 240),
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: 13),
                    decoration: BoxDecoration(
                      color: preset == selected
                          ? LeoneBrandColors.ink
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(99),
                    ),
                    child: Text(
                      preset.label,
                      style: TextStyle(
                        color: preset == selected
                            ? LeoneBrandColors.canvas
                            : LeoneBrandColors.mutedInk,
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        letterSpacing: .8,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class LdFrame extends StatelessWidget {
  const LdFrame({
    super.key,
    required this.child,
    this.lColor = LeoneBrandColors.structureOnDark,
    this.dColor = LeoneBrandColors.surfaceOnDark,
    this.actionButtonColor = LeoneBrandColors.action,
    this.backgroundColor = Colors.transparent,
    this.showActionButton = true,
  });

  final Widget child;
  final Color lColor;
  final Color dColor;
  final Color actionButtonColor;
  final Color backgroundColor;
  final bool showActionButton;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final shortest = math.min(constraints.maxWidth, constraints.maxHeight);
        final stroke = (shortest * .052).clamp(8.0, 14.0);
        final radius = (shortest * .22).clamp(24.0, 72.0);
        final inset = stroke + 5;
        return Stack(
          fit: StackFit.expand,
          children: [
            Padding(
              padding: EdgeInsets.all(inset),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(
                  math.max(10, radius - stroke * .72),
                ),
                child: ColoredBox(color: backgroundColor, child: child),
              ),
            ),
            IgnorePointer(
              child: CustomPaint(
                painter: _LdFramePainter(
                  stroke: stroke,
                  radius: radius,
                  lColor: lColor,
                  dColor: dColor,
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

    final shadowPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke + 1
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..color = dColor.withValues(alpha: .09)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 9);
    canvas.drawPath(dPath, shadowPaint);

    canvas.drawPath(lPath, _strokePaint(lColor));
    canvas.drawPath(dPath, _strokePaint(dColor));

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
