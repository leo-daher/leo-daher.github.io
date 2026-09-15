import 'dart:ui';

import 'package:material_ui/material_ui.dart';

import 'leone_brand.dart';

@immutable
class LeoneVisualStyle extends ThemeExtension<LeoneVisualStyle> {
  const LeoneVisualStyle({required this.usesGlass});

  static const standard = LeoneVisualStyle(usesGlass: false);
  static const glass = LeoneVisualStyle(usesGlass: true);

  final bool usesGlass;

  @override
  LeoneVisualStyle copyWith({bool? usesGlass}) =>
      LeoneVisualStyle(usesGlass: usesGlass ?? this.usesGlass);

  @override
  LeoneVisualStyle lerp(covariant LeoneVisualStyle? other, double t) =>
      t < .5 ? this : (other ?? this);
}

extension LeoneVisualStyleContext on BuildContext {
  bool get usesLeoneGlass =>
      Theme.of(this).extension<LeoneVisualStyle>()?.usesGlass ?? false;
}

/// Applies the alternative Apple-inspired material system without changing
/// the public portfolio theme.
class LeoneGlassExperience extends StatelessWidget {
  const LeoneGlassExperience({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final theme = LeoneBrandTheme.glass(brightness);
    final palette = theme.extension<LeonePalette>()!;
    return Theme(
      data: theme.copyWith(extensions: [palette, LeoneVisualStyle.glass]),
      child: LeoneGlassBackground(child: child),
    );
  }
}

/// Keeps the rich background behind regular translucent materials. Liquid
/// Glass remains reserved for navigation and controls.
class LeoneGlassBackground extends StatelessWidget {
  const LeoneGlassBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (!context.usesLeoneGlass || MediaQuery.highContrastOf(context)) {
      return ColoredBox(color: context.leonePalette.canvas, child: child);
    }

    final light = Theme.of(context).brightness == Brightness.light;
    return Stack(
      key: const Key('ios-glass-background'),
      fit: StackFit.expand,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            color: context.leonePalette.canvas,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: light
                  ? const [Color(0xFFF7F7FB), Color(0xFFECEBFA)]
                  : const [Color(0xFF08080D), Color(0xFF11101C)],
            ),
          ),
        ),
        Positioned(
          top: -180,
          right: -130,
          width: 560,
          height: 560,
          child: _GlassGlow(
            color: LeoneBrandColors.interactive.withValues(
              alpha: light ? .22 : .2,
            ),
          ),
        ),
        Positioned(
          top: 620,
          left: -220,
          width: 650,
          height: 650,
          child: _GlassGlow(
            color: LeoneBrandColors.intelligence.withValues(
              alpha: light ? .16 : .13,
            ),
          ),
        ),
        Positioned(
          bottom: -220,
          right: -180,
          width: 620,
          height: 620,
          child: _GlassGlow(
            color: LeoneBrandColors.editorialHighlight.withValues(
              alpha: light ? .15 : .12,
            ),
          ),
        ),
        child,
      ],
    );
  }
}

class _GlassGlow extends StatelessWidget {
  const _GlassGlow({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) => IgnorePointer(
    child: ExcludeSemantics(
      child: DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(colors: [color, Colors.transparent]),
        ),
      ),
    ),
  );
}

/// Adds the blur component of a standard Apple material to an existing card.
/// The card keeps ownership of tint, border, interaction and semantics.
class LeoneGlassSurface extends StatelessWidget {
  const LeoneGlassSurface({
    super.key,
    required this.child,
    required this.borderRadius,
    this.blurSigma = 20,
  });

  final Widget child;
  final BorderRadius borderRadius;
  final double blurSigma;

  @override
  Widget build(BuildContext context) {
    if (!context.usesLeoneGlass || MediaQuery.highContrastOf(context)) {
      return child;
    }

    return ClipRRect(
      borderRadius: borderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
        child: child,
      ),
    );
  }
}
