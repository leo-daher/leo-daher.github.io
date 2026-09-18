import 'package:material_ui/material_ui.dart';

import '../../brand/leone_brand.dart';
import '../../l10n/l10n.dart';

/// A quiet editorial bridge between the introduction and the featured work.
class PortfolioProofStrip extends StatelessWidget {
  const PortfolioProofStrip({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final palette = context.leonePalette;

    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 640;
        final apps = Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              l10n.proofAppsValue,
              key: const Key('proof-apps-value'),
              style: TextStyle(
                color: LeoneBrandColors.interactive,
                fontSize: compact ? 56 : 72,
                height: 1,
                letterSpacing: -3,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Text(
                l10n.proofAppsLabel,
                style: TextStyle(
                  color: palette.ink,
                  fontSize: compact ? 16 : 18,
                  height: 1.45,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        );
        final markets = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.proofMarketsLabel,
              style: TextStyle(
                color: palette.mutedInk,
                fontSize: 11,
                letterSpacing: 1.5,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              l10n.proofMarketsValue,
              key: const Key('proof-markets-value'),
              style: TextStyle(
                color: palette.ink,
                fontSize: compact ? 19 : 22,
                height: 1.45,
                letterSpacing: -.4,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        );

        return Container(
          key: const Key('portfolio-proof-strip'),
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: compact ? 8 : 32,
            vertical: compact ? 24 : 32,
          ),
          decoration: BoxDecoration(
            border: Border.symmetric(
              horizontal: BorderSide(color: palette.outline),
            ),
          ),
          child: compact
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    apps,
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: Divider(height: 1, color: palette.outline),
                    ),
                    markets,
                  ],
                )
              : Row(
                  children: [
                    Expanded(child: apps),
                    Container(
                      width: 1,
                      height: 64,
                      margin: const EdgeInsets.symmetric(horizontal: 32),
                      color: palette.outline,
                    ),
                    Expanded(child: markets),
                  ],
                ),
        );
      },
    );
  }
}
