import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/link.dart';

import '../../brand/leone_brand.dart';
import '../../l10n/l10n.dart';
import '../../telemetry/portfolio_telemetry.dart';
import '../shared/portfolio_section_heading.dart';

class ContactSection extends StatelessWidget {
  const ContactSection({super.key});

  static final _linkedinUri = Uri.parse(
    'https://www.linkedin.com/in/leonedaher/',
  );
  static final _githubUri = Uri.parse('https://github.com/leo-daher');
  static final _calendlyUri = Uri.parse(
    'https://calendly.com/leonedaher/30min',
  );
  static final _whatsAppUri = Uri.parse('https://wa.me/5521999997667');

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final links = <_ContactDestination>[
      _ContactDestination(
        key: const Key('contact-link-linkedin'),
        analyticsId: 'linkedin',
        label: l10n.contactLinkedIn,
        supportingText: l10n.contactLinkedInCopy,
        uri: _linkedinUri,
        iconAsset: 'assets/brand/linkedin-symbol.svg',
      ),
      _ContactDestination(
        key: const Key('contact-link-whatsapp'),
        analyticsId: 'whatsapp',
        label: l10n.contactWhatsApp,
        supportingText: l10n.contactWhatsAppCopy,
        uri: _whatsAppUri,
        iconAsset: 'assets/brand/whatsapp-symbol.svg',
        emphasized: true,
        isLead: true,
      ),
      _ContactDestination(
        key: const Key('contact-link-github'),
        analyticsId: 'github',
        label: l10n.contactGitHub,
        supportingText: l10n.contactGitHubCopy,
        uri: _githubUri,
        iconAsset: 'assets/brand/github-symbol.svg',
      ),
      _ContactDestination(
        key: const Key('contact-link-schedule'),
        analyticsId: 'calendly',
        label: l10n.contactSchedule,
        supportingText: l10n.contactScheduleCopy,
        uri: _calendlyUri,
        icon: Icons.calendar_month_outlined,
        isLead: true,
      ),
    ];

    return Semantics(
      container: true,
      explicitChildNodes: true,
      child: Column(
        key: const Key('contact-section'),
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PortfolioSectionHeading(
            eyebrow: l10n.contactEyebrow,
            title: l10n.contactTitle,
            copy: l10n.contactCopy,
          ),
          const SizedBox(height: 30),
          LayoutBuilder(
            builder: (context, constraints) {
              final columns = constraints.maxWidth >= 1080
                  ? 4
                  : constraints.maxWidth >= 640
                  ? 2
                  : 1;
              const gap = 12.0;
              final width =
                  (constraints.maxWidth - gap * (columns - 1)) / columns;
              return Wrap(
                spacing: gap,
                runSpacing: gap,
                children: [
                  for (final destination in links)
                    SizedBox(
                      width: width,
                      child: _ContactCard(destination: destination),
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

class _ContactDestination {
  const _ContactDestination({
    required this.key,
    required this.analyticsId,
    required this.label,
    required this.supportingText,
    required this.uri,
    this.icon,
    this.iconAsset,
    this.emphasized = false,
    this.isLead = false,
  }) : assert(icon != null || iconAsset != null);

  final Key key;
  final String analyticsId;
  final String label;
  final String supportingText;
  final Uri uri;
  final IconData? icon;
  final String? iconAsset;
  final bool emphasized;
  final bool isLead;
}

class _ContactCard extends StatelessWidget {
  const _ContactCard({required this.destination});

  final _ContactDestination destination;

  @override
  Widget build(BuildContext context) {
    final palette = context.leonePalette;
    final accent = destination.emphasized
        ? LeoneBrandColors.interactive
        : palette.ink;

    return Link(
      key: destination.key,
      uri: destination.uri,
      target: LinkTarget.blank,
      builder: (context, followLink) => Semantics(
        link: true,
        button: true,
        label: '${destination.label}. ${destination.supportingText}',
        child: Material(
          color: destination.emphasized
              ? LeoneBrandColors.interactive.withValues(alpha: .1)
              : palette.surface.withValues(alpha: .72),
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: destination.emphasized
                  ? LeoneBrandColors.interactive.withValues(alpha: .38)
                  : palette.outline,
            ),
            borderRadius: BorderRadius.circular(22),
          ),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: followLink == null
                ? null
                : () {
                    PortfolioTelemetry.contactIntent(
                      destination.analyticsId,
                      destination.uri,
                      isLead: destination.isLead,
                    );
                    followLink();
                  },
            child: ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 132),
              child: Padding(
                padding: const EdgeInsets.all(22),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: accent.withValues(alpha: .1),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: destination.iconAsset == null
                          ? Icon(destination.icon!, color: accent, size: 22)
                          : SvgPicture.asset(
                              destination.iconAsset!,
                              key: Key(
                                'contact-icon-${destination.analyticsId}',
                              ),
                              width: 22,
                              height: 22,
                              colorFilter: ColorFilter.mode(
                                accent,
                                BlendMode.srcIn,
                              ),
                              excludeFromSemantics: true,
                            ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  destination.label,
                                  style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                              Icon(
                                Icons.arrow_outward_rounded,
                                color: accent,
                                size: 18,
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            destination.supportingText,
                            style: TextStyle(
                              color: palette.mutedInk,
                              height: 1.45,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
