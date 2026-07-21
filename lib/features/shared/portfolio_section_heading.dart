import 'package:flutter/material.dart';

import '../../brand/leone_brand.dart';

class PortfolioSectionHeading extends StatelessWidget {
  const PortfolioSectionHeading({
    super.key,
    this.eyebrow,
    required this.title,
    required this.copy,
  });

  final String? eyebrow;
  final String title;
  final String copy;

  @override
  Widget build(BuildContext context) {
    final palette = context.leonePalette;
    return Wrap(
      spacing: 36,
      runSpacing: 16,
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.end,
      children: [
        ConstrainedBox(
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
              Text(
                title,
                style: const TextStyle(
                  fontSize: 42,
                  height: 1.05,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -1.5,
                ),
              ),
            ],
          ),
        ),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Text(
            copy,
            style: TextStyle(color: palette.mutedInk, height: 1.55),
          ),
        ),
      ],
    );
  }
}
