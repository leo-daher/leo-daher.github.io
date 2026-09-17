import 'package:material_ui/material_ui.dart';

import '../../brand/leone_brand.dart';
import '../../brand/leone_glass.dart';
import '../../l10n/l10n.dart';

class PortfolioProofStrip extends StatelessWidget {
  const PortfolioProofStrip({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final items = <_ProofItem>[
      _ProofItem(
        value: l10n.proofAppsValue,
        label: l10n.proofAppsLabel,
        valueKey: const Key('proof-apps-value'),
        valueFontWeight: FontWeight.w400,
      ),
      _ProofItem(
        value: l10n.proofMarketsValue,
        valueKey: const Key('proof-markets-value'),
        valueMaxLines: 3,
      ),
    ];
    final palette = context.leonePalette;

    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 860 ? 4 : 2;
        const gap = 10.0;

        return Semantics(
          container: true,
          label: items
              .map(
                (item) => item.label == null
                    ? item.value.replaceAll('\n', ', ')
                    : '${item.value}, ${item.label}',
              )
              .join('. '),
          child: ExcludeSemantics(
            child: LeoneGlassSurface(
              borderRadius: BorderRadius.circular(24),
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
          ),
        );
      },
    );
  }
}

class _ProofItem {
  const _ProofItem({
    required this.value,
    required this.valueKey,
    this.label,
    this.valueMaxLines = 1,
    this.valueFontWeight = FontWeight.w900,
  });

  final String value;
  final Key valueKey;
  final String? label;
  final int valueMaxLines;
  final FontWeight valueFontWeight;
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
              key: item.valueKey,
              item.value,
              maxLines: item.valueMaxLines,
              style: TextStyle(
                color: LeoneBrandColors.interactive,
                fontSize: 17,
                fontWeight: item.valueFontWeight,
                letterSpacing: -.2,
              ),
            ),
          ),
          if (item.label != null) ...[
            const SizedBox(height: 6),
            Text(
              item.label!,
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
        ],
      ),
    );
  }
}
