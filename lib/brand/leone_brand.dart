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
  static const signaturePtBr = 'Um frame. Toda tela.';
  static const signatureEn = 'One frame. Every surface.';
  static const fontFamily = 'Inter';
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
}

abstract final class LeoneBrandMotion {
  static const openingHold = Duration(milliseconds: 1000);
  static const openingTransform = Duration(milliseconds: 2100);
  static const openingTotal = Duration(milliseconds: 3100);
  static const openingHoldFraction = 1000 / 3100;
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
  static ThemeData dark() => ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: LeoneBrandColors.canvas,
    colorScheme: ColorScheme.fromSeed(
      seedColor: LeoneBrandColors.interactive,
      brightness: Brightness.dark,
      surface: LeoneBrandColors.surface,
    ),
    textTheme: ThemeData.dark().textTheme.apply(
      bodyColor: LeoneBrandColors.ink,
      displayColor: LeoneBrandColors.ink,
      fontFamily: LeoneBrand.fontFamily,
    ),
  );
}
