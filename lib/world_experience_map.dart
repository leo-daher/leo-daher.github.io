import 'dart:math' as math;

import 'package:countries_world_map/countries_world_map.dart';
import 'package:countries_world_map/data/maps/world_map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

const _mapAccent = Color(0xFF51F2C2);
const _darkPanel = Color(0xFF0D171D);
const _outline = Color(0xFF42606B);

final MapAttributes _worldAttributes = MapAttributes(
  SMapWorld.instructionsMercator,
);
final List<_CountryShape> _worldShapes = _worldAttributes.drawingInstructions
    .map(_CountryShape.fromJson)
    .toList(growable: false);

const _portfolioCountries = <PortfolioCountry>[
  PortfolioCountry(
    isoCode: 'BR',
    mapId: 'br',
    name: 'Brasil',
    location: 'Rio de Janeiro / Sao Paulo',
    role: 'Mobile, full-stack e robotics',
    summary:
        'Projetos em seguros, visao computacional, robotics e sistemas publicos.',
    yearRange: '2019 - atual',
    anchor: Offset(0.33, 0.69),
    projects: [
      PortfolioProject(
        logo: 'MAG',
        name: 'MAG / Mongeral Aegon',
        description:
            'App de vendas de seguros em Java/Kotlin, Realm, Firebase e CI/CD.',
      ),
      PortfolioProject(
        logo: 'HR',
        name: 'Human Robotics / Robios',
        description:
            'Face detection e classificacao de mascara com Camera2, TensorFlow e MQTT.',
      ),
      PortfolioProject(
        logo: 'VIS',
        name: 'Visagio',
        description:
            'Sistema de alocacao para rede publica usando Python, Django, React e OR-Tools.',
      ),
    ],
  ),
  PortfolioCountry(
    isoCode: 'US',
    mapId: 'us',
    name: 'Estados Unidos',
    location: 'Projetos remotos',
    role: 'Field ops e Flutter',
    summary:
        'Projetos remotos para operacao em campo, mapas, formularios dinamicos e produto mobile.',
    yearRange: 'remoto',
    anchor: Offset(0.23, 0.44),
    projects: [
      PortfolioProject(
        logo: '495',
        name: 'Code 495',
        description:
            'Mapeamento de infraestrutura offline-first, clustering em mapa e formularios configuraveis.',
      ),
      PortfolioProject(
        logo: 'LL',
        name: 'Linelinker Pro',
        description:
            'Projeto informado para os EUA; manter como entrada editavel do portfolio.',
      ),
    ],
  ),
  PortfolioCountry(
    isoCode: 'PT',
    mapId: 'pt',
    name: 'Portugal',
    location: 'Lisboa',
    role: 'Logistica, governo e utilities',
    summary:
        'Projetos em backoffice logistico, tracking, requisitos, backend support e infraestrutura.',
    yearRange: '2022 - atual',
    anchor: Offset(0.455, 0.45),
    projects: [
      PortfolioProject(
        logo: 'CTT',
        name: 'CTT Correios de Portugal',
        description:
            'Tracking Android/Kotlin, scanners, Zebra, Firebase e uso offline por carteiros.',
      ),
      PortfolioProject(
        logo: 'LYZ',
        name: 'Lyzer',
        description:
            '.NET Backend for Frontend, GraphQL e workflows logisticos para retail/e-commerce.',
      ),
      PortfolioProject(
        logo: 'ADP',
        name: 'Aguas de Portugal',
        description:
            'Levantamento de requisitos, regras de negocio e suporte backend com PHP/Laravel/Python.',
      ),
      PortfolioProject(
        logo: 'ADM',
        name: 'Aguas de Monchique',
        description:
            'Infraestrutura Docker do zero para frontend, backend e banco de dados.',
      ),
    ],
  ),
  PortfolioCountry(
    isoCode: 'ES',
    mapId: 'es',
    name: 'Espanha',
    location: 'Madrid / operacao Iberica',
    role: 'Energia e tracking',
    summary:
        'Experiencias associadas a operacoes ibericas em energia renovavel e tracking.',
    yearRange: '2022 - 2024',
    anchor: Offset(0.47, 0.46),
    projects: [
      PortfolioProject(
        logo: 'CTT',
        name: 'CTT',
        description:
            'Projeto de tracking tambem associado a Espanha conforme contexto informado.',
      ),
      PortfolioProject(
        logo: 'IBD',
        name: 'Iberdrola',
        description:
            'Sistema de vendas de energia renovavel com Laravel, Vue, PWA e protecao antifraude.',
      ),
    ],
  ),
  PortfolioCountry(
    isoCode: 'NL',
    mapId: 'nl',
    name: 'Holanda',
    location: 'Van Cranenbroek',
    role: 'Retail mobile e backend',
    summary:
        'Aplicacao de catalogo/vendas com Flutter/Kotlin, mapas SVG, Firebase e backend Python.',
    yearRange: '2023 - atual',
    anchor: Offset(0.49, 0.39),
    projects: [
      PortfolioProject(
        logo: 'VCB',
        name: 'Van Cranenbroek',
        description:
            'App hibrido Kotlin/Flutter, CI/CD, Firebase, Firestore, deeplinks, mapas SVG e Cloud Functions em Python.',
      ),
    ],
  ),
  PortfolioCountry(
    isoCode: 'SG',
    mapId: 'sg',
    name: 'Cingapura',
    location: 'FPSO Libra',
    role: 'Estagio Radix',
    summary:
        'Atuacao internacional associada ao FPSO Libra durante o estagio na Radix.',
    yearRange: 'estagio',
    anchor: Offset(0.745, 0.61),
    projects: [
      PortfolioProject(
        logo: 'RDX',
        name: 'FPSO Libra / Radix',
        description:
            'Projeto de estagio com contexto internacional em Cingapura, conforme informado.',
      ),
    ],
  ),
  PortfolioCountry(
    isoCode: 'CN',
    mapId: 'cn',
    name: 'China',
    location: 'FPSO Libra',
    role: 'Estagio Radix',
    summary:
        'Atuacao internacional associada ao FPSO Libra durante o estagio na Radix.',
    yearRange: 'estagio',
    anchor: Offset(0.75, 0.47),
    projects: [
      PortfolioProject(
        logo: 'RDX',
        name: 'FPSO Libra / Radix',
        description:
            'Projeto de estagio com contexto internacional na China, conforme informado.',
      ),
    ],
  ),
];

final Map<String, PortfolioCountry> _portfolioCountryById = {
  for (final country in _portfolioCountries) country.mapId: country,
};

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

class PortfolioProject {
  const PortfolioProject({
    required this.logo,
    required this.name,
    required this.description,
  });

  final String logo;
  final String name;
  final String description;
}

class PortfolioCountry {
  const PortfolioCountry({
    required this.isoCode,
    required this.mapId,
    required this.name,
    required this.location,
    required this.role,
    required this.summary,
    required this.yearRange,
    required this.anchor,
    required this.projects,
  });

  final String isoCode;
  final String mapId;
  final String name;
  final String location;
  final String role;
  final String summary;
  final String yearRange;
  final Offset anchor;
  final List<PortfolioProject> projects;

  int get projectCount => projects.length;
}

class WorldExperienceMap extends StatefulWidget {
  const WorldExperienceMap({super.key});

  @override
  State<WorldExperienceMap> createState() => _WorldExperienceMapState();
}

class _WorldExperienceMapState extends State<WorldExperienceMap> {
  late PortfolioCountry _selectedCountry = _portfolioCountries.first;
  PortfolioCountry? _hoveredCountry;

  PortfolioCountry get _activeCountry => _hoveredCountry ?? _selectedCountry;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth >= 940;
        final mapHeight = wide
            ? 640.0
            : constraints.maxWidth >= 600
            ? 440.0
            : 280.0;

        final map = SizedBox(
          height: mapHeight,
          child: _MapStage(
            activeCountry: _activeCountry,
            elevatedCountry: _hoveredCountry,
            selectedCountry: _selectedCountry,
            onCountryHover: _setHoveredCountry,
            onHoverExit: () => _setHoveredCountry(null),
            onCountryTap: _selectCountry,
          ),
        );

        final detail = _CountryDetailPanel(
          activeCountry: _activeCountry,
          selectedCountry: _selectedCountry,
          countries: _portfolioCountries,
          onSelect: _selectCountry,
        );

        return Container(
          decoration: BoxDecoration(
            color: _darkPanel,
            border: Border.all(color: Colors.white.withValues(alpha: 0.09)),
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.25),
                blurRadius: 30,
                offset: const Offset(0, 18),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              map,
              Padding(
                padding: EdgeInsets.all(wide ? 18 : 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: wide ? 4 : 2),
                    detail,
                    SizedBox(height: wide ? 26 : 20),
                    Divider(
                      color: Colors.white.withValues(alpha: .09),
                      height: 1,
                    ),
                    SizedBox(height: wide ? 22 : 18),
                    const _ClientLogoCloud(),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _selectCountry(PortfolioCountry country) {
    setState(() => _selectedCountry = country);
  }

  void _setHoveredCountry(PortfolioCountry? country) {
    if (_hoveredCountry == country) {
      return;
    }

    setState(() => _hoveredCountry = country);
  }
}

class _MapStage extends StatelessWidget {
  const _MapStage({
    required this.activeCountry,
    required this.elevatedCountry,
    required this.selectedCountry,
    required this.onCountryHover,
    required this.onHoverExit,
    required this.onCountryTap,
  });

  final PortfolioCountry activeCountry;
  final PortfolioCountry? elevatedCountry;
  final PortfolioCountry selectedCountry;
  final ValueChanged<PortfolioCountry?> onCountryHover;
  final VoidCallback onHoverExit;
  final ValueChanged<PortfolioCountry> onCountryTap;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF04080D), Color(0xFF0A1720)],
          ),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final size = Size(constraints.maxWidth, constraints.maxHeight);
            final mapRect = _mapRectFor(size);
            final connector = _connectorGeometryFor(
              activeCountry,
              mapRect,
              size,
            );

            return MouseRegion(
              cursor: SystemMouseCursors.click,
              onHover: (event) {
                onCountryHover(_countryAt(event.localPosition, size));
              },
              onExit: (_) => onHoverExit(),
              child: GestureDetector(
                onTapUp: (details) {
                  final country = _countryAt(details.localPosition, size);
                  if (country != null) {
                    onCountryTap(country);
                  }
                },
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CustomPaint(
                      painter: _DarkWorldMapPainter(
                        activeCountryId: activeCountry.mapId,
                        elevatedCountryId: elevatedCountry?.mapId,
                        selectedCountryId: selectedCountry.mapId,
                      ),
                    ),
                    CustomPaint(
                      painter: _ConnectorPainter(geometry: connector),
                    ),
                    Positioned.fromRect(
                      rect: connector.railRect,
                      child: _LogoRail(country: activeCountry),
                    ),
                    Positioned(
                      left: 14,
                      top: 14,
                      child: _MapBadge(country: activeCountry),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _LogoRail extends StatelessWidget {
  const _LogoRail({required this.country});

  final PortfolioCountry country;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFF061015).withValues(alpha: 0.86),
        border: Border.all(color: _mapAccent.withValues(alpha: 0.42)),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: _mapAccent.withValues(alpha: 0.11),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Row(
          children: [
            for (final project in country.projects) ...[
              Tooltip(
                message: project.name,
                child: _LogoMark(project: project),
              ),
              if (project != country.projects.last) const SizedBox(width: 8),
            ],
          ],
        ),
      ),
    );
  }
}

class _LogoMark extends StatelessWidget {
  const _LogoMark({required this.project});

  final PortfolioProject project;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42,
      height: 34,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: _mapAccent.withValues(alpha: 0.1),
        border: Border.all(color: _mapAccent.withValues(alpha: 0.7)),
        borderRadius: BorderRadius.circular(7),
      ),
      child: Text(
        project.logo,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: _mapAccent,
          fontWeight: FontWeight.w900,
          letterSpacing: 0,
        ),
      ),
    );
  }
}

class _MapBadge extends StatelessWidget {
  const _MapBadge({required this.country});

  final PortfolioCountry country;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFF061015).withValues(alpha: 0.82),
        border: Border.all(color: _mapAccent.withValues(alpha: 0.34)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.place_outlined, color: _mapAccent, size: 18),
            const SizedBox(width: 8),
            Text(
              '${country.name} · ${country.projectCount} projetos',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                letterSpacing: 0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ClientLogoCloud extends StatelessWidget {
  const _ClientLogoCloud();

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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  'CLIENTES ATENDIDOS',
                  style: TextStyle(
                    color: _mapAccent,
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.4,
                  ),
                ),
                const Spacer(),
                Text(
                  '${_clientLogos.length} MARCAS',
                  style: const TextStyle(
                    color: Color(0xFF9CB4BA),
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
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

class _ClientLogoTile extends StatelessWidget {
  const _ClientLogoTile({required this.logo, required this.width});

  final _ClientLogo logo;
  final double width;

  @override
  Widget build(BuildContext context) {
    final visual = logo.contrastOutline
        ? _OutlinedClientLogo(logo: logo)
        : _ClientLogoAsset(
            logo: logo,
            tint: logo.lightMonochrome ? Colors.white : null,
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
          border: Border.all(color: Colors.white.withValues(alpha: .07)),
        ),
        child: logo.showName
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(child: visual),
                  const SizedBox(width: 10),
                  Text(
                    logo.name,
                    style: const TextStyle(
                      color: Colors.white,
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
    return Stack(
      fit: StackFit.expand,
      children: [
        for (final offset in _offsets)
          Transform.translate(
            offset: offset,
            child: _ClientLogoAsset(
              logo: logo,
              tint: Colors.white.withValues(alpha: .3),
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
    final asset = logo.asset;
    if (asset == null) {
      return Center(
        child: Text(
          logo.name.toUpperCase(),
          textAlign: TextAlign.center,
          style: TextStyle(
            color: tint ?? Colors.white,
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
            color: tint ?? Colors.white,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}

class _CountryDetailPanel extends StatelessWidget {
  const _CountryDetailPanel({
    required this.activeCountry,
    required this.selectedCountry,
    required this.countries,
    required this.onSelect,
  });

  final PortfolioCountry activeCountry;
  final PortfolioCountry selectedCountry;
  final List<PortfolioCountry> countries;
  final ValueChanged<PortfolioCountry> onSelect;

  @override
  Widget build(BuildContext context) {
    final countryList = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Paises mapeados',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: const Color(0xFF9CB4BA),
            fontWeight: FontWeight.w800,
            letterSpacing: 0,
          ),
        ),
        const SizedBox(height: 8),
        for (final country in countries) ...[
          _CountryListRow(
            country: country,
            active: country.mapId == activeCountry.mapId,
            selected: country.mapId == selectedCountry.mapId,
            onTap: () => onSelect(country),
          ),
          if (country != countries.last) const SizedBox(height: 8),
        ],
      ],
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 820) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 7,
                child: _SelectedCountryCard(country: activeCountry),
              ),
              const SizedBox(width: 18),
              Expanded(flex: 5, child: countryList),
            ],
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            _SelectedCountryCard(country: activeCountry),
            const SizedBox(height: 14),
            countryList,
          ],
        );
      },
    );
  }
}

class _SelectedCountryCard extends StatelessWidget {
  const _SelectedCountryCard({required this.country});

  final PortfolioCountry country;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF091219),
        border: Border.all(color: _mapAccent.withValues(alpha: 0.18)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                width: 12,
                height: 42,
                decoration: BoxDecoration(
                  color: _mapAccent,
                  borderRadius: BorderRadius.circular(6),
                  boxShadow: [
                    BoxShadow(
                      color: _mapAccent.withValues(alpha: 0.34),
                      blurRadius: 16,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      country.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0,
                          ),
                    ),
                    Text(
                      '${country.location} · ${country.isoCode}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: const Color(0xFF9CB4BA),
                        letterSpacing: 0,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Text(
            country.role,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              letterSpacing: 0,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            country.summary,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: const Color(0xFFC6D6D8),
              height: 1.35,
              letterSpacing: 0,
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: _MiniMetric(
                  icon: Icons.calendar_month_outlined,
                  value: country.yearRange,
                  label: 'contexto',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _MiniMetric(
                  icon: Icons.auto_awesome_motion_outlined,
                  value: country.projectCount.toString(),
                  label: 'projetos',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Projetos',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: _mapAccent,
              fontWeight: FontWeight.w800,
              letterSpacing: 0,
            ),
          ),
          const SizedBox(height: 8),
          for (final project in country.projects) ...[
            _ProjectDetailRow(project: project),
            if (project != country.projects.last) const SizedBox(height: 8),
          ],
        ],
      ),
    );
  }
}

class _ProjectDetailRow extends StatelessWidget {
  const _ProjectDetailRow({required this.project});

  final PortfolioProject project;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.055),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              project.name,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                letterSpacing: 0,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              project.description,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: const Color(0xFFC6D6D8),
                height: 1.3,
                letterSpacing: 0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniMetric extends StatelessWidget {
  const _MiniMetric({
    required this.icon,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 18, color: _mapAccent),
            const SizedBox(height: 8),
            Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                letterSpacing: 0,
              ),
            ),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: const Color(0xFF9CB4BA),
                letterSpacing: 0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CountryListRow extends StatelessWidget {
  const _CountryListRow({
    required this.country,
    required this.active,
    required this.selected,
    required this.onTap,
  });

  final PortfolioCountry country;
  final bool active;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final borderColor = active
        ? _mapAccent
        : selected
        ? _mapAccent.withValues(alpha: 0.4)
        : Colors.white.withValues(alpha: 0.08);

    return Material(
      color: active
          ? _mapAccent.withValues(alpha: 0.1)
          : Colors.white.withValues(alpha: 0.035),
      shape: RoundedRectangleBorder(
        side: BorderSide(color: borderColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
          child: Row(
            children: [
              Container(
                width: 10,
                height: 32,
                decoration: BoxDecoration(
                  color: _mapAccent,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      country.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0,
                      ),
                    ),
                    Text(
                      country.role,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: const Color(0xFF9CB4BA),
                        letterSpacing: 0,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                country.projectCount.toString(),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: _mapAccent,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DarkWorldMapPainter extends CustomPainter {
  const _DarkWorldMapPainter({
    required this.activeCountryId,
    required this.elevatedCountryId,
    required this.selectedCountryId,
  });

  final String activeCountryId;
  final String? elevatedCountryId;
  final String selectedCountryId;

  @override
  void paint(Canvas canvas, Size size) {
    final mapRect = _mapRectFor(size);
    final baseStroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.75
      ..color = _outline.withValues(alpha: 0.55);
    final projectStroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = _mapAccent.withValues(alpha: 0.9);
    final fill = Paint()
      ..style = PaintingStyle.fill
      ..color = _mapAccent.withValues(alpha: 0.74);
    final activeFill = Paint()
      ..style = PaintingStyle.fill
      ..color = _mapAccent.withValues(alpha: 0.95);

    for (final shape in _worldShapes) {
      final path = _pathForShape(shape, mapRect);
      if (!_portfolioCountryById.containsKey(shape.id)) {
        canvas.drawPath(path, baseStroke);
        continue;
      }

      if (shape.id == elevatedCountryId) {
        continue;
      }

      final isActive = shape.id == activeCountryId;
      canvas.drawPath(path, isActive ? activeFill : fill);
      canvas.drawPath(path, projectStroke);
    }

    if (elevatedCountryId != null) {
      for (final shape in _worldShapes.where(
        (s) => s.id == elevatedCountryId,
      )) {
        final path = _pathForShape(shape, mapRect);
        final raised = path.shift(const Offset(0, -5));
        canvas.drawShadow(raised, _mapAccent.withValues(alpha: 0.85), 16, true);
        canvas.drawPath(raised, activeFill);
        canvas.drawPath(raised, projectStroke);
      }
    }

    final selectedAnchor = _anchorFor(selectedCountryId, mapRect);
    if (selectedAnchor != null) {
      canvas.drawCircle(
        selectedAnchor,
        4,
        Paint()..color = Colors.white.withValues(alpha: 0.85),
      );
      canvas.drawCircle(
        selectedAnchor,
        8,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.2
          ..color = _mapAccent.withValues(alpha: 0.72),
      );
    }
  }

  @override
  bool shouldRepaint(_DarkWorldMapPainter oldDelegate) {
    return oldDelegate.activeCountryId != activeCountryId ||
        oldDelegate.elevatedCountryId != elevatedCountryId ||
        oldDelegate.selectedCountryId != selectedCountryId;
  }
}

class _ConnectorPainter extends CustomPainter {
  const _ConnectorPainter({required this.geometry});

  final _ConnectorGeometry geometry;

  @override
  void paint(Canvas canvas, Size size) {
    final shadow = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..color = _mapAccent.withValues(alpha: 0.12);
    final line = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..color = _mapAccent.withValues(alpha: 0.9);
    final path = Path()
      ..moveTo(geometry.start.dx, geometry.start.dy)
      ..lineTo(geometry.elbow.dx, geometry.elbow.dy)
      ..lineTo(geometry.end.dx, geometry.end.dy);

    canvas.drawPath(path, shadow);
    canvas.drawPath(path, line);
    canvas.drawCircle(geometry.start, 4, Paint()..color = _mapAccent);
    canvas.drawCircle(geometry.end, 3, Paint()..color = _mapAccent);
  }

  @override
  bool shouldRepaint(_ConnectorPainter oldDelegate) {
    return oldDelegate.geometry != geometry;
  }
}

class _ConnectorGeometry {
  const _ConnectorGeometry({
    required this.start,
    required this.elbow,
    required this.end,
    required this.railRect,
  });

  final Offset start;
  final Offset elbow;
  final Offset end;
  final Rect railRect;
}

class _CountryShape {
  const _CountryShape({required this.id, required this.instructions});

  factory _CountryShape.fromJson(Map<String, dynamic> json) {
    return _CountryShape(
      id: json['u'] as String,
      instructions: List<String>.from(json['i'] as List),
    );
  }

  final String id;
  final List<String> instructions;
}

PortfolioCountry? _countryAt(Offset position, Size size) {
  final mapRect = _mapRectFor(size);
  if (!mapRect.contains(position)) {
    return null;
  }

  for (final shape in _worldShapes.reversed) {
    final country = _portfolioCountryById[shape.id];
    if (country == null) {
      continue;
    }

    if (_pathForShape(shape, mapRect).contains(position)) {
      return country;
    }
  }

  return null;
}

Rect _mapRectFor(Size size) {
  final mapAspect = _worldAttributes.mapWidth / _worldAttributes.mapHeight;
  final availableAspect = size.width / size.height;
  late final Rect fittedMap;

  if (availableAspect > mapAspect) {
    final width = size.height * mapAspect;
    fittedMap = Rect.fromLTWH((size.width - width) / 2, 0, width, size.height);
  } else {
    final height = size.width / mapAspect;
    fittedMap = Rect.fromLTWH(
      0,
      (size.height - height) / 2,
      size.width,
      height,
    );
  }

  const zoom = 1.55;
  return Rect.fromCenter(
    center: fittedMap.center,
    width: fittedMap.width * zoom,
    height: fittedMap.height * zoom,
  );
}

Path _pathForShape(_CountryShape shape, Rect mapRect) {
  final path = Path();

  for (final instruction in shape.instructions) {
    if (instruction == 'c') {
      path.close();
      continue;
    }

    final coordinates = instruction.substring(1).split(',');
    final x = mapRect.left + mapRect.width * double.parse(coordinates[0]);
    final y = mapRect.top + mapRect.height * double.parse(coordinates[1]);

    if (instruction[0] == 'm') {
      path.moveTo(x, y);
    } else if (instruction[0] == 'l') {
      path.lineTo(x, y);
    }
  }

  return path;
}

Offset? _anchorFor(String countryId, Rect mapRect) {
  final country = _portfolioCountryById[countryId];
  if (country == null) {
    return null;
  }

  return Offset(
    mapRect.left + mapRect.width * country.anchor.dx,
    mapRect.top + mapRect.height * country.anchor.dy,
  );
}

_ConnectorGeometry _connectorGeometryFor(
  PortfolioCountry country,
  Rect mapRect,
  Size panelSize,
) {
  final start =
      _anchorFor(country.mapId, mapRect) ?? Offset(panelSize.width / 2, 40);
  final railWidth = math.min(
    math.max(88.0, 60.0 + (country.projects.length * 50.0)),
    math.max(160.0, panelSize.width - 36.0),
  );
  const railHeight = 52.0;
  final goesRight = country.anchor.dx < 0.64;
  final direction = goesRight ? 1.0 : -1.0;
  final elbow = _clampOffset(
    start + Offset(direction * 68, -39),
    Rect.fromLTWH(18, 18, panelSize.width - 36, panelSize.height - 36),
  );

  var railLeft = goesRight ? elbow.dx + 86 : elbow.dx - 86 - railWidth;
  railLeft = _clampDouble(railLeft, 18, panelSize.width - railWidth - 18);
  final railTop = _clampDouble(
    elbow.dy - (railHeight / 2),
    18,
    panelSize.height - railHeight - 18,
  );
  final railRect = Rect.fromLTWH(railLeft, railTop, railWidth, railHeight);
  final end = Offset(
    goesRight ? railRect.left : railRect.right,
    railRect.center.dy,
  );

  return _ConnectorGeometry(
    start: start,
    elbow: elbow,
    end: end,
    railRect: railRect,
  );
}

Offset _clampOffset(Offset offset, Rect rect) {
  return Offset(
    _clampDouble(offset.dx, rect.left, rect.right),
    _clampDouble(offset.dy, rect.top, rect.bottom),
  );
}

double _clampDouble(double value, double min, double max) {
  if (max < min) {
    return min;
  }

  return value.clamp(min, max).toDouble();
}
