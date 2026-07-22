import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../brand/leone_brand.dart';
import '../../l10n/l10n.dart';
import '../shared/portfolio_section_heading.dart';

const _clientAccent = Color(0xFF51F2C2);
const _visagioOriginalInk = Color(0xFFD6D5C9);
const _visagioLightInk = Color(0xFF00363D);

const _directClientLogos = <_ClientLogo>[
  _ClientLogo(
    id: 'mag-seguros',
    name: 'MAG Seguros',
    asset: 'assets/client_logos/mag-official.svg',
  ),
  _ClientLogo(
    id: 'human-robotics',
    name: 'Human Robotics',
    asset: 'assets/client_logos/human_robotics.png',
    contrastOutline: true,
  ),
  _ClientLogo(
    id: 'visagio',
    name: 'Visagio',
    asset: 'assets/client_logos/visagio.svg',
    lightColorMapper: _VisagioLightColorMapper(),
  ),
  _ClientLogo(
    id: 'radix',
    name: 'Radix',
    asset: 'assets/client_logos/radix.png',
  ),
  _ClientLogo(
    id: 'conkord',
    name: 'Conkord',
    asset: 'assets/client_logos/conkord-official.svg',
  ),
];

const _latituddeClientLogos = <_ClientLogo>[
  _ClientLogo(
    id: 'van-cranenbroek',
    name: 'Van Cranenbroek',
    asset: 'assets/client_logos/van-cranenbroek-full.svg',
  ),
  _ClientLogo(
    id: 'lyzer',
    name: 'Lyzer',
    asset: 'assets/client_logos/lyzer-official.svg',
    contrastOutline: true,
  ),
  _ClientLogo(
    id: 'ctt',
    name: 'CTT',
    asset: 'assets/client_logos/ctt-official.svg',
  ),
  _ClientLogo(
    id: 'ey',
    name: 'EY',
    asset: 'assets/client_logos/ey-official.svg',
    contrastOutline: true,
  ),
  _ClientLogo(
    id: 'iberdrola',
    name: 'Iberdrola',
    asset: 'assets/client_logos/iberdrola-official.svg',
  ),
  _ClientLogo(
    id: 'aguas-de-portugal',
    name: 'Águas de Portugal',
    asset: 'assets/client_logos/adp-official.svg',
    contrastOutline: true,
  ),
  _ClientLogo(
    id: 'agua-monchique',
    name: 'Água Monchique',
    asset: 'assets/client_logos/agua-monchique-official.svg',
    contrastOutline: true,
  ),
  _ClientLogo(
    id: 'fullsix',
    name: 'Fullsix',
    asset: 'assets/client_logos/fullsix-black.png',
    scale: 3,
    offset: Offset(0, 7),
    lightMonochrome: true,
  ),
  _ClientLogo(
    id: 'code-495',
    name: 'Code 495',
    asset: 'assets/client_logos/code-495-symbol.svg',
    showName: true,
  ),
  _ClientLogo(
    id: 'ascendi',
    name: 'Ascendi',
    asset: 'assets/client_logos/ascendi-official.svg',
    contrastOutline: true,
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
            PortfolioSectionHeading(title: context.l10n.clientsTitle),
            const SizedBox(height: 26),
            _ClientLogoGroup(
              key: const Key('client-logo-group-direct'),
              title: context.l10n.directRoles,
              logos: _directClientLogos,
              tileWidth: tileWidth,
              gap: gap,
            ),
            const SizedBox(height: 30),
            _ClientLogoGroup(
              key: const Key('client-logo-group-latitudde'),
              title: context.l10n.viaLatituddeConsulting,
              logos: _latituddeClientLogos,
              tileWidth: tileWidth,
              gap: gap,
            ),
          ],
        );
      },
    );
  }
}

class _ClientLogo {
  const _ClientLogo({
    required this.id,
    required this.name,
    this.asset,
    this.showName = false,
    this.scale = 1,
    this.offset = Offset.zero,
    this.lightMonochrome = false,
    this.contrastOutline = false,
    this.lightColorMapper,
  });

  final String id;
  final String name;
  final String? asset;
  final bool showName;
  final double scale;
  final Offset offset;
  final bool lightMonochrome;
  final bool contrastOutline;
  final ColorMapper? lightColorMapper;
}

class _VisagioLightColorMapper extends ColorMapper {
  const _VisagioLightColorMapper();

  @override
  Color substitute(
    String? id,
    String elementName,
    String attributeName,
    Color color,
  ) => color == _visagioOriginalInk ? _visagioLightInk : color;
}

class _ClientLogoGroup extends StatelessWidget {
  const _ClientLogoGroup({
    super.key,
    required this.title,
    required this.logos,
    required this.tileWidth,
    required this.gap,
  });

  final String title;
  final List<_ClientLogo> logos;
  final double tileWidth;
  final double gap;

  @override
  Widget build(BuildContext context) {
    final palette = context.leonePalette;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: _clientAccent,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1,
                ),
              ),
            ),
            Text(
              context.l10n.brandCount(logos.length),
              style: TextStyle(
                color: palette.mutedInk,
                fontSize: 9.5,
                fontWeight: FontWeight.w700,
                letterSpacing: .7,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: gap,
          runSpacing: gap,
          children: [
            for (final logo in logos)
              _ClientLogoTile(logo: logo, width: tileWidth),
          ],
        ),
      ],
    );
  }
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
      key: Key('client-logo-${logo.id}'),
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
      final useLightMapper =
          tint == null && Theme.of(context).brightness == Brightness.light;
      return SvgPicture.asset(
        asset,
        fit: BoxFit.contain,
        semanticsLabel: logo.name,
        colorMapper: useLightMapper ? logo.lightColorMapper : null,
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
