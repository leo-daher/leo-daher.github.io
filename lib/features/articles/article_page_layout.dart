import 'dart:ui' show SemanticsRole;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../brand/leone_brand.dart';
import '../../l10n/l10n.dart';
import 'article_catalog.dart';

class ArticlePageLayout extends StatefulWidget {
  const ArticlePageLayout({
    super.key,
    required this.pageKey,
    required this.currentArticle,
    required this.articles,
    required this.article,
  });

  final Key pageKey;
  final ArticleEntry currentArticle;
  final List<ArticleEntry> articles;
  final Widget article;

  @override
  State<ArticlePageLayout> createState() => _ArticlePageLayoutState();
}

class _ArticlePageLayoutState extends State<ArticlePageLayout> {
  final TrackingScrollController _articleScrollController =
      TrackingScrollController();

  @override
  void dispose() {
    _articleScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.leonePalette;
    return Scaffold(
      key: widget.pageKey,
      appBar: AppBar(
        backgroundColor: palette.canvas,
        surfaceTintColor: Colors.transparent,
      ),
      body: SafeArea(
        top: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth >= 1200) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1240),
                    child: SizedBox(
                      width: double.infinity,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: SelectionArea(
                              child: SingleChildScrollView(
                                key: const Key('article-main-scroll'),
                                controller: _articleScrollController,
                                padding: const EdgeInsets.fromLTRB(
                                  0,
                                  32,
                                  0,
                                  72,
                                ),
                                child: widget.article,
                              ),
                            ),
                          ),
                          const SizedBox(width: 32),
                          SizedBox(
                            key: const Key('article-navigation-sidebar'),
                            width: 288,
                            height: constraints.maxHeight,
                            child: SingleChildScrollView(
                              padding: const EdgeInsets.fromLTRB(0, 32, 0, 72),
                              child: ArticleQuickNavigation(
                                entries: widget.articles,
                                currentArticleId: widget.currentArticle.id,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }

            return SingleChildScrollView(
              key: const Key('article-main-scroll'),
              controller: _articleScrollController,
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 72),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 920),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SelectionArea(child: widget.article),
                      const SizedBox(height: 64),
                      Divider(color: palette.outline),
                      const SizedBox(height: 28),
                      ArticleQuickNavigation(
                        key: const Key('article-navigation-inline'),
                        entries: widget.articles,
                        currentArticleId: widget.currentArticle.id,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class ArticleQuickNavigation extends StatelessWidget {
  const ArticleQuickNavigation({
    super.key,
    required this.entries,
    required this.currentArticleId,
  });

  final List<ArticleEntry> entries;
  final String currentArticleId;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      explicitChildNodes: true,
      label: context.l10n.articleNavigationSemantics,
      role: SemanticsRole.navigation,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Semantics(
            header: true,
            child: Text(
              context.l10n.articlesPageTitle,
              style: const TextStyle(
                fontSize: 18,
                height: 1.2,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(height: 14),
          LayoutBuilder(
            builder: (context, constraints) {
              final useGrid = entries.length > 1 && constraints.maxWidth >= 720;
              if (useGrid) {
                final itemWidth = (constraints.maxWidth - 16) / 2;
                return Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    for (final entry in entries)
                      SizedBox(
                        width: itemWidth,
                        child: _ArticleNavigationCard(
                          entry: entry,
                          selected: entry.id == currentArticleId,
                        ),
                      ),
                  ],
                );
              }
              return Column(
                children: [
                  for (var index = 0; index < entries.length; index++) ...[
                    if (index > 0) const SizedBox(height: 12),
                    _ArticleNavigationCard(
                      entry: entries[index],
                      selected: entries[index].id == currentArticleId,
                    ),
                  ],
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ArticleNavigationCard extends StatelessWidget {
  const _ArticleNavigationCard({required this.entry, required this.selected});

  final ArticleEntry entry;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final palette = context.leonePalette;
    final thumbnailAsset = Theme.of(context).brightness == Brightness.dark
        ? entry.darkThumbnailAsset
        : entry.lightThumbnailAsset;
    final semanticLabel = selected
        ? context.l10n.currentArticle(entry.title, entry.summary)
        : context.l10n.openArticle(entry.title, entry.summary);
    final onTap = selected
        ? null
        : () => Navigator.of(context).pushNamed(entry.routeName);

    return Semantics(
      container: true,
      selected: selected,
      button: !selected,
      label: semanticLabel,
      onTap: onTap,
      child: ExcludeSemantics(
        child: Material(
          key: Key('article-navigation-${entry.id}'),
          color: selected
              ? LeoneBrandColors.interactive.withValues(alpha: .10)
              : palette.surface.withValues(alpha: .72),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
            side: BorderSide(
              color: selected
                  ? LeoneBrandColors.interactive.withValues(alpha: .52)
                  : palette.outline,
            ),
          ),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    key: Key('article-navigation-thumbnail-${entry.id}'),
                    width: 88,
                    height: 72,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: palette.surfaceRaised,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: SvgPicture.asset(
                      thumbnailAsset,
                      excludeFromSemantics: true,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          entry.title,
                          key: Key('article-navigation-title-${entry.id}'),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 15,
                            height: 1.25,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          entry.summary,
                          key: Key('article-navigation-summary-${entry.id}'),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: palette.mutedInk,
                            fontSize: 12,
                            height: 1.35,
                          ),
                        ),
                      ],
                    ),
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
