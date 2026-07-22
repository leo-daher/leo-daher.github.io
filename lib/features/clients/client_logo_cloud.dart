import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../brand/leone_brand.dart';
import '../../l10n/l10n.dart';
import '../shared/portfolio_section_heading.dart';

const _clientAccent = Color(0xFF51F2C2);

const _clientLogos = <_ClientLogo>[
  _ClientLogo(
    name: 'MAG Seguros',
    asset: 'assets/client_logos/mag-official.svg',
  ),
  _ClientLogo(
    name: 'Human Robotics',
    asset: 'assets/client_logos/human_robotics.png',
    contrastOutline: true,
  ),
  _ClientLogo(name: 'Visagio', asset: 'assets/client_logos/visagio.svg'),
  _ClientLogo(
    name: 'Code 495',
    asset: 'assets/client_logos/code-495-symbol.svg',
    showName: true,
  ),
  _ClientLogo(name: 'CTT', asset: 'assets/client_logos/ctt-official.svg'),
  _ClientLogo(
    name: 'Lyzer',
    asset: 'assets/client_logos/lyzer-official.svg',
    contrastOutline: true,
  ),
  _ClientLogo(
    name: 'Águas de Portugal',
    asset: 'assets/client_logos/adp-official.svg',
    contrastOutline: true,
  ),
  _ClientLogo(
    name: 'Água Monchique',
    asset: 'assets/client_logos/agua-monchique-official.svg',
    contrastOutline: true,
  ),
  _ClientLogo(
    name: 'Iberdrola',
    asset: 'assets/client_logos/iberdrola-official.svg',
  ),
  _ClientLogo(
    name: 'Van Cranenbroek',
    asset: 'assets/client_logos/van-cranenbroek-full.svg',
  ),
  _ClientLogo(name: 'Radix', asset: 'assets/client_logos/radix.png'),
  _ClientLogo(
    name: 'EY',
    asset: 'assets/client_logos/ey-official.svg',
    contrastOutline: true,
  ),
  _ClientLogo(
    name: 'Fullsix',
    asset: 'assets/client_logos/fullsix-black.png',
    scale: 3,
    offset: Offset(0, 7),
    lightMonochrome: true,
  ),
];

class ClientLogoCloud extends StatelessWidget {
  const ClientLogoCloud({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 1100
            ? 5
            : constraints.maxWidth >= 720
            ? 4
            : constraints.maxWidth >= 440
            ? 3
            : 2;
        const gap = 10.0;
        final tileWidth =
            (constraints.maxWidth - gap * (columns - 1)) / columns;

        return Column(
          key: const Key('client-logo-cloud'),
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PortfolioSectionHeading(
              eyebrow: context.l10n.clientsServed,
              title: context.l10n.clientsTitle,
              copy: context.l10n.clientsCopy,
            ),
            const SizedBox(height: 24),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                context.l10n.brandCount(_clientLogos.length),
                style: const TextStyle(
                  color: _clientAccent,
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: gap,
              runSpacing: gap,
              children: [
                for (final logo in _clientLogos)
                  _ClientLogoTile(logo: logo, width: tileWidth),
              ],
            ),
          ],
        );
      },
    );
  }
}

class _ClientLogo {
  const _ClientLogo({
    required this.name,
    this.asset,
    this.showName = false,
    this.scale = 1,
    this.offset = Offset.zero,
    this.lightMonochrome = false,
    this.contrastOutline = false,
  });

  final String name;
  final String? asset;
  final bool showName;
  final double scale;
  final Offset offset;
  final bool lightMonochrome;
  final bool contrastOutline;
}

class _ClientLogoTile extends StatelessWidget {
  const _ClientLogoTile({required this.logo, required this.width});

  final _ClientLogo logo;
  final double width;

  @override
  Widget build(BuildContext context) {
    final palette = context.leonePalette;
    final visual = logo.contrastOutline
        ? _OutlinedClientLogo(logo: logo)
        : _ClientLogoAsset(
            logo: logo,
            tint: logo.lightMonochrome ? palette.ink : null,
          );

    return Semantics(
      label: logo.name,
      image: true,
      child: Container(
        width: width,
        height: 78,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: palette.outline),
        ),
        child: logo.showName
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(child: visual),
                  const SizedBox(width: 10),
                  Text(
                    logo.name,
                    style: TextStyle(
                      color: palette.ink,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              )
            : ClipRect(
                child: Center(
                  child: Transform.translate(
                    offset: logo.offset,
                    child: Transform.scale(scale: logo.scale, child: visual),
                  ),
                ),
              ),
      ),
    );
  }
}

class _OutlinedClientLogo extends StatelessWidget {
  const _OutlinedClientLogo({required this.logo});

  final _ClientLogo logo;

  static const _offsets = <Offset>[
    Offset(-0.55, 0),
    Offset(0.55, 0),
    Offset(0, -0.55),
    Offset(0, 0.55),
  ];

  @override
  Widget build(BuildContext context) {
    final palette = context.leonePalette;
    return Stack(
      fit: StackFit.expand,
      children: [
        for (final offset in _offsets)
          Transform.translate(
            offset: offset,
            child: _ClientLogoAsset(
              logo: logo,
              tint: palette.ink.withValues(alpha: .3),
            ),
          ),
        _ClientLogoAsset(logo: logo),
      ],
    );
  }
}

class _ClientLogoAsset extends StatelessWidget {
  const _ClientLogoAsset({required this.logo, this.tint});

  final _ClientLogo logo;
  final Color? tint;

  @override
  Widget build(BuildContext context) {
    final palette = context.leonePalette;
    final asset = logo.asset;
    if (asset == null) {
      return Center(
        child: Text(
          logo.name.toUpperCase(),
          textAlign: TextAlign.center,
          style: TextStyle(
            color: tint ?? palette.ink,
            fontSize: 12,
            fontWeight: FontWeight.w900,
            letterSpacing: .6,
          ),
        ),
      );
    }

    if (asset.endsWith('.svg')) {
      return SvgPicture.asset(
        asset,
        fit: BoxFit.contain,
        semanticsLabel: logo.name,
        colorFilter: tint == null
            ? null
            : ColorFilter.mode(tint!, BlendMode.srcIn),
      );
    }

    return Image.asset(
      asset,
      fit: BoxFit.contain,
      color: tint,
      colorBlendMode: tint == null ? null : BlendMode.srcIn,
      errorBuilder: (context, _, _) => Center(
        child: Text(
          logo.name,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: tint ?? palette.ink,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}
