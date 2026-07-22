import 'package:flutter/material.dart';

/// Localized copy used by the production-apps section.
///
/// Keeping every visitor-facing label in this model lets the feature remain
/// independent from a specific localization implementation.
@immutable
class ProductionAppsSectionContent {
  const ProductionAppsSectionContent({
    required this.semanticLabel,
    required this.eyebrow,
    required this.title,
    required this.description,
    required this.roleLabel,
    required this.contributionLabel,
    required this.stackLabel,
    required this.storeProofLabel,
    required this.screenshotsLabel,
    required this.imageUnavailableLabel,
  });

  final String semanticLabel;
  final String eyebrow;
  final String title;
  final String description;
  final String roleLabel;
  final String contributionLabel;
  final String stackLabel;
  final String storeProofLabel;
  final String screenshotsLabel;
  final String imageUnavailableLabel;
}

/// A production app or client product to present as a compact case study.
@immutable
class ProductionAppCase {
  const ProductionAppCase({
    required this.id,
    required this.semanticLabel,
    required this.name,
    required this.contextLabel,
    required this.summary,
    required this.role,
    required this.contribution,
    required this.stack,
    this.iconAssetPaths = const [],
    this.screenshots = const [],
    this.storeProof = const [],
    this.accent,
  }) : assert(id.length > 0),
       assert(name.length > 0),
       assert(stack.length > 0);

  /// Stable identifier used for keys and test selectors.
  final String id;

  /// Complete assistive description for the case container.
  final String semanticLabel;

  final String name;
  final String contextLabel;
  final String summary;
  final String role;
  final String contribution;
  final List<String> stack;
  final List<String> iconAssetPaths;
  final List<ProductionAppScreenshot> screenshots;
  final List<ProductionAppStoreProof> storeProof;

  /// Optional project color. It is contained inside the case and never changes
  /// the portfolio's primary brand mark.
  final Color? accent;
}

/// Screenshot metadata. The caller owns the asset declaration and copy.
@immutable
class ProductionAppScreenshot {
  const ProductionAppScreenshot({
    required this.assetPath,
    required this.semanticLabel,
    this.caption,
    this.alignment = Alignment.topCenter,
  }) : assert(assetPath.length > 0),
       assert(semanticLabel.length > 0);

  final String assetPath;
  final String semanticLabel;
  final String? caption;
  final Alignment alignment;
}

/// Verifiable evidence from an app marketplace or another public store page.
///
/// [evidence] is intentionally already formatted by the caller so ratings,
/// review counts and dates can follow the active locale and source wording.
@immutable
class ProductionAppStoreProof {
  const ProductionAppStoreProof({
    required this.storeName,
    required this.evidence,
    required this.semanticLabel,
    this.supportingText,
    this.uri,
  });

  final String storeName;
  final String evidence;
  final String semanticLabel;
  final String? supportingText;
  final Uri? uri;
}
