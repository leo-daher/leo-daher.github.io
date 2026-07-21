import 'package:flutter/material.dart';
import 'package:url_launcher/link.dart';

import '../../brand/leone_brand.dart';
import '../../l10n/l10n.dart';
import '../shared/portfolio_section_heading.dart';
import 'certificate_catalog.dart';

class CertificationsSection extends StatefulWidget {
  const CertificationsSection({super.key, this.catalog});

  final CertificateCatalog? catalog;

  @override
  State<CertificationsSection> createState() => _CertificationsSectionState();
}

class _CertificationsSectionState extends State<CertificationsSection> {
  late final Future<CertificateCatalog> _catalog = widget.catalog == null
      ? CertificateCatalog.load()
      : Future<CertificateCatalog>.value(widget.catalog);

  @override
  Widget build(BuildContext context) => FutureBuilder<CertificateCatalog>(
    future: _catalog,
    builder: (context, snapshot) {
      if (!snapshot.hasData) {
        return const SizedBox.shrink();
      }
      return _CertificationsContent(catalog: snapshot.requireData);
    },
  );
}

class _CertificationsContent extends StatelessWidget {
  const _CertificationsContent({required this.catalog});

  final CertificateCatalog catalog;

  void _openRegister(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => _CertificateRegisterDialog(catalog: catalog),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final palette = context.leonePalette;
    return Center(
      key: const Key('certifications-section'),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1240),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PortfolioSectionHeading(
                eyebrow: l10n.certificationsEyebrow,
                title: l10n.certificationsTitle,
                copy: l10n.certificationsCopy,
              ),
              const SizedBox(height: 30),
              LayoutBuilder(
                builder: (context, constraints) {
                  final compact = constraints.maxWidth < 620;
                  return Container(
                    padding: EdgeInsets.all(compact ? 20 : 24),
                    decoration: BoxDecoration(
                      color: palette.surface.withValues(alpha: .78),
                      borderRadius: BorderRadius.circular(compact ? 24 : 30),
                      border: Border.all(color: palette.outline),
                    ),
                    child: Wrap(
                      spacing: 28,
                      runSpacing: 20,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        const _CertificateSeal(),
                        _CertificateMetrics(
                          credentials: l10n.verifiedCredentials(
                            catalog.certificates.length,
                          ),
                          issuerCount: catalog.issuerCount,
                          issuersLabel: l10n.issuers,
                        ),
                        OutlinedButton.icon(
                          key: const Key('certificates-open-register'),
                          onPressed: () => _openRegister(context),
                          icon: const Icon(Icons.open_in_new_rounded, size: 18),
                          label: Text(l10n.viewCredentials),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CertificateSeal extends StatelessWidget {
  const _CertificateSeal();

  @override
  Widget build(BuildContext context) => Container(
    width: 48,
    height: 48,
    alignment: Alignment.center,
    decoration: BoxDecoration(
      color: LeoneBrandColors.interactive.withValues(alpha: .13),
      borderRadius: BorderRadius.circular(16),
    ),
    child: const Icon(
      Icons.verified_outlined,
      color: LeoneBrandColors.interactive,
      size: 26,
    ),
  );
}

class _CertificateMetrics extends StatelessWidget {
  const _CertificateMetrics({
    required this.credentials,
    required this.issuerCount,
    required this.issuersLabel,
  });

  final String credentials;
  final int issuerCount;
  final String issuersLabel;

  @override
  Widget build(BuildContext context) {
    final palette = context.leonePalette;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          credentials.toUpperCase(),
          style: TextStyle(
            color: palette.ink,
            fontSize: 12,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.1,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          '$issuerCount $issuersLabel',
          style: TextStyle(color: palette.mutedInk, height: 1.4),
        ),
      ],
    );
  }
}

class _CertificateRegisterDialog extends StatefulWidget {
  const _CertificateRegisterDialog({required this.catalog});

  final CertificateCatalog catalog;

  @override
  State<_CertificateRegisterDialog> createState() =>
      _CertificateRegisterDialogState();
}

class _CertificateRegisterDialogState
    extends State<_CertificateRegisterDialog> {
  final Set<String> _selectedTechnologies = {};

  List<CertificateYearGroup> get _filteredGroups => [
    for (final group in widget.catalog.groupsByYear)
      CertificateYearGroup(
        year: group.year,
        certificates: [
          for (final certificate in group.certificates)
            if (_matchesFilters(certificate)) certificate,
        ],
      ),
  ].where((group) => group.certificates.isNotEmpty).toList(growable: false);

  bool _matchesFilters(CertificateRecord certificate) =>
      _selectedTechnologies.isEmpty ||
      certificate.technologies.any(_selectedTechnologies.contains);

  void _toggleTechnology(String technology) {
    setState(() {
      if (!_selectedTechnologies.add(technology)) {
        _selectedTechnologies.remove(technology);
      }
    });
  }

  void _clearFilters() => setState(_selectedTechnologies.clear);

  void _openPreview(BuildContext context, CertificateRecord certificate) {
    showDialog<void>(
      context: context,
      builder: (context) => _CertificatePreviewDialog(certificate: certificate),
    );
  }

  String get _resultsKey {
    final technologies = _selectedTechnologies.toList()..sort();
    return technologies.isEmpty
        ? 'all'
        : technologies.map(_technologyKey).join('-');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final palette = context.leonePalette;
    return Dialog(
      key: const Key('certificate-register-dialog'),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1000, maxHeight: 760),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 22, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.certificateRegister,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          l10n.certificateRegisterCopy,
                          style: TextStyle(
                            color: palette.mutedInk,
                            height: 1.45,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    tooltip: l10n.closeDialog,
                    icon: const Icon(Icons.close_rounded),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              _CertificateTechnologyFilters(
                technologies: widget.catalog.technologyTags,
                selectedTechnologies: _selectedTechnologies,
                onTechnologySelected: _toggleTechnology,
                onClear: _selectedTechnologies.isEmpty ? null : _clearFilters,
              ),
              const SizedBox(height: 18),
              Expanded(
                child: AnimatedSwitcher(
                  duration: MediaQuery.disableAnimationsOf(context)
                      ? Duration.zero
                      : const Duration(milliseconds: 180),
                  reverseDuration: MediaQuery.disableAnimationsOf(context)
                      ? Duration.zero
                      : const Duration(milliseconds: 140),
                  transitionBuilder: (child, animation) => FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position:
                          Tween<Offset>(
                            begin: const Offset(0, .025),
                            end: Offset.zero,
                          ).animate(
                            CurvedAnimation(
                              parent: animation,
                              curve: Curves.easeOutCubic,
                            ),
                          ),
                      child: child,
                    ),
                  ),
                  child: _CertificateFilterResults(
                    key: ValueKey('certificate-filter-results-$_resultsKey'),
                    groups: _filteredGroups,
                    onOpenPreview: (certificate) =>
                        _openPreview(context, certificate),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CertificateTechnologyFilters extends StatelessWidget {
  const _CertificateTechnologyFilters({
    required this.technologies,
    required this.selectedTechnologies,
    required this.onTechnologySelected,
    required this.onClear,
  });

  final List<String> technologies;
  final Set<String> selectedTechnologies;
  final ValueChanged<String> onTechnologySelected;
  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final palette = context.leonePalette;
    return Semantics(
      container: true,
      label: l10n.filterTechnologies,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                l10n.filterTechnologies,
                style: TextStyle(
                  color: palette.mutedInk,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: .8,
                ),
              ),
              const Spacer(),
              if (onClear != null)
                TextButton(
                  key: const Key('certificate-clear-filters'),
                  onPressed: onClear,
                  child: Text(l10n.clearFilters),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final technology in technologies)
                FilterChip(
                  key: Key('certificate-filter-${_technologyKey(technology)}'),
                  label: Text(technology),
                  selected: selectedTechnologies.contains(technology),
                  onSelected: (_) => onTechnologySelected(technology),
                  showCheckmark: false,
                  materialTapTargetSize: MaterialTapTargetSize.padded,
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CertificateYearHeading extends StatelessWidget {
  const _CertificateYearHeading({required this.year});

  final int year;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Text(
      year.toString(),
      style: TextStyle(
        color: context.leonePalette.ink,
        fontSize: 18,
        fontWeight: FontWeight.w800,
        letterSpacing: .2,
      ),
    ),
  );
}

class _CertificateYearGrid extends StatelessWidget {
  const _CertificateYearGrid({
    required this.certificates,
    required this.onOpenPreview,
  });

  final List<CertificateRecord> certificates;
  final ValueChanged<CertificateRecord> onOpenPreview;

  @override
  Widget build(BuildContext context) => SliverPadding(
    padding: const EdgeInsets.only(right: 8, bottom: 28),
    sliver: SliverGrid(
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 320,
        mainAxisExtent: 250,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      delegate: SliverChildBuilderDelegate((context, index) {
        final certificate = certificates[index];
        return _CertificateGalleryCard(
          certificate: certificate,
          onTap: () => onOpenPreview(certificate),
        );
      }, childCount: certificates.length),
    ),
  );
}

class _CertificateGalleryCard extends StatelessWidget {
  const _CertificateGalleryCard({
    required this.certificate,
    required this.onTap,
  });

  final CertificateRecord certificate;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final palette = context.leonePalette;
    return Material(
      color: palette.surface.withValues(alpha: .72),
      borderRadius: BorderRadius.circular(20),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        key: Key('certificate-card-${certificate.id}'),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.verified_rounded,
                    size: 17,
                    color: LeoneBrandColors.interactive,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    l10n.verified.toUpperCase(),
                    style: const TextStyle(
                      color: LeoneBrandColors.interactive,
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      letterSpacing: .8,
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    Icons.arrow_outward_rounded,
                    size: 18,
                    color: palette.mutedInk,
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                certificate.title,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: palette.ink,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 12),
              _CertificateTechnologyTags(
                technologies: certificate.technologies,
              ),
              const Spacer(),
              Text(
                l10n.issuedBy(certificate.issuer),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: palette.mutedInk, fontSize: 12),
              ),
              const SizedBox(height: 4),
              Text(
                l10n.completedIn(certificate.completedOn.year.toString()),
                style: TextStyle(color: palette.mutedInk, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CertificateFilterResults extends StatelessWidget {
  const _CertificateFilterResults({
    super.key,
    required this.groups,
    required this.onOpenPreview,
  });

  final List<CertificateYearGroup> groups;
  final ValueChanged<CertificateRecord> onOpenPreview;

  @override
  Widget build(BuildContext context) => Scrollbar(
    child: CustomScrollView(
      slivers: [
        for (final group in groups) ...[
          SliverToBoxAdapter(child: _CertificateYearHeading(year: group.year)),
          _CertificateYearGrid(
            certificates: group.certificates,
            onOpenPreview: onOpenPreview,
          ),
        ],
      ],
    ),
  );
}

class _CertificateTechnologyTags extends StatelessWidget {
  const _CertificateTechnologyTags({required this.technologies});

  final List<String> technologies;

  @override
  Widget build(BuildContext context) => Semantics(
    label: '${context.l10n.technologies}: ${technologies.join(', ')}',
    child: ExcludeSemantics(
      child: Wrap(
        spacing: 6,
        runSpacing: 6,
        children: [
          for (final technology in technologies)
            _TechnologyTag(label: technology),
        ],
      ),
    ),
  );
}

class _TechnologyTag extends StatelessWidget {
  const _TechnologyTag({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
    decoration: BoxDecoration(
      color: LeoneBrandColors.interactive.withValues(alpha: .12),
      borderRadius: BorderRadius.circular(999),
      border: Border.all(
        color: LeoneBrandColors.interactive.withValues(alpha: .24),
      ),
    ),
    child: Text(
      label,
      style: TextStyle(
        color: context.leonePalette.ink,
        fontSize: 11,
        fontWeight: FontWeight.w700,
      ),
    ),
  );
}

class _CertificatePreviewDialog extends StatelessWidget {
  const _CertificatePreviewDialog({required this.certificate});

  final CertificateRecord certificate;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final palette = context.leonePalette;
    return Dialog(
      key: const Key('certificate-preview-dialog'),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 900, maxHeight: 760),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          certificate.title,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          l10n.certificateFor(certificate.holder),
                          style: TextStyle(color: palette.mutedInk),
                        ),
                        const SizedBox(height: 10),
                        _CertificateTechnologyTags(
                          technologies: certificate.technologies,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    tooltip: l10n.closeDialog,
                    icon: const Icon(Icons.close_rounded),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Semantics(
                image: true,
                label: certificate.title,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    certificate.imageAssetPath,
                    cacheWidth: 1400,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  Link(
                    uri: certificate.verificationUrl,
                    target: LinkTarget.blank,
                    builder: (context, followLink) => FilledButton.icon(
                      onPressed: followLink,
                      icon: const Icon(Icons.verified_outlined, size: 18),
                      label: Text(l10n.verifyCredential),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String _technologyKey(String technology) => technology
    .toLowerCase()
    .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
    .replaceAll(RegExp(r'^-|-$'), '');
