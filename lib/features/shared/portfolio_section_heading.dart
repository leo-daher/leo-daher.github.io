import 'package:flutter/material.dart';

import '../../brand/leone_brand.dart';

class PortfolioSectionHeading extends StatelessWidget {
  const PortfolioSectionHeading({
    super.key,
    this.eyebrow,
    required this.title,
    this.copy,
    this.copyBelowTitle = false,
  });

  final String? eyebrow;
  final String title;
  final String? copy;
  final bool copyBelowTitle;

  @override
  Widget build(BuildContext context) {
    final palette = context.leonePalette;
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 620;
        final supportingCopy = copy;
        final copyStyle = TextStyle(color: palette.mutedInk, height: 1.55);
        final heading = ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 650),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (eyebrow case final eyebrow?) ...[
                Text(
                  eyebrow,
                  style: const TextStyle(
                    color: LeoneBrandColors.interactive,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 12),
              ],
              Semantics(
                header: true,
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: compact ? 32 : 42,
                    height: 1.05,
                    fontWeight: FontWeight.w800,
                    letterSpacing: compact ? -1 : -1.5,
                  ),
                ),
              ),
              if (copyBelowTitle && supportingCopy != null) ...[
                const SizedBox(height: 16),
                Text(supportingCopy, style: copyStyle),
              ],
            ],
          ),
        );

        if (copyBelowTitle || supportingCopy == null) {
          return Align(alignment: Alignment.centerLeft, child: heading);
        }

        return Wrap(
          spacing: 36,
          runSpacing: 16,
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.end,
          children: [
            heading,
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Text(supportingCopy, style: copyStyle),
            ),
          ],
        );
      },
    );
  }
}
