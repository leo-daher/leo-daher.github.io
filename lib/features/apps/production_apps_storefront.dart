import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../brand/leone_brand.dart';
import '../shared/portfolio_section_heading.dart';
import 'production_app_models.dart';
import 'production_apps_section.dart';

const _catalogWideMinWidth = 800.0;
const _catalogGap = 12.0;

/// Compact home-page presentation inspired by mobile app marketplaces.
///
/// Full case studies live behind normal Material routes so the home remains
/// easy to scan on a phone.
class ProductionAppsStorefront extends StatelessWidget {
  const ProductionAppsStorefront({
    super.key,
    required this.content,
    required this.caseContent,
    required this.items,
    required this.apps,
  }) : assert(items.length > 0),
       assert(apps.length > 0);

  final ProductionAppsStorefrontContent content;
  final ProductionAppsSectionContent caseContent;
  final List<ProductionAppStorefrontItem> items;
  final List<ProductionAppCase> apps;

  @override
  Widget build(BuildContext context) {
    return Center(
      key: const Key('production-apps-storefront'),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1240),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _StorefrontHeading(
                title: content.featuredTitle,
                supportingText: content.featuredSupportingText,
                actionLabel: content.viewAllLabel,
                onAction: () => _openCatalog(context),
              ),
              const SizedBox(height: 22),
              _AdaptiveAppTiles(
                key: const Key('featured-apps-list'),
                items: items,
                openDetailsLabel: content.openDetailsLabel,
                onOpen: (item) => _openDetails(context, item),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openCatalog(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ProductionAppsCatalogPage(
          content: content,
          caseContent: caseContent,
          items: items,
          apps: apps,
        ),
      ),
    );
  }

  void _openDetails(BuildContext context, ProductionAppStorefrontItem item) {
    final app = apps.singleWhere((app) => app.id == item.appCaseId);
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ProductionAppDetailPage(content: caseContent, app: app),
      ),
    );
  }
}

class ProductionAppsCatalogPage extends StatelessWidget {
  const ProductionAppsCatalogPage({
    super.key,
    required this.content,
    required this.caseContent,
    required this.items,
    required this.apps,
  });

  final ProductionAppsStorefrontContent content;
  final ProductionAppsSectionContent caseContent;
  final List<ProductionAppStorefrontItem> items;
  final List<ProductionAppCase> apps;

  @override
  Widget build(BuildContext context) {
    final palette = context.leonePalette;
    return Scaffold(
      body: SelectionArea(
        child: CustomScrollView(
          key: const Key('all-apps-scroll-view'),
          slivers: [
            _StorePageAppBar(title: content.allAppsTitle),
            SliverToBoxAdapter(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1240),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 32, 24, 14),
                    child: Text(
                      content.allAppsSupportingText,
                      style: TextStyle(
                        color: palette.mutedInk,
                        fontSize: 15,
                        height: 1.55,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1240),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 8, 24, 72),
                    child: _AdaptiveAppTiles(
                      key: const Key('all-apps-list'),
                      items: items,
                      openDetailsLabel: content.openDetailsLabel,
                      onOpen: (item) {
                        final app = apps.singleWhere(
                          (app) => app.id == item.appCaseId,
                        );
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => ProductionAppDetailPage(
                              content: caseContent,
                              app: app,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductionAppDetailPage extends StatelessWidget {
  const ProductionAppDetailPage({
    super.key,
    required this.content,
    required this.app,
  });

  final ProductionAppsSectionContent content;
  final ProductionAppCase app;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SelectionArea(
        child: CustomScrollView(
          key: Key('app-detail-scroll-view-${app.id}'),
          slivers: [
            _StorePageAppBar(title: app.name),
            SliverToBoxAdapter(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1240),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 12, 24, 72),
                    child: ProductionAppCaseCard(
                      app: app,
                      content: content,
                      accent: app.accent ?? LeoneBrandColors.interactive,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StorePageAppBar extends StatelessWidget {
  const _StorePageAppBar({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final palette = context.leonePalette;
    return SliverAppBar(
      key: const Key('store-page-app-bar'),
      pinned: true,
      elevation: 0,
      scrolledUnderElevation: 3,
      shadowColor: Colors.black.withValues(alpha: .32),
      surfaceTintColor: Colors.transparent,
      backgroundColor: palette.canvas,
      foregroundColor: palette.ink,
      title: Text(
        title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
      ),
    );
  }
}

class _StorefrontHeading extends StatelessWidget {
  const _StorefrontHeading({
    required this.title,
    required this.supportingText,
    required this.actionLabel,
    required this.onAction,
  });

  final String title;
  final String supportingText;
  final String actionLabel;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    final palette = context.leonePalette;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(child: PortfolioSectionHeading(title: title)),
            const SizedBox(width: 12),
            TextButton.icon(
              key: const Key('view-all-apps-button'),
              onPressed: onAction,
              iconAlignment: IconAlignment.end,
              icon: const Icon(Icons.arrow_forward_rounded, size: 18),
              label: Text(actionLabel),
              style: TextButton.styleFrom(
                foregroundColor: LeoneBrandColors.interactive,
                minimumSize: const Size(48, 48),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 620),
          child: Text(
            supportingText,
            style: TextStyle(
              color: palette.mutedInk,
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}

class _AdaptiveAppTiles extends StatelessWidget {
  const _AdaptiveAppTiles({
    super.key,
    required this.items,
    required this.openDetailsLabel,
    required this.onOpen,
  });

  final List<ProductionAppStorefrontItem> items;
  final String openDetailsLabel;
  final ValueChanged<ProductionAppStorefrontItem> onOpen;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth >= _catalogWideMinWidth;
        if (!wide) {
          return Column(
            children: [
              for (var index = 0; index < items.length; index++) ...[
                _AppStoreTile(
                  item: items[index],
                  openDetailsLabel: openDetailsLabel,
                  wide: false,
                  onTap: () => onOpen(items[index]),
                ),
                if (index != items.length - 1)
                  Divider(height: 1, color: context.leonePalette.outline),
              ],
            ],
          );
        }

        final columns = math.min(2, items.length);
        final tileWidth =
            (constraints.maxWidth - _catalogGap * (columns - 1)) / columns;
        return Wrap(
          spacing: _catalogGap,
          runSpacing: _catalogGap,
          children: [
            for (final item in items)
              SizedBox(
                width: tileWidth,
                child: _AppStoreTile(
                  item: item,
                  openDetailsLabel: openDetailsLabel,
                  wide: true,
                  onTap: () => onOpen(item),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _AppStoreTile extends StatelessWidget {
  const _AppStoreTile({
    required this.item,
    required this.openDetailsLabel,
    required this.wide,
    required this.onTap,
  });

  final ProductionAppStorefrontItem item;
  final String openDetailsLabel;
  final bool wide;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.leonePalette;
    final accent = item.accent ?? LeoneBrandColors.interactive;

    return Semantics(
      button: true,
      label: '$openDetailsLabel: ${item.name}',
      child: Material(
        key: Key('app-store-tile-${item.id}'),
        color: wide
            ? palette.surfaceRaised.withValues(alpha: .58)
            : Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: wide ? BorderSide(color: palette.outline) : BorderSide.none,
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: wide ? 18 : 0,
              vertical: wide ? 20 : 16,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _CatalogAppIcon(item: item, size: wide ? 76 : 68),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: palette.ink,
                          fontSize: wide ? 17 : 16,
                          height: 1.2,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        item.summary,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: palette.mutedInk,
                          fontSize: 12.5,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        item.metric,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: accent,
                          fontSize: 11,
                          height: 1.25,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.chevron_right_rounded,
                  color: palette.mutedInk,
                  size: 22,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CatalogAppIcon extends StatelessWidget {
  const _CatalogAppIcon({required this.item, required this.size});

  final ProductionAppStorefrontItem item;
  final double size;

  @override
  Widget build(BuildContext context) {
    final paths = item.iconAssetPaths.take(2).toList(growable: false);
    if (paths.isEmpty) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: (item.accent ?? LeoneBrandColors.interactive).withValues(
            alpha: .14,
          ),
          borderRadius: BorderRadius.circular(size * .24),
        ),
        child: Icon(
          Icons.apps_rounded,
          color: item.accent ?? LeoneBrandColors.interactive,
        ),
      );
    }

    final childSize = paths.length == 1 ? size : size * .78;
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        children: [
          for (var index = 0; index < paths.length; index++)
            Positioned(
              left: index == 0 ? 0 : size - childSize,
              top: index == 0 ? 0 : size - childSize,
              child: Container(
                width: childSize,
                height: childSize,
                padding: const EdgeInsets.all(1.5),
                decoration: BoxDecoration(
                  color: context.leonePalette.surface,
                  borderRadius: BorderRadius.circular(childSize * .24),
                  border: Border.all(color: context.leonePalette.outline),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(childSize * .21),
                  child: Image.asset(paths[index], fit: BoxFit.cover),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
