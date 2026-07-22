import 'package:flutter/material.dart';

import '../../brand/leone_brand.dart';
import '../../l10n/l10n.dart';
import '../shared/portfolio_section_heading.dart';

class SystemOverviewSection extends StatelessWidget {
  const SystemOverviewSection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final scopes = <_ArchitectureScopeData>[
      _ArchitectureScopeData(
        index: '01',
        title: l10n.architectureProductTitle,
        detail: l10n.architectureProductDetail,
      ),
      _ArchitectureScopeData(
        index: '02',
        title: l10n.architectureServicesTitle,
        detail: l10n.architectureServicesDetail,
      ),
      _ArchitectureScopeData(
        index: '03',
        title: l10n.architectureDeliveryTitle,
        detail: l10n.architectureDeliveryDetail,
      ),
      _ArchitectureScopeData(
        index: '04',
        title: l10n.architectureAutomationTitle,
        detail: l10n.architectureAutomationDetail,
      ),
    ];

    return Semantics(
      container: true,
      explicitChildNodes: true,
      child: Column(
        key: const Key('architecture-section'),
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PortfolioSectionHeading(title: l10n.systemTitle),
          const SizedBox(height: 36),
          LayoutBuilder(
            builder: (context, constraints) {
              final columns = constraints.maxWidth >= 1040
                  ? 4
                  : constraints.maxWidth >= 620
                  ? 2
                  : 1;
              const horizontalGap = 32.0;
              const verticalGap = 30.0;
              final width =
                  (constraints.maxWidth - horizontalGap * (columns - 1)) /
                  columns;
              return Wrap(
                key: const Key('architecture-scope-list'),
                spacing: horizontalGap,
                runSpacing: verticalGap,
                children: [
                  for (final scope in scopes)
                    SizedBox(
                      width: width,
                      child: _ArchitectureScope(data: scope),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ArchitectureScopeData {
  const _ArchitectureScopeData({
    required this.index,
    required this.title,
    required this.detail,
  });

  final String index;
  final String title;
  final String detail;
}

class _ArchitectureScope extends StatelessWidget {
  const _ArchitectureScope({required this.data});

  final _ArchitectureScopeData data;

  @override
  Widget build(BuildContext context) {
    final palette = context.leonePalette;
    return Semantics(
      container: true,
      label: '${data.title}. ${data.detail}',
      child: ExcludeSemantics(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              data.index,
              style: const TextStyle(
                color: LeoneBrandColors.interactive,
                fontSize: 11,
                height: 1.5,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.1,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.title,
                    style: TextStyle(
                      color: palette.ink,
                      fontSize: 17,
                      height: 1.25,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    data.detail,
                    style: TextStyle(
                      color: palette.mutedInk,
                      fontSize: 13,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
