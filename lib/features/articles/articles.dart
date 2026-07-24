import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/link.dart';

import '../../brand/leone_brand.dart';
import '../../l10n/l10n.dart';
import '../shared/portfolio_section_heading.dart';

class ArticlesSection extends StatelessWidget {
  const ArticlesSection({super.key, required this.onOpenArticles});

  final VoidCallback onOpenArticles;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final palette = context.leonePalette;
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
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: LeoneBrandColors.editorialHighlight.withValues(
                        alpha: .12,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Icon(
                      Icons.article_outlined,
                      color: LeoneBrandColors.editorialHighlight,
                    ),
                  ),
                  const SizedBox(width: 18),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _DraftBadge(label: l10n.articleDraftStatus),
                        const SizedBox(height: 12),
                        Text(
                          l10n.identityArticleTitle,
                          style: const TextStyle(
                            fontSize: 20,
                            height: 1.2,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          l10n.identityArticleSummary,
                          style: TextStyle(
                            color: palette.mutedInk,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Icon(Icons.arrow_forward_rounded),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ArticlesPage extends StatelessWidget {
  const ArticlesPage({super.key});

  static const routeName = '/artigos/identidade-visual';

  static final canonicalArticleUri = Uri.parse(
    'https://leo-daher.github.io/#/artigos/identidade-visual',
  );

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
    final palette = context.leonePalette;
    return Scaffold(
      key: const Key('articles-page'),
      appBar: AppBar(
        title: Text(l10n.articlesPageTitle),
        backgroundColor: palette.canvas,
        surfaceTintColor: Colors.transparent,
      ),
      body: SelectionArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 48, 24, 72),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 920),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _DraftBadge(label: l10n.articleDraftStatus),
                  const SizedBox(height: 20),
                  Semantics(
                    header: true,
                    child: Text(
                      l10n.identityArticleTitle,
                      style: TextStyle(
                        fontSize: MediaQuery.sizeOf(context).width < 620
                            ? 38
                            : 58,
                        height: 1.02,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -2,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    l10n.identityArticleSummary,
                    style: TextStyle(
                      color: palette.mutedInk,
                      fontSize: 19,
                      height: 1.55,
                    ),
                  ),
                  const SizedBox(height: 36),
                  const _ArticlePlanCard(),
                  const SizedBox(height: 36),
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
                  _ShareBadges(title: l10n.identityArticleTitle),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ArticlePlanCard extends StatelessWidget {
  const _ArticlePlanCard();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final palette = context.leonePalette;
    final topics = [
      l10n.identityArticleTopicStrategy,
      l10n.identityArticleTopicSymbol,
      l10n.identityArticleTopicMotion,
      l10n.identityArticleTopicSystem,
    ];
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: palette.surfaceRaised,
        border: Border.all(color: palette.outline),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.identityArticlePlanTitle,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 16),
          for (final topic in topics)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 2),
                    child: Icon(
                      Icons.check_circle_outline_rounded,
                      size: 18,
                      color: LeoneBrandColors.interactive,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      topic,
                      style: TextStyle(color: palette.mutedInk, height: 1.4),
                    ),
                  ),
                ],
              ),
            ),
        ],
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
        label: '${context.l10n.shareOn} $label',
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

class _DraftBadge extends StatelessWidget {
  const _DraftBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
      decoration: BoxDecoration(
        color: LeoneBrandColors.editorialWarm.withValues(alpha: .13),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: LeoneBrandColors.editorialWarm.withValues(alpha: .42),
        ),
      ),
      child: Text(
        label.toUpperCase(),
        style: const TextStyle(
          color: LeoneBrandColors.editorialWarm,
          fontSize: 10,
          fontWeight: FontWeight.w900,
          letterSpacing: .8,
        ),
      ),
    );
  }
}
