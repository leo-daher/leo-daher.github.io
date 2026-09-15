import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/link.dart';

import '../../brand/leone_brand.dart';
import '../../l10n/l10n.dart';
import '../navigation/portfolio_header_actions.dart';
import '../shared/portfolio_section_heading.dart';
import 'article_catalog.dart';
import 'article_page_layout.dart';
import 'article_publication_metadata.dart';
import 'identity_article_figures.dart';

class ArticlesSection extends StatelessWidget {
  const ArticlesSection({super.key, required this.onOpenArticles});

  final VoidCallback onOpenArticles;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final palette = context.leonePalette;
    final identityArticle = ArticleCatalog.localized(
      l10n,
    ).singleWhere((article) => article.id == ArticleCatalog.identityId);
    return Column(
      key: const Key('articles-section'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PortfolioSectionHeading(
          eyebrow: l10n.articlesEyebrow,
          title: l10n.articlesTitle,
          copy: l10n.articlesCopy,
        ),
        const SizedBox(height: 30),
        Material(
          color: palette.surface.withValues(alpha: .72),
          shape: RoundedRectangleBorder(
            side: BorderSide(color: palette.outline),
            borderRadius: BorderRadius.circular(24),
          ),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            key: const Key('open-articles-page'),
            onTap: onOpenArticles,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final copy = _ArticleCardCopy(
                    title: identityArticle.title,
                    summary: identityArticle.summary,
                    publicationInfo: identityArticle.publicationInfo,
                  );
                  if (constraints.maxWidth < 520) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _ArticleCardIcon(),
                            Icon(Icons.arrow_forward_rounded),
                          ],
                        ),
                        const SizedBox(height: 18),
                        copy,
                      ],
                    );
                  }
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _ArticleCardIcon(),
                      const SizedBox(width: 18),
                      Expanded(child: copy),
                      const SizedBox(width: 12),
                      const Icon(Icons.arrow_forward_rounded),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ArticleCardIcon extends StatelessWidget {
  const _ArticleCardIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: LeoneBrandColors.editorialHighlight.withValues(alpha: .12),
        borderRadius: BorderRadius.circular(15),
      ),
      child: const Icon(
        Icons.article_outlined,
        color: LeoneBrandColors.editorialHighlight,
      ),
    );
  }
}

class _ArticleCardCopy extends StatelessWidget {
  const _ArticleCardCopy({
    required this.title,
    required this.summary,
    required this.publicationInfo,
  });

  final String title;
  final String summary;
  final ArticlePublicationInfo publicationInfo;

  @override
  Widget build(BuildContext context) {
    final palette = context.leonePalette;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            height: 1.2,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 8),
        Text(summary, style: TextStyle(color: palette.mutedInk, height: 1.5)),
        const SizedBox(height: 12),
        ArticlePublicationLine(info: publicationInfo),
      ],
    );
  }
}

class ArticlesPage extends StatelessWidget {
  const ArticlesPage({
    super.key,
    required this.onLocaleChanged,
    required this.onThemeModeChanged,
  });

  final ValueChanged<Locale> onLocaleChanged;
  final ValueChanged<ThemeMode> onThemeModeChanged;

  static const routeName = ArticleCatalog.identityRouteName;

  static Uri get canonicalArticleUri => ArticleCatalog.identityCanonicalUri;

  static ArticlePublicationInfo get publicationInfo =>
      ArticleCatalog.identityPublicationInfo;

  static Uri linkedinShareUri(String title) => Uri.https(
    'www.linkedin.com',
    '/sharing/share-offsite/',
    {'url': canonicalArticleUri.toString()},
  );

  static Uri whatsAppShareUri(String title) => Uri.https('wa.me', '/', {
    'text': '$title ${canonicalArticleUri.toString()}',
  });

  static Uri xShareUri(String title) => Uri.https(
    'twitter.com',
    '/intent/tweet',
    {'text': title, 'url': canonicalArticleUri.toString()},
  );

  static Uri facebookShareUri(String title) => Uri.https(
    'www.facebook.com',
    '/sharer/sharer.php',
    {'u': canonicalArticleUri.toString()},
  );

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final compact = MediaQuery.sizeOf(context).width < 440;
    final articles = ArticleCatalog.localized(l10n);
    final currentArticle = articles.singleWhere(
      (article) => article.id == ArticleCatalog.identityId,
    );

    return ArticlePageLayout(
      pageKey: const Key('articles-page'),
      currentArticle: currentArticle,
      articles: articles,
      article: _IdentityArticleContent(article: currentArticle),
      topActions: PortfolioHeaderActions(
        compact: compact,
        onLocaleChanged: onLocaleChanged,
        onThemeModeChanged: onThemeModeChanged,
      ),
    );
  }
}

class _IdentityArticleContent extends StatelessWidget {
  const _IdentityArticleContent({required this.article});

  final ArticleEntry article;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final palette = context.leonePalette;

    return SizedBox(
      key: const Key('article-reading-column'),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Semantics(
            header: true,
            child: Text(
              article.title,
              style: TextStyle(
                fontSize: MediaQuery.sizeOf(context).width < 620 ? 38 : 58,
                height: 1.02,
                fontWeight: FontWeight.w800,
                letterSpacing: -2,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            article.summary,
            style: TextStyle(
              color: palette.mutedInk,
              fontSize: 19,
              height: 1.55,
            ),
          ),
          const SizedBox(height: 18),
          ArticlePublicationLine(info: article.publicationInfo),
          const SizedBox(height: 38),
          IdentityLogoFigure(
            caption: l10n.identityArticleLogoCaption,
            semanticLabel: l10n.identityArticleLogoSemantics,
          ),
          const SizedBox(height: 30),
          _ArticleBodyText(l10n.identityArticleIntro, prominent: true),
          const SizedBox(height: 68),
          _ArticleSectionHeading(
            eyebrow: l10n.identityArticleStructureEyebrow,
            title: l10n.identityArticleStructureTitle,
          ),
          const SizedBox(height: 18),
          _ArticleBodyText(l10n.identityArticleStructureBody),
          const SizedBox(height: 28),
          IdentityExplodedFigure(
            caption: l10n.identityArticleExplodedCaption,
            semanticLabel: l10n.identityArticleExplodedSemantics,
            lLabel: l10n.identityArticleLLabel,
            dLabel: l10n.identityArticleDLabel,
            cutLabel: l10n.identityArticleCutLabel,
            dotLabel: l10n.identityArticleDotLabel,
          ),
          const SizedBox(height: 68),
          _ArticleSectionHeading(
            eyebrow: l10n.identityArticleFabEyebrow,
            title: l10n.identityArticleFabTitle,
          ),
          const SizedBox(height: 18),
          _ArticleBodyText(l10n.identityArticleFabBody),
          const SizedBox(height: 16),
          _ArticleBodyText(l10n.identityArticleFabColorBody),
          const SizedBox(height: 28),
          IdentityFabFigure(
            caption: l10n.identityArticleFabCaption,
            semanticLabel: l10n.identityArticleFabSemantics,
            brandDotLabel: l10n.identityArticleBrandDotStage,
            functionalFabLabel: l10n.identityArticleFunctionalFabStage,
          ),
          const SizedBox(height: 68),
          _ArticleSectionHeading(
            eyebrow: l10n.identityArticleMotionEyebrow,
            title: l10n.identityArticleMotionTitle,
          ),
          const SizedBox(height: 18),
          _ArticleBodyText(l10n.identityArticleMotionBody),
          const SizedBox(height: 16),
          _ArticleBodyText(l10n.identityArticleMotionEffectBody),
          const SizedBox(height: 28),
          IdentityOpeningSequenceFigure(
            caption: l10n.identityArticleMotionCaption,
            semanticLabel: l10n.identityArticleMotionSemantics,
            logoLabel: l10n.identityArticleOpeningLogoStage,
            expansionLabel: l10n.identityArticleOpeningExpansionStage,
            viewportLabel: l10n.identityArticleOpeningViewportStage,
            interfaceLabel: l10n.identityArticleOpeningInterfaceStage,
          ),
          const SizedBox(height: 52),
          Divider(color: palette.outline),
          const SizedBox(height: 28),
          _ArticleBodyText(l10n.identityArticleConclusion, prominent: true),
          const SizedBox(height: 56),
          Text(
            l10n.shareArticleTitle,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              letterSpacing: .8,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.shareArticleCopy,
            style: TextStyle(color: palette.mutedInk, height: 1.5),
          ),
          const SizedBox(height: 18),
          _ShareBadges(title: article.title),
        ],
      ),
    );
  }
}

class _ArticleSectionHeading extends StatelessWidget {
  const _ArticleSectionHeading({required this.eyebrow, required this.title});

  final String eyebrow;
  final String title;

  @override
  Widget build(BuildContext context) {
    final palette = context.leonePalette;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          eyebrow,
          style: const TextStyle(
            color: LeoneBrandColors.interactive,
            fontSize: 11,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.4,
          ),
        ),
        const SizedBox(height: 10),
        Semantics(
          header: true,
          child: Text(
            title,
            style: TextStyle(
              color: palette.ink,
              fontSize: 32,
              height: 1.08,
              fontWeight: FontWeight.w800,
              letterSpacing: -1,
            ),
          ),
        ),
      ],
    );
  }
}

class _ArticleBodyText extends StatelessWidget {
  const _ArticleBodyText(this.copy, {this.prominent = false});

  final String copy;
  final bool prominent;

  @override
  Widget build(BuildContext context) {
    final palette = context.leonePalette;
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 760),
      child: Text(
        copy,
        style: TextStyle(
          color: prominent ? palette.ink : palette.mutedInk,
          fontSize: prominent ? 19 : 17,
          height: prominent ? 1.62 : 1.72,
          fontWeight: prominent ? FontWeight.w500 : FontWeight.w400,
        ),
      ),
    );
  }
}

class _ShareBadges extends StatelessWidget {
  const _ShareBadges({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      key: const Key('article-share-badges'),
      spacing: 10,
      runSpacing: 10,
      children: [
        _ShareBadge(
          linkKey: const Key('share-linkedin'),
          label: 'LinkedIn',
          uri: ArticlesPage.linkedinShareUri(title),
          background: const Color(0xFF0A66C2),
          iconAsset: 'assets/brand/linkedin-symbol.svg',
        ),
        _ShareBadge(
          linkKey: const Key('share-whatsapp'),
          label: 'WhatsApp',
          uri: ArticlesPage.whatsAppShareUri(title),
          background: const Color(0xFF25D366),
          iconAsset: 'assets/brand/whatsapp-symbol.svg',
          foreground: const Color(0xFF07140B),
        ),
        _ShareBadge(
          linkKey: const Key('share-x'),
          label: 'X',
          uri: ArticlesPage.xShareUri(title),
          background: const Color(0xFF000000),
          textMark: '𝕏',
        ),
        _ShareBadge(
          linkKey: const Key('share-facebook'),
          label: 'Facebook',
          uri: ArticlesPage.facebookShareUri(title),
          background: const Color(0xFF1877F2),
          textMark: 'f',
        ),
      ],
    );
  }
}

class _ShareBadge extends StatelessWidget {
  const _ShareBadge({
    required this.linkKey,
    required this.label,
    required this.uri,
    required this.background,
    this.iconAsset,
    this.textMark,
    this.foreground = Colors.white,
  }) : assert(iconAsset != null || textMark != null);

  final String label;
  final Key linkKey;
  final Uri uri;
  final Color background;
  final String? iconAsset;
  final String? textMark;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return Link(
      key: linkKey,
      uri: uri,
      target: LinkTarget.blank,
      builder: (context, followLink) => Semantics(
        link: true,
        button: true,
        excludeSemantics: true,
        label: '${context.l10n.shareOn} $label',
        onTap: followLink,
        child: Material(
          color: background,
          shape: const StadiumBorder(),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: followLink,
            child: ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 44),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (iconAsset case final asset?)
                      SvgPicture.asset(
                        asset,
                        width: 18,
                        height: 18,
                        colorFilter: ColorFilter.mode(
                          foreground,
                          BlendMode.srcIn,
                        ),
                        excludeFromSemantics: true,
                      )
                    else
                      Text(
                        textMark!,
                        textScaler: TextScaler.noScaling,
                        style: TextStyle(
                          color: foreground,
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    const SizedBox(width: 9),
                    Text(
                      label,
                      style: TextStyle(
                        color: foreground,
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
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
