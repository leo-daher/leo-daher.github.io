import 'package:flutter/material.dart';

import '../../brand/leone_brand.dart';
import '../../l10n/l10n.dart';

class ArticlePublicationInfo {
  ArticlePublicationInfo({required this.publishedAtUtc, this.lastEditedAtUtc}) {
    if (!publishedAtUtc.isUtc) {
      throw ArgumentError.value(
        publishedAtUtc,
        'publishedAtUtc',
        'Article publication timestamps must use UTC.',
      );
    }
    if (lastEditedAtUtc case final editedAt?) {
      if (!editedAt.isUtc) {
        throw ArgumentError.value(
          editedAt,
          'lastEditedAtUtc',
          'Article edition timestamps must use UTC.',
        );
      }
      if (editedAt.isBefore(publishedAtUtc)) {
        throw ArgumentError.value(
          editedAt,
          'lastEditedAtUtc',
          'The last edition cannot predate publication.',
        );
      }
    }
  }

  static const timeZoneOffset = Duration(hours: -3);
  static const timeZoneLabel = 'BRT';

  final DateTime publishedAtUtc;
  final DateTime? lastEditedAtUtc;

  bool get hasLastEdition =>
      lastEditedAtUtc != null && lastEditedAtUtc != publishedAtUtc;

  DateTime wallTimeFor(DateTime timestamp) =>
      timestamp.toUtc().add(timeZoneOffset);
}

class ArticlePublicationLine extends StatelessWidget {
  const ArticlePublicationLine({super.key, required this.info});

  final ArticlePublicationInfo info;

  @override
  Widget build(BuildContext context) {
    final publishedAt = info.wallTimeFor(info.publishedAtUtc);
    final publishedLabel = context.l10n.articlePublishedAt(
      publishedAt,
      publishedAt,
      ArticlePublicationInfo.timeZoneLabel,
    );
    final lastEditedAt = info.lastEditedAtUtc;

    return Column(
      key: const Key('article-metadata'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _ArticleTimestamp(
          key: const Key('article-published-at'),
          icon: Icons.schedule_rounded,
          label: publishedLabel,
        ),
        if (info.hasLastEdition && lastEditedAt != null) ...[
          const SizedBox(height: 6),
          _ArticleTimestamp(
            key: const Key('article-last-edited-at'),
            icon: Icons.edit_calendar_outlined,
            label: _lastEditedLabel(context, lastEditedAt),
          ),
        ],
      ],
    );
  }

  String _lastEditedLabel(BuildContext context, DateTime timestamp) {
    final wallTime = info.wallTimeFor(timestamp);
    return context.l10n.articleLastEditedAt(
      wallTime,
      wallTime,
      ArticlePublicationInfo.timeZoneLabel,
    );
  }
}

class _ArticleTimestamp extends StatelessWidget {
  const _ArticleTimestamp({super.key, required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final palette = context.leonePalette;
    return Semantics(
      label: label,
      child: ExcludeSemantics(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 1),
              child: Icon(icon, size: 16, color: palette.mutedInk),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: palette.mutedInk,
                  fontSize: 13,
                  height: 1.4,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
