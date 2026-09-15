import 'dart:ui' show SemanticsRole;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/link.dart';

import '../../brand/leone_brand.dart';
import '../../l10n/l10n.dart';
import '../navigation/portfolio_page_transition.dart';
import 'article_catalog.dart';

class ArticlePageLayout extends StatelessWidget {
  const ArticlePageLayout({
    super.key,
    required this.pageKey,
    required this.currentArticle,
    required this.articles,
    required this.article,
    this.appBar,
  });

  final Key pageKey;
  final ArticleEntry currentArticle;
  final List<ArticleEntry> articles;
  final Widget article;
  final PreferredSizeWidget? appBar;

  @override
  Widget build(BuildContext context) {
    final palette = context.leonePalette;
    final relatedArticles = articles
        .where((article) => article.id != currentArticle.id)
        .toList(growable: false);

    final routeAnimation =
        ModalRoute.of(context)?.animation ?? kAlwaysCompleteAnimation;

    return Scaffold(
      key: pageKey,
      backgroundColor: Colors.transparent,
      appBar: appBar,
      body: ClipRect(
        child: PortfolioPageTransition(
          animation: routeAnimation,
          child: ColoredBox(
            key: const Key('article-page-transition-surface'),
            color: palette.canvas,
            child: SafeArea(
              top: false,
              child: SingleChildScrollView(
                key: const Key('article-main-scroll'),
                padding: const EdgeInsets.fromLTRB(24, 32, 24, 72),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 920),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SelectionArea(child: article),
                        if (relatedArticles.isNotEmpty) ...[
                          const SizedBox(height: 64),
                          Divider(
                            key: const Key('related-articles-divider'),
                            color: palette.outline,
                          ),
                          const SizedBox(height: 24),
                          RelatedArticlesNavigation(
                            key: const Key('related-articles-section'),
                            entries: relatedArticles,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class RelatedArticlesNavigation extends StatelessWidget {
  const RelatedArticlesNavigation({super.key, required this.entries});

  final List<ArticleEntry> entries;

  @override
  Widget build(BuildContext context) {
    final palette = context.leonePalette;
    return Semantics(
      container: true,
      explicitChildNodes: true,
      label: context.l10n.relatedArticlesSemantics,
      role: SemanticsRole.navigation,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Semantics(
            header: true,
            child: Text(
              context.l10n.relatedArticlesTitle,
              key: const Key('related-articles-heading'),
              style: TextStyle(
                color: palette.mutedInk,
                fontSize: 14,
                height: 1.2,
                fontWeight: FontWeight.w700,
                letterSpacing: .2,
              ),
            ),
          ),
          const SizedBox(height: 12),
          LayoutBuilder(
            builder: (context, constraints) {
              final useGrid = constraints.maxWidth >= 720;
              if (useGrid) {
                final itemWidth = (constraints.maxWidth - 16) / 2;
                return Wrap(
                  spacing: 16,
                  runSpacing: 12,
                  children: [
                    for (final entry in entries)
                      SizedBox(
                        width: itemWidth,
                        child: _RelatedArticleCard(entry: entry),
                      ),
                  ],
                );
              }
              return Column(
                children: [
                  for (var index = 0; index < entries.length; index++) ...[
                    if (index > 0) const SizedBox(height: 8),
                    _RelatedArticleCard(entry: entries[index]),
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

class _RelatedArticleCard extends StatelessWidget {
  const _RelatedArticleCard({required this.entry});

  final ArticleEntry entry;

  @override
  Widget build(BuildContext context) {
    final palette = context.leonePalette;
    final thumbnailAsset = Theme.of(context).brightness == Brightness.dark
        ? entry.darkThumbnailAsset
        : entry.lightThumbnailAsset;
    final semanticLabel = context.l10n.openArticle(entry.title, entry.summary);

    return Link(
      uri: Uri.parse(entry.routeName),
      builder: (context, followLink) => Semantics(
        container: true,
        link: true,
        label: semanticLabel,
        onTap: followLink,
        child: ExcludeSemantics(
          child: Material(
            key: Key('related-article-${entry.id}'),
            color: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: followLink,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      key: Key('related-article-thumbnail-${entry.id}'),
                      width: 72,
                      height: 56,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: palette.surfaceRaised,
                        borderRadius: BorderRadius.circular(12),
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
                            key: Key('related-article-title-${entry.id}'),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 14,
                              height: 1.25,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            entry.summary,
                            key: Key('related-article-summary-${entry.id}'),
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
      ),
    );
  }
}
