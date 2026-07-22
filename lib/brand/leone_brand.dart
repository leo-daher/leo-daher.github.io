import 'package:flutter/material.dart';

/// Canonical identity and product-design tokens for the Leone Daher brand.
///
/// Keep public-facing brand decisions here so the logo, opening transition and
/// portfolio theme cannot silently drift apart.
abstract final class LeoneBrand {
  static const name = 'Leone Daher';
  static const technicalReading = 'Leone Developer';
  static const idea = 'A marca se torna a interface.';
  static const essence = 'Adaptação com intenção.';
  static const signaturePtBr = 'Suas ideias. Em todo lugar.';
  static const signatureEn = 'Your ideas. Everywhere.';
  static const fontFamily = 'Inter';
  static const fontFamilyFallback = ['Roboto', 'Arial', 'sans-serif'];
}

abstract final class LeoneBrandColors {
  static const canvas = Color(0xFF08080D);
  static const surface = Color(0xFF0E0E18);
  static const surfaceRaised = Color(0xFF151426);
  static const ink = Color(0xFFF3F6F5);
  static const mutedInk = Color(0xFFA5A2B4);

  static const structureOnDark = ink;
  static const surfaceOnDark = Color(0xFFCFC7F4);
  static const structureOnLight = Color(0xFF111318);
  static const surfaceOnLight = Color(0xFF30313A);

  static const action = Color(0xFFFF6B55);
  static const interactive = Color(0xFF9A7BFF);
  static const intelligence = Color(0xFF55B8FF);
  static const editorialHighlight = Color(0xFFFF6F91);
  static const editorialWarm = Color(0xFFFFB464);
}

@immutable
class LeonePalette extends ThemeExtension<LeonePalette> {
  const LeonePalette({
    required this.canvas,
    required this.surface,
    required this.surfaceRaised,
    required this.ink,
    required this.mutedInk,
    required this.outline,
  });

  static const dark = LeonePalette(
    canvas: LeoneBrandColors.canvas,
    surface: LeoneBrandColors.surface,
    surfaceRaised: LeoneBrandColors.surfaceRaised,
    ink: LeoneBrandColors.ink,
    mutedInk: LeoneBrandColors.mutedInk,
    outline: Color(0x1AFFFFFF),
  );

  static const light = LeonePalette(
    canvas: Color(0xFFF7F7FB),
    surface: Color(0xFFFFFFFF),
    surfaceRaised: Color(0xFFF0F0F7),
    ink: Color(0xFF171721),
    mutedInk: Color(0xFF5D5D6B),
    outline: Color(0x1A171721),
  );

  final Color canvas;
  final Color surface;
  final Color surfaceRaised;
  final Color ink;
  final Color mutedInk;
  final Color outline;

  @override
  LeonePalette copyWith({
    Color? canvas,
    Color? surface,
    Color? surfaceRaised,
    Color? ink,
    Color? mutedInk,
    Color? outline,
  }) => LeonePalette(
    canvas: canvas ?? this.canvas,
    surface: surface ?? this.surface,
    surfaceRaised: surfaceRaised ?? this.surfaceRaised,
    ink: ink ?? this.ink,
    mutedInk: mutedInk ?? this.mutedInk,
    outline: outline ?? this.outline,
  );

  @override
  LeonePalette lerp(covariant LeonePalette? other, double t) {
    if (other == null) return this;
    return LeonePalette(
      canvas: Color.lerp(canvas, other.canvas, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceRaised: Color.lerp(surfaceRaised, other.surfaceRaised, t)!,
      ink: Color.lerp(ink, other.ink, t)!,
      mutedInk: Color.lerp(mutedInk, other.mutedInk, t)!,
      outline: Color.lerp(outline, other.outline, t)!,
    );
  }
}

extension LeoneThemeContext on BuildContext {
  LeonePalette get leonePalette =>
      Theme.of(this).extension<LeonePalette>() ??
      (Theme.of(this).brightness == Brightness.light
          ? LeonePalette.light
          : LeonePalette.dark);
}

abstract final class LeoneBrandGeometry {
  // Static mark master: assets/brand/ld-mark*.svg.
  static const markArtboardSize = 256.0;
  static const markOuterInset = 24.0;
  static const markStroke = 14.0;
  static const markDCornerRadius = 46.0;
  static const markLBottomRadius = 36.0;
  static const markActionOffset = 155.0;
  static const markActionSize = 48.0;
  static const markActionRadius = 17.0;
  static const markClearSpace = markStroke * 2;

  static const fullMarkMinSize = 32.0;
  static const microMarkMinSize = 16.0;

  // Functional Material 3 FAB reached at the end of the opening transition.
  static const fabSize = 56.0;
  static const fabCollapsedRadius = 16.0;
  static const fabExpandedRadius = fabSize / 2;
  static const fabEdgeInset = 16.0;
  static const fabElevation = 6.0;
  static const fabMenuBackdropSigma = 3.0;
}

abstract final class LeoneBrandMotion {
  // Let the initial mark register before the existing fast transformation.
  static const openingHold = Duration(milliseconds: 700);
  static const openingTransform = Duration(milliseconds: 950);
  static const openingTotal = Duration(milliseconds: 1650);
  static const openingHoldFraction = 700 / 1650;
  static const openingFrameStart = 0.08;
  static const openingFabStart = 0.12;
  static const openingViewportArrival = 0.70;
  static const openingViewportExit = 0.76;

  static const viewportTransition = Duration(milliseconds: 900);
  static const viewportHold = Duration(milliseconds: 4800);
  static const Curve viewportCurve = Curves.easeInOutCubic;

  static const fabMenuExpand = Duration(milliseconds: 420);
  static const fabMenuCollapse = Duration(milliseconds: 320);
}

abstract final class LeoneBrandTheme {
  static ThemeData dark() =>
      _build(brightness: Brightness.dark, palette: LeonePalette.dark);

  static ThemeData light() =>
      _build(brightness: Brightness.light, palette: LeonePalette.light);

  static ThemeData _build({
    required Brightness brightness,
    required LeonePalette palette,
  }) => ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: palette.canvas,
    colorScheme: ColorScheme.fromSeed(
      seedColor: LeoneBrandColors.interactive,
      brightness: brightness,
      surface: palette.surface,
      onSurface: palette.ink,
    ),
    extensions: [palette],
    textTheme: ThemeData(brightness: brightness).textTheme.apply(
      bodyColor: palette.ink,
      displayColor: palette.ink,
      fontFamily: LeoneBrand.fontFamily,
      fontFamilyFallback: LeoneBrand.fontFamilyFallback,
    ),
  );
}
