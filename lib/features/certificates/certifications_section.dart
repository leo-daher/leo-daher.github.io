import 'package:flutter/foundation.dart';
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
                      color: LeoneBrandColors.surface.withValues(alpha: .78),
                      borderRadius: BorderRadius.circular(compact ? 24 : 30),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: .075),
                      ),
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
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        credentials.toUpperCase(),
        style: const TextStyle(
          color: LeoneBrandColors.ink,
          fontSize: 12,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.1,
        ),
      ),
      const SizedBox(height: 6),
      Text(
        '$issuerCount $issuersLabel',
        style: const TextStyle(color: LeoneBrandColors.mutedInk, height: 1.4),
      ),
    ],
  );
}

class _CertificateRegisterDialog extends StatelessWidget {
  const _CertificateRegisterDialog({required this.catalog});

  final CertificateCatalog catalog;

  void _openPreview(BuildContext context, CertificateRecord certificate) {
    showDialog<void>(
      context: context,
      builder: (context) => _CertificatePreviewDialog(certificate: certificate),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Dialog(
      key: const Key('certificate-register-dialog'),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 760, maxHeight: 700),
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
                          style: const TextStyle(
                            color: LeoneBrandColors.mutedInk,
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
              const SizedBox(height: 16),
              Expanded(
                child: ListView.separated(
                  itemCount: catalog.certificates.length,
                  separatorBuilder: (_, _) => Divider(
                    height: 1,
                    color: Colors.white.withValues(alpha: .08),
                  ),
                  itemBuilder: (context, index) {
                    final certificate = catalog.certificates[index];
                    return _CertificateListTile(
                      certificate: certificate,
                      onTap: () => _openPreview(context, certificate),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CertificateListTile extends StatelessWidget {
  const _CertificateListTile({required this.certificate, required this.onTap});

  final CertificateRecord certificate;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return ListTile(
      key: Key('certificate-row-${certificate.id}'),
      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      onTap: onTap,
      title: Text(
        certificate.title,
        style: const TextStyle(fontWeight: FontWeight.w700),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 5),
        child: Text(
          '${l10n.issuedBy(certificate.issuer)} · '
          '${l10n.completedIn(certificate.completedOn.year.toString())}',
          style: const TextStyle(color: LeoneBrandColors.mutedInk),
        ),
      ),
      trailing: const Icon(Icons.chevron_right_rounded),
    );
  }
}

class _CertificatePreviewDialog extends StatelessWidget {
  const _CertificatePreviewDialog({required this.certificate});

  final CertificateRecord certificate;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
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
                          style: const TextStyle(
                            color: LeoneBrandColors.mutedInk,
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
                  if (kIsWeb)
                    Link(
                      uri: certificate.archivedPdfUrl,
                      target: LinkTarget.blank,
                      builder: (context, followLink) => OutlinedButton.icon(
                        onPressed: followLink,
                        icon: const Icon(
                          Icons.picture_as_pdf_outlined,
                          size: 18,
                        ),
                        label: Text(l10n.openArchivedPdf),
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
