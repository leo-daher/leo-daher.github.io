import 'package:flutter/material.dart';
import 'package:url_launcher/link.dart';

import '../../brand/leone_brand.dart';
import '../shared/portfolio_section_heading.dart';
import 'production_app_models.dart';

const _mediumLayoutMinWidth = 700.0;
const _cardGap = 16.0;
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
    this.maxWidth = 1240,
    this.horizontalPadding = 24,
  }) : assert(apps.length > 0);

  final ProductionAppsSectionContent content;
  final List<ProductionAppCase> apps;
  final double maxWidth;
  final double horizontalPadding;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      explicitChildNodes: true,
      label: content.semanticLabel,
      child: Center(
        key: const Key('production-apps-section'),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Semantics(
                  header: true,
                  child: PortfolioSectionHeading(
                    eyebrow: content.eyebrow,
                    title: content.title,
                    copy: content.description,
                  ),
                ),
                const SizedBox(height: 30),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final splitLayout =
                        constraints.maxWidth >= _mediumLayoutMinWidth &&
                        apps.length > 1;
                    if (splitLayout) {
                      final secondaryWidth =
                          (constraints.maxWidth - _cardGap) / 2;
                      return Column(
                        key: const Key('production-apps-grid'),
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ProductionAppCaseCard(
                            app: apps.first,
                            content: content,
                            featured: true,
                            accent: apps.first.accent ?? _caseAccents.first,
                          ),
                          const SizedBox(height: _cardGap),
                          Wrap(
                            spacing: _cardGap,
                            runSpacing: _cardGap,
                            children: [
                              for (var index = 1; index < apps.length; index++)
                                SizedBox(
                                  width: secondaryWidth,
                                  child: ProductionAppCaseCard(
                                    app: apps[index],
                                    content: content,
                                    accent:
                                        apps[index].accent ??
                                        _caseAccents[index %
                                            _caseAccents.length],
                                  ),
                                ),
                            ],
                          ),
                        ],
                      );
                    }

                    return Column(
                      key: const Key('production-apps-grid'),
                      children: [
                        for (var index = 0; index < apps.length; index++)
                          Padding(
                            padding: EdgeInsets.only(
                              bottom: index == apps.length - 1 ? 0 : _cardGap,
                            ),
                            child: SizedBox(
                              width: constraints.maxWidth,
                              child: ProductionAppCaseCard(
                                app: apps[index],
                                content: content,
                                accent:
                                    apps[index].accent ??
                                    _caseAccents[index % _caseAccents.length],
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Material 3 case card used by [ProductionAppsSection].
class ProductionAppCaseCard extends StatelessWidget {
  const ProductionAppCaseCard({
    super.key,
    required this.app,
    required this.content,
    this.accent = LeoneBrandColors.interactive,
    this.featured = false,
  });

  final ProductionAppCase app;
  final ProductionAppsSectionContent content;
  final Color accent;
  final bool featured;

  @override
  Widget build(BuildContext context) {
    final palette = context.leonePalette;
    return Semantics(
      container: true,
      explicitChildNodes: true,
      label: app.semanticLabel,
      child: Card(
        key: Key('production-app-card-${app.id}'),
        margin: EdgeInsets.zero,
        color: palette.surface.withValues(alpha: .88),
        surfaceTintColor: Colors.transparent,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
          side: BorderSide(color: palette.outline),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (app.screenshots.isNotEmpty)
              _ScreenshotGallery(
                appId: app.id,
                screenshots: app.screenshots,
                label: content.screenshotsLabel,
                imageUnavailableLabel: content.imageUnavailableLabel,
                accent: accent,
                featured: featured,
              ),
            Padding(
              padding: const EdgeInsets.fromLTRB(22, 22, 22, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _CaseHeading(app: app, accent: accent),
                  const SizedBox(height: 18),
                  _CaseFact(label: content.roleLabel, value: app.role),
                  const SizedBox(height: 16),
                  _CaseFact(
                    label: content.contributionLabel,
                    value: app.contribution,
                  ),
                  const SizedBox(height: 18),
                  _StackTags(
                    label: content.stackLabel,
                    technologies: app.stack,
                    accent: accent,
                  ),
                  if (app.storeProof.isNotEmpty) ...[
                    const SizedBox(height: 22),
                    _StoreProofList(
                      appId: app.id,
                      label: content.storeProofLabel,
                      proof: app.storeProof,
                      accent: accent,
                    ),
                  ],
                  if (app.links.isNotEmpty) ...[
                    const SizedBox(height: 22),
                    _CaseLinks(appId: app.id, links: app.links),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
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
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.1,
                ),
              ),
              const SizedBox(height: 8),
              Semantics(
                header: true,
                child: Text(
                  app.name,
                  style: TextStyle(
                    color: palette.ink,
                    fontSize: 24,
                    height: 1.08,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -.5,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                app.summary,
                style: TextStyle(color: palette.mutedInk, height: 1.5),
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
      width: paths.length == 1 ? 50 : 66,
      height: 50,
      child: Stack(
        children: [
          for (var index = 0; index < paths.length; index++)
            Positioned(
              left: index * 16,
              child: Container(
                width: 50,
                height: 50,
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: context.leonePalette.canvas,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: accent.withValues(alpha: .36)),
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

class _CaseFact extends StatelessWidget {
  const _CaseFact({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final palette = context.leonePalette;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: TextStyle(
            color: palette.mutedInk,
            fontSize: 11,
            fontWeight: FontWeight.w800,
            letterSpacing: .9,
          ),
        ),
        const SizedBox(height: 6),
        Text(value, style: TextStyle(color: palette.ink, height: 1.45)),
      ],
    );
  }
}

class _StackTags extends StatelessWidget {
  const _StackTags({
    required this.label,
    required this.technologies,
    required this.accent,
  });

  final String label;
  final List<String> technologies;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final palette = context.leonePalette;
    return Semantics(
      label: '$label: ${technologies.join(', ')}',
      child: ExcludeSemantics(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label.toUpperCase(),
              style: TextStyle(
                color: palette.mutedInk,
                fontSize: 11,
                fontWeight: FontWeight.w800,
                letterSpacing: .9,
              ),
            ),
            const SizedBox(height: 9),
            Wrap(
              spacing: 7,
              runSpacing: 7,
              children: [
                for (final technology in technologies)
                  Chip(
                    label: Text(technology),
                    visualDensity: VisualDensity.compact,
                    side: BorderSide(color: accent.withValues(alpha: .26)),
                    backgroundColor: accent.withValues(alpha: .1),
                    labelStyle: TextStyle(
                      color: palette.ink,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
              ],
            ),
          ],
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
    required this.featured,
  });

  final String appId;
  final List<ProductionAppScreenshot> screenshots;
  final String label;
  final String imageUnavailableLabel;
  final Color accent;
  final bool featured;

  @override
  Widget build(BuildContext context) {
    final palette = context.leonePalette;
    return Semantics(
      container: true,
      explicitChildNodes: true,
      label: label,
      child: Container(
        key: Key('production-app-screenshots-$appId'),
        height: featured ? 378 : 248,
        decoration: BoxDecoration(
          color: accent.withValues(alpha: .055),
          border: Border(bottom: BorderSide(color: palette.outline)),
        ),
        child: featured
            ? Padding(
                padding: const EdgeInsets.all(16),
                child: Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (
                        var index = 0;
                        index < screenshots.length;
                        index++
                      ) ...[
                        if (index > 0) const SizedBox(width: 12),
                        _ScreenshotFrame(
                          screenshot: screenshots[index],
                          imageUnavailableLabel: imageUnavailableLabel,
                          accent: accent,
                          featured: true,
                        ),
                      ],
                    ],
                  ),
                ),
              )
            : ListView.separated(
                padding: const EdgeInsets.all(16),
                scrollDirection: Axis.horizontal,
                itemCount: screenshots.length,
                separatorBuilder: (_, _) => const SizedBox(width: 12),
                itemBuilder: (context, index) => _ScreenshotFrame(
                  screenshot: screenshots[index],
                  imageUnavailableLabel: imageUnavailableLabel,
                  accent: accent,
                  featured: false,
                ),
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
    required this.featured,
  });

  final ProductionAppScreenshot screenshot;
  final String imageUnavailableLabel;
  final Color accent;
  final bool featured;

  @override
  Widget build(BuildContext context) {
    final palette = context.leonePalette;
    return SizedBox(
      width: featured ? 188 : 112,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Semantics(
              image: true,
              label: screenshot.semanticLabel,
              child: ExcludeSemantics(
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: palette.canvas,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: accent.withValues(alpha: .42)),
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
            const SizedBox(height: 8),
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

class _StoreProofList extends StatelessWidget {
  const _StoreProofList({
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
    final palette = context.leonePalette;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: TextStyle(
            color: palette.mutedInk,
            fontSize: 11,
            fontWeight: FontWeight.w800,
            letterSpacing: .9,
          ),
        ),
        const SizedBox(height: 9),
        for (var index = 0; index < proof.length; index++) ...[
          _StoreProofTile(
            key: Key('production-app-store-proof-$appId-$index'),
            proof: proof[index],
            accent: accent,
          ),
          if (index < proof.length - 1) const SizedBox(height: 8),
        ],
      ],
    );
  }
}

class _StoreProofTile extends StatelessWidget {
  const _StoreProofTile({super.key, required this.proof, required this.accent});

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
      child: ExcludeSemantics(
        child: Material(
          color: accent.withValues(alpha: .08),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: accent.withValues(alpha: .22)),
          ),
          clipBehavior: Clip.antiAlias,
          child: ListTile(
            onTap: onTap,
            minTileHeight: 64,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 4,
            ),
            leading: Icon(Icons.verified_outlined, color: accent),
            title: Text(
              proof.evidence,
              style: TextStyle(color: palette.ink, fontWeight: FontWeight.w800),
            ),
            subtitle: Text(
              [proof.storeName, ?proof.supportingText].join(' · '),
              style: TextStyle(color: palette.mutedInk),
            ),
            trailing: onTap == null
                ? null
                : Icon(
                    Icons.arrow_outward_rounded,
                    size: 18,
                    color: palette.mutedInk,
                  ),
          ),
        ),
      ),
    );
  }
}

class _CaseLinks extends StatelessWidget {
  const _CaseLinks({required this.appId, required this.links});

  final String appId;
  final List<ProductionAppLink> links;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (var index = 0; index < links.length; index++)
          Link(
            key: Key('production-app-link-$appId-$index'),
            uri: links[index].uri,
            target: LinkTarget.blank,
            builder: (context, followLink) => Semantics(
              button: true,
              link: true,
              label: links[index].semanticLabel,
              child: Tooltip(
                message: links[index].semanticLabel,
                excludeFromSemantics: true,
                child: links[index].emphasized
                    ? FilledButton.tonalIcon(
                        onPressed: followLink,
                        icon: Icon(links[index].icon, size: 18),
                        label: Text(links[index].label),
                      )
                    : OutlinedButton.icon(
                        onPressed: followLink,
                        icon: Icon(links[index].icon, size: 18),
                        label: Text(links[index].label),
                      ),
              ),
            ),
          ),
      ],
    );
  }
}
