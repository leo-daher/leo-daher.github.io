import 'package:flutter/material.dart';

import '../../brand/leone_brand.dart';
import '../../l10n/l10n.dart';

class PortfolioProofStrip extends StatelessWidget {
  const PortfolioProofStrip({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final items = <_ProofItem>[
      _ProofItem(value: l10n.proofAppsValue, label: l10n.proofAppsLabel),
      _ProofItem(
        value: l10n.proofPlatformsValue,
        label: l10n.proofPlatformsLabel,
      ),
      _ProofItem(value: l10n.proofMarketsValue, label: l10n.proofMarketsLabel),
      _ProofItem(
        value: l10n.proofDownloadsValue,
        label: l10n.proofDownloadsLabel,
      ),
    ];
    final palette = context.leonePalette;

    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 860 ? 4 : 2;
        const gap = 10.0;

        return Semantics(
          container: true,
          label: items.map((item) => '${item.value}, ${item.label}').join('. '),
          child: ExcludeSemantics(
            child: Container(
              key: const Key('portfolio-proof-strip'),
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: palette.surface.withValues(alpha: .62),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: palette.outline),
              ),
              child: LayoutBuilder(
                builder: (context, innerConstraints) {
                  final tileWidth =
                      (innerConstraints.maxWidth - gap * (columns - 1)) /
                      columns;
                  return Wrap(
                    spacing: gap,
                    runSpacing: gap,
                    children: [
                      for (final item in items)
                        SizedBox(
                          width: tileWidth,
                          child: _ProofTile(item: item),
                        ),
                    ],
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ProofItem {
  const _ProofItem({required this.value, required this.label});

  final String value;
  final String label;
}

class _ProofTile extends StatelessWidget {
  const _ProofTile({required this.item});

  final _ProofItem item;

  @override
  Widget build(BuildContext context) {
    final palette = context.leonePalette;
    return Container(
      constraints: const BoxConstraints(minHeight: 96),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: palette.canvas.withValues(alpha: .5),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              item.value,
              maxLines: 1,
              style: const TextStyle(
                color: LeoneBrandColors.interactive,
                fontSize: 17,
                fontWeight: FontWeight.w900,
                letterSpacing: -.2,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            item.label,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: palette.mutedInk,
              fontSize: 11,
              height: 1.25,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
