import '../../l10n/app_localizations.dart';
import 'article_publication_metadata.dart';

class ArticleEntry {
  const ArticleEntry({
    required this.id,
    required this.routeName,
    required this.canonicalUri,
    required this.title,
    required this.summary,
    required this.publicationInfo,
    required this.lightThumbnailAsset,
    required this.darkThumbnailAsset,
  });

  final String id;
  final String routeName;
  final Uri canonicalUri;
  final String title;
  final String summary;
  final ArticlePublicationInfo publicationInfo;
  final String lightThumbnailAsset;
  final String darkThumbnailAsset;
}

abstract final class ArticleCatalog {
  static const identityId = 'visual-identity';
  static const identityRouteName = '/artigos/identidade-visual';

  static final identityCanonicalUri = Uri.parse(
    'https://leo-daher.github.io/#/artigos/identidade-visual',
  );

  static final identityPublicationInfo = ArticlePublicationInfo(
    publishedAtUtc: DateTime.utc(2026, 9, 15, 13, 38, 29),
  );

  static List<ArticleEntry> localized(AppLocalizations l10n) => [
    ArticleEntry(
      id: identityId,
      routeName: identityRouteName,
      canonicalUri: identityCanonicalUri,
      title: l10n.identityArticleTitle,
      summary: l10n.identityArticleSummary,
      publicationInfo: identityPublicationInfo,
      lightThumbnailAsset: 'assets/brand/ld-mark.svg',
      darkThumbnailAsset: 'assets/brand/ld-mark-inverse.svg',
    ),
  ];
}
