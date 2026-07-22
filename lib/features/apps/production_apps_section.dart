import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:url_launcher/link.dart';

import '../../brand/leone_brand.dart';
import '../shared/portfolio_section_heading.dart';
import 'production_app_models.dart';

const _wideCaseMinWidth = 960.0;
const _caseGap = 48.0;
const _screenshotGap = 12.0;
const _caseAccents = <Color>[
  LeoneBrandColors.interactive,
  LeoneBrandColors.intelligence,
  LeoneBrandColors.editorialWarm,
];

/// Responsive, localized presentation of apps in which Leone participated.
///
/// The section owns layout and interaction only. Every claim, label, asset and
/// external destination is supplied through [content] and [apps].
class ProductionAppsSection extends StatelessWidget {
  const ProductionAppsSection({
    super.key,
    required this.content,
    required this.apps,
    this.maxWidth = 1440,
    this.horizontalPadding = 24,
  }) : assert(apps.length > 0);

  final ProductionAppsSectionContent content;
  final List<ProductionAppCase> apps;
  final double maxWidth;
  final double horizontalPadding;

  @override
  Widget build(BuildContext context) {
    final palette = context.leonePalette;
    return Semantics(
      container: true,
      explicitChildNodes: true,
      label: content.semanticLabel,
      child: Center(
        key: const Key('production-apps-section'),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: SizedBox(
            width: double.infinity,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1192),
                      child: SizedBox(
                        width: double.infinity,
                        child: Semantics(
                          header: true,
                          child: PortfolioSectionHeading(
                            eyebrow: content.eyebrow,
                            title: content.title,
                            copy: content.description,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 36),
                  Column(
                    key: const Key('production-apps-grid'),
                    children: [
                      for (var index = 0; index < apps.length; index++) ...[
                        Divider(height: 1, color: palette.outline),
                        ProductionAppCaseCard(
                          app: apps[index],
                          content: content,
                          accent:
                              apps[index].accent ??
                              _caseAccents[index % _caseAccents.length],
                        ),
                      ],
                      Divider(height: 1, color: palette.outline),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Editorial case row used by [ProductionAppsSection].
class ProductionAppCaseCard extends StatelessWidget {
  const ProductionAppCaseCard({
    super.key,
    required this.app,
    required this.content,
    this.accent = LeoneBrandColors.interactive,
  });

  final ProductionAppCase app;
  final ProductionAppsSectionContent content;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      explicitChildNodes: true,
      label: app.semanticLabel,
      child: Container(
        key: Key('production-app-card-${app.id}'),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 38),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final wide = constraints.maxWidth >= _wideCaseMinWidth;
            final gallery = _ScreenshotGallery(
              appId: app.id,
              screenshots: app.screenshots,
              label: content.screenshotsLabel,
              imageUnavailableLabel: content.imageUnavailableLabel,
              accent: accent,
              compact: !wide,
            );
            final caseCopy = _CaseCopy(
              app: app,
              content: content,
              accent: accent,
            );

            if (!wide) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (app.screenshots.isNotEmpty) gallery,
                  if (app.screenshots.isNotEmpty) const SizedBox(height: 26),
                  caseCopy,
                ],
              );
            }

            return Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (app.screenshots.isNotEmpty) ...[
                  Expanded(flex: 7, child: gallery),
                  const SizedBox(width: _caseGap),
                ],
                Expanded(flex: 5, child: caseCopy),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _CaseCopy extends StatelessWidget {
  const _CaseCopy({
    required this.app,
    required this.content,
    required this.accent,
  });

  final ProductionAppCase app;
  final ProductionAppsSectionContent content;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final palette = context.leonePalette;
    return Column(
      key: Key('production-app-content-${app.id}'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _CaseHeading(app: app, accent: accent),
        const SizedBox(height: 18),
        Semantics(
          label: '${content.roleLabel}: ${app.role}',
          child: ExcludeSemantics(
            child: Text(
              app.role,
              style: TextStyle(
                color: accent,
                fontSize: 13,
                height: 1.4,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        const SizedBox(height: 9),
        Semantics(
          label: '${content.contributionLabel}: ${app.contribution}',
          child: ExcludeSemantics(
            child: Text(
              app.contribution,
              style: TextStyle(color: palette.ink, height: 1.5),
            ),
          ),
        ),
        const SizedBox(height: 16),
        _StackLine(label: content.stackLabel, technologies: app.stack),
        if (app.storeProof.isNotEmpty) ...[
          const SizedBox(height: 18),
          _StoreProofWrap(
            appId: app.id,
            label: content.storeProofLabel,
            proof: app.storeProof,
            accent: accent,
          ),
        ],
      ],
    );
  }
}

class _CaseHeading extends StatelessWidget {
  const _CaseHeading({required this.app, required this.accent});

  final ProductionAppCase app;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final palette = context.leonePalette;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (app.iconAssetPaths.isNotEmpty) ...[
          _AppIcons(assetPaths: app.iconAssetPaths, accent: accent),
          const SizedBox(width: 14),
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                app.contextLabel.toUpperCase(),
                style: TextStyle(
                  color: accent,
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.05,
                ),
              ),
              const SizedBox(height: 7),
              Semantics(
                header: true,
                child: Text(
                  app.name,
                  style: TextStyle(
                    color: palette.ink,
                    fontSize: 25,
                    height: 1.08,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -.55,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                app.summary,
                style: TextStyle(color: palette.mutedInk, height: 1.45),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _AppIcons extends StatelessWidget {
  const _AppIcons({required this.assetPaths, required this.accent});

  final List<String> assetPaths;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final paths = assetPaths.take(2).toList(growable: false);
    return SizedBox(
      width: paths.length == 1 ? 48 : 64,
      height: 48,
      child: Stack(
        children: [
          for (var index = 0; index < paths.length; index++)
            Positioned(
              left: index * 16,
              child: Container(
                width: 48,
                height: 48,
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: context.leonePalette.canvas,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: accent.withValues(alpha: .16),
                      blurRadius: 18,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(11),
                  child: Image.asset(paths[index], fit: BoxFit.cover),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _StackLine extends StatelessWidget {
  const _StackLine({required this.label, required this.technologies});

  final String label;
  final List<String> technologies;

  @override
  Widget build(BuildContext context) {
    final palette = context.leonePalette;
    return Semantics(
      label: '$label: ${technologies.join(', ')}',
      child: ExcludeSemantics(
        child: Text(
          technologies.join('  ·  '),
          style: TextStyle(
            color: palette.mutedInk,
            fontSize: 12,
            height: 1.55,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _ScreenshotGallery extends StatelessWidget {
  const _ScreenshotGallery({
    required this.appId,
    required this.screenshots,
    required this.label,
    required this.imageUnavailableLabel,
    required this.accent,
    required this.compact,
  });

  final String appId;
  final List<ProductionAppScreenshot> screenshots;
  final String label;
  final String imageUnavailableLabel;
  final Color accent;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final height = compact ? 258.0 : 360.0;
    final hasCaptions = screenshots.any(
      (screenshot) => screenshot.caption != null,
    );
    return Semantics(
      container: true,
      explicitChildNodes: true,
      label: label,
      child: Container(
        key: Key('production-app-screenshots-$appId'),
        height: height,
        decoration: BoxDecoration(
          color: accent.withValues(alpha: .045),
          borderRadius: BorderRadius.circular(compact ? 22 : 28),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final captionSpace = hasCaptions ? 28.0 : 0.0;
            final maxByHeight = (height - 32 - captionSpace) * (9 / 16);
            final availableWidth =
                constraints.maxWidth -
                32 -
                _screenshotGap * (screenshots.length - 1);
            final fitWidth = availableWidth / screenshots.length;
            final frameWidth = math.max(
              compact ? 108.0 : 116.0,
              math.min(maxByHeight, fitWidth),
            );
            final contentWidth =
                frameWidth * screenshots.length +
                _screenshotGap * (screenshots.length - 1);
            final horizontalPadding = math.max(
              16.0,
              (constraints.maxWidth - contentWidth) / 2,
            );

            return ListView.separated(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: 16,
              ),
              scrollDirection: Axis.horizontal,
              itemCount: screenshots.length,
              separatorBuilder: (_, _) => const SizedBox(width: _screenshotGap),
              itemBuilder: (context, index) => _ScreenshotFrame(
                screenshot: screenshots[index],
                imageUnavailableLabel: imageUnavailableLabel,
                accent: accent,
                width: frameWidth,
              ),
            );
          },
        ),
      ),
    );
  }
}

class _ScreenshotFrame extends StatelessWidget {
  const _ScreenshotFrame({
    required this.screenshot,
    required this.imageUnavailableLabel,
    required this.accent,
    required this.width,
  });

  final ProductionAppScreenshot screenshot;
  final String imageUnavailableLabel;
  final Color accent;
  final double width;

  @override
  Widget build(BuildContext context) {
    final palette = context.leonePalette;
    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 9 / 16,
            child: Semantics(
              image: true,
              label: screenshot.semanticLabel,
              child: ExcludeSemantics(
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: palette.canvas,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: accent.withValues(alpha: .34)),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.asset(
                      screenshot.assetPath,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                      alignment: screenshot.alignment,
                      cacheWidth: 360,
                      errorBuilder: (context, _, _) => ColoredBox(
                        color: palette.surfaceRaised,
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.image_not_supported_outlined,
                                  color: palette.mutedInk,
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  imageUnavailableLabel,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: palette.mutedInk,
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (screenshot.caption case final caption?) ...[
            const SizedBox(height: 7),
            Text(
              caption,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: palette.mutedInk, fontSize: 11),
            ),
          ],
        ],
      ),
    );
  }
}

class _StoreProofWrap extends StatelessWidget {
  const _StoreProofWrap({
    required this.appId,
    required this.label,
    required this.proof,
    required this.accent,
  });

  final String appId;
  final String label;
  final List<ProductionAppStoreProof> proof;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      explicitChildNodes: true,
      label: label,
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          for (var index = 0; index < proof.length; index++)
            _StoreProofChip(
              key: Key('production-app-store-proof-$appId-$index'),
              proof: proof[index],
              accent: accent,
            ),
        ],
      ),
    );
  }
}

class _StoreProofChip extends StatelessWidget {
  const _StoreProofChip({super.key, required this.proof, required this.accent});

  final ProductionAppStoreProof proof;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final uri = proof.uri;
    if (uri == null) return _surface(context, null);
    return Link(
      uri: uri,
      target: LinkTarget.blank,
      builder: (context, followLink) => _surface(context, followLink),
    );
  }

  Widget _surface(BuildContext context, VoidCallback? onTap) {
    final palette = context.leonePalette;
    return Semantics(
      button: onTap != null,
      link: onTap != null,
      label: proof.semanticLabel,
      child: Tooltip(
        message: proof.supportingText ?? proof.semanticLabel,
        excludeFromSemantics: true,
        child: Material(
          color: accent.withValues(alpha: .09),
          shape: const StadiumBorder(),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap,
            child: ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 48),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 9,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.verified_outlined, color: accent, size: 16),
                    const SizedBox(width: 7),
                    Flexible(
                      child: Text(
                        '${proof.storeName} · ${proof.evidence}',
                        style: TextStyle(
                          color: palette.ink,
                          fontSize: 11,
                          height: 1.25,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    if (onTap != null) ...[
                      const SizedBox(width: 7),
                      Icon(
                        Icons.arrow_outward_rounded,
                        color: palette.mutedInk,
                        size: 14,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
