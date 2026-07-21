import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vector_graphics/vector_graphics.dart';

import 'features/clients/client_logo_cloud.dart';
import 'features/experience/world_map_geometry.dart';
import 'l10n/l10n.dart';

const _mapAccent = Color(0xFF51F2C2);
const _darkPanel = Color(0xFF0D171D);
const _worldMapBaseLoader = AssetBytesLoader(
  'assets/maps/world-map-base.svg.vec',
);

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
    name: 'Singapura',
    location: 'Jurong Shipyard, Singapura',
    role: 'Arquitetura de modulos eletricos',
    summary:
        'Pela Radix, detalhamento de arquitetura dos modulos do FPSO Pioneiro de Libra, com requisicoes de material, especificacoes tecnicas e cotacoes de materiais e servicos de engenharia.',
    yearRange: '2015 - 2016',
    anchor: Offset(0.793, 0.706),
    projects: [
      PortfolioProject(
        logo: 'RDX',
        name: 'FPSO Pioneiro de Libra - modulos eletricos',
        description:
            'Entrega para GE Oil & Gas / GE Power Conversion, Odebrecht Oil & Gas e Jurong Shipyard. CNPC e CNOOC aparecem como participantes chinesas do consorcio, nao como local de atuacao.',
      ),
    ],
  ),
];

List<PortfolioCountry> _localizedPortfolioCountries(BuildContext context) {
  if (Localizations.localeOf(context).languageCode != 'en') {
    return _portfolioCountries;
  }
  return const [
    PortfolioCountry(
      isoCode: 'BR',
      mapId: 'br',
      name: 'Brazil',
      location: 'Rio de Janeiro / São Paulo',
      role: 'Mobile, full-stack and robotics',
      summary:
          'Projects in insurance, computer vision, robotics and public systems.',
      yearRange: '2019 - present',
      anchor: Offset(0.33, 0.69),
      projects: [
        PortfolioProject(
          logo: 'MAG',
          name: 'MAG / Mongeral Aegon',
          description:
              'Insurance sales app using Java/Kotlin, Realm, Firebase and CI/CD.',
        ),
        PortfolioProject(
          logo: 'HR',
          name: 'Human Robotics / Robios',
          description:
              'Face detection and mask classification using Camera2, TensorFlow and MQTT.',
        ),
        PortfolioProject(
          logo: 'VIS',
          name: 'Visagio',
          description:
              'Public-network allocation system using Python, Django, React and OR-Tools.',
        ),
      ],
    ),
    PortfolioCountry(
      isoCode: 'US',
      mapId: 'us',
      name: 'United States',
      location: 'Remote projects',
      role: 'Field operations and Flutter',
      summary:
          'Remote projects for field operations, maps, dynamic forms and mobile products.',
      yearRange: 'remote',
      anchor: Offset(0.23, 0.44),
      projects: [
        PortfolioProject(
          logo: '495',
          name: 'Code 495',
          description:
              'Offline-first infrastructure mapping, map clustering and configurable forms.',
        ),
        PortfolioProject(
          logo: 'LL',
          name: 'Linelinker Pro',
          description:
              'US project included as an editable portfolio entry based on supplied context.',
        ),
      ],
    ),
    PortfolioCountry(
      isoCode: 'PT',
      mapId: 'pt',
      name: 'Portugal',
      location: 'Lisbon',
      role: 'Logistics, government and utilities',
      summary:
          'Projects in logistics back offices, tracking, requirements, backend support and infrastructure.',
      yearRange: '2022 - present',
      anchor: Offset(0.455, 0.45),
      projects: [
        PortfolioProject(
          logo: 'CTT',
          name: 'CTT Correios de Portugal',
          description:
              'Android/Kotlin tracking, scanners, Zebra, Firebase and offline use by postal workers.',
        ),
        PortfolioProject(
          logo: 'LYZ',
          name: 'Lyzer',
          description:
              '.NET Backend for Frontend, GraphQL and logistics workflows for retail/e-commerce.',
        ),
        PortfolioProject(
          logo: 'ADP',
          name: 'Águas de Portugal',
          description:
              'Requirements, business rules and backend support with PHP/Laravel/Python.',
        ),
        PortfolioProject(
          logo: 'ADM',
          name: 'Águas de Monchique',
          description:
              'Docker infrastructure built from scratch for frontend, backend and database.',
        ),
      ],
    ),
    PortfolioCountry(
      isoCode: 'ES',
      mapId: 'es',
      name: 'Spain',
      location: 'Madrid / Iberian operations',
      role: 'Energy and tracking',
      summary:
          'Experience tied to Iberian operations in renewable energy and tracking.',
      yearRange: '2022 - 2024',
      anchor: Offset(0.47, 0.46),
      projects: [
        PortfolioProject(
          logo: 'CTT',
          name: 'CTT',
          description:
              'Tracking project also associated with Spain in the supplied context.',
        ),
        PortfolioProject(
          logo: 'IBD',
          name: 'Iberdrola',
          description:
              'Renewable-energy sales system using Laravel, Vue, PWA and anti-fraud protection.',
        ),
      ],
    ),
    PortfolioCountry(
      isoCode: 'NL',
      mapId: 'nl',
      name: 'Netherlands',
      location: 'Van Cranenbroek',
      role: 'Retail mobile and backend',
      summary:
          'Catalog and sales app using Flutter/Kotlin, SVG maps, Firebase and a Python backend.',
      yearRange: '2023 - present',
      anchor: Offset(0.49, 0.39),
      projects: [
        PortfolioProject(
          logo: 'VCB',
          name: 'Van Cranenbroek',
          description:
              'Hybrid Kotlin/Flutter app, CI/CD, Firebase, Firestore, deep links, SVG maps and Python Cloud Functions.',
        ),
      ],
    ),
    PortfolioCountry(
      isoCode: 'SG',
      mapId: 'sg',
      name: 'Singapore',
      location: 'Jurong Shipyard, Singapore',
      role: 'Electrical-module architecture',
      summary:
          'At Radix, detailed architecture work for the FPSO Pioneiro de Libra modules, including material requisitions, technical specifications, and quotations for materials and engineering services.',
      yearRange: '2015 - 2016',
      anchor: Offset(0.793, 0.706),
      projects: [
        PortfolioProject(
          logo: 'RDX',
          name: 'FPSO Pioneiro de Libra - electrical modules',
          description:
              'Delivery for GE Oil & Gas / GE Power Conversion, Odebrecht Oil & Gas and Jurong Shipyard. CNPC and CNOOC were Chinese consortium participants, not a work location.',
        ),
      ],
    ),
  ];
}

final Map<String, PortfolioCountry> _portfolioCountryById = {
  for (final country in _portfolioCountries) country.mapId: country,
};

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
  String _selectedCountryId = _portfolioCountries.first.mapId;
  String? _hoveredCountryId;

  @override
  Widget build(BuildContext context) {
    final countries = _localizedPortfolioCountries(context);
    final singaporeCountry = countries.firstWhere(
      (country) => country.mapId == 'sg',
    );
    final selectedCountry = countries.firstWhere(
      (country) => country.mapId == _selectedCountryId,
    );
    final hoveredCountry = _hoveredCountryId == null
        ? null
        : countries.firstWhere((country) => country.mapId == _hoveredCountryId);
    final activeCountry = hoveredCountry ?? selectedCountry;
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
            activeCountry: activeCountry,
            elevatedCountry: hoveredCountry,
            selectedCountry: selectedCountry,
            singaporeCountry: singaporeCountry,
            onCountryHover: _setHoveredCountry,
            onHoverExit: () => _setHoveredCountry(null),
            onCountryTap: _selectCountry,
          ),
        );

        final detail = _CountryDetailPanel(
          activeCountry: activeCountry,
          selectedCountry: selectedCountry,
          countries: countries,
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
                    const ClientLogoCloud(),
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
    setState(() => _selectedCountryId = country.mapId);
  }

  void _setHoveredCountry(PortfolioCountry? country) {
    if (_hoveredCountryId == country?.mapId) {
      return;
    }

    setState(() => _hoveredCountryId = country?.mapId);
  }
}

class _MapStage extends StatelessWidget {
  const _MapStage({
    required this.activeCountry,
    required this.elevatedCountry,
    required this.selectedCountry,
    required this.singaporeCountry,
    required this.onCountryHover,
    required this.onHoverExit,
    required this.onCountryTap,
  });

  final PortfolioCountry activeCountry;
  final PortfolioCountry? elevatedCountry;
  final PortfolioCountry selectedCountry;
  final PortfolioCountry singaporeCountry;
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
            final mapRect = worldMapRectFor(size);
            final singaporeInset = _singaporeInsetGeometryFor(mapRect, size);
            final connector = _connectorGeometryFor(
              activeCountry,
              mapRect,
              size,
              singaporeInset: singaporeInset,
            );

            return MouseRegion(
              cursor: SystemMouseCursors.click,
              onHover: (event) {
                onCountryHover(
                  singaporeInset.lensRect.contains(event.localPosition)
                      ? singaporeCountry
                      : _countryAt(event.localPosition, size),
                );
              },
              onExit: (_) => onHoverExit(),
              child: GestureDetector(
                onTapUp: (details) {
                  final country =
                      singaporeInset.lensRect.contains(details.localPosition)
                      ? singaporeCountry
                      : _countryAt(details.localPosition, size);
                  if (country != null) {
                    onCountryTap(country);
                  }
                },
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Positioned.fromRect(
                      rect: mapRect,
                      child: const RepaintBoundary(
                        key: Key('world-map-base-boundary'),
                        child: VectorGraphic(
                          key: Key('world-map-base-vector'),
                          loader: _worldMapBaseLoader,
                          fit: BoxFit.fill,
                          excludeFromSemantics: true,
                        ),
                      ),
                    ),
                    RepaintBoundary(
                      key: const Key('world-map-overlay-boundary'),
                      child: CustomPaint(
                        key: const Key('world-map-interactive-overlay'),
                        isComplex: false,
                        willChange: false,
                        painter: _InteractiveWorldMapPainter(
                          activeCountryId: activeCountry.mapId,
                          elevatedCountryId: elevatedCountry?.mapId,
                          selectedCountryId: selectedCountry.mapId,
                        ),
                      ),
                    ),
                    CustomPaint(
                      painter: _SingaporeInsetConnectorPainter(
                        geometry: singaporeInset,
                        active: activeCountry.mapId == 'sg',
                      ),
                    ),
                    CustomPaint(
                      painter: _ConnectorPainter(geometry: connector),
                    ),
                    Positioned.fromRect(
                      rect: connector.railRect,
                      child: _LogoRail(country: activeCountry),
                    ),
                    Positioned.fromRect(
                      rect: singaporeInset.lensRect,
                      child: _SingaporeMapInset(
                        key: const Key('world-map-singapore-inset'),
                        country: singaporeCountry,
                        active: activeCountry.mapId == 'sg',
                        selected: selectedCountry.mapId == 'sg',
                        onTap: () => onCountryTap(singaporeCountry),
                      ),
                    ),
                    Positioned(
                      left: 14,
                      top: 14,
                      child: _MapBadge(
                        key: Key('world-map-badge-${activeCountry.mapId}'),
                        country: activeCountry,
                      ),
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

class _SingaporeMapInset extends StatelessWidget {
  const _SingaporeMapInset({
    super.key,
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
    final borderColor = active || selected
        ? _mapAccent
        : Colors.white.withValues(alpha: 0.52);

    return Semantics(
      button: true,
      label: '${country.name}: ${country.location}',
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: RepaintBoundary(
          child: DecoratedBox(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF061015),
              border: Border.all(color: borderColor, width: active ? 2 : 1.2),
              boxShadow: [
                BoxShadow(
                  color: _mapAccent.withValues(alpha: active ? 0.24 : 0.1),
                  blurRadius: active ? 24 : 14,
                  spreadRadius: active ? 2 : 0,
                ),
              ],
            ),
            child: ClipOval(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final diameter = constraints.maxWidth;
                  final mapWidth = diameter * 7.6;
                  final mapHeight =
                      mapWidth /
                      (worldMapSourceSize.width / worldMapSourceSize.height);
                  final mapLeft =
                      (diameter / 2) - (mapWidth * country.anchor.dx);
                  final mapTop =
                      (diameter / 2) - (mapHeight * country.anchor.dy);

                  return Stack(
                    fit: StackFit.expand,
                    children: [
                      const ColoredBox(color: Color(0xFF07131A)),
                      Positioned(
                        left: mapLeft,
                        top: mapTop,
                        width: mapWidth,
                        height: mapHeight,
                        child: const SvgPicture(
                          _worldMapBaseLoader,
                          fit: BoxFit.fill,
                          excludeFromSemantics: true,
                        ),
                      ),
                      DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: RadialGradient(
                            colors: [
                              Colors.transparent,
                              const Color(0xFF02070A).withValues(alpha: 0.36),
                            ],
                            stops: const [0.48, 1],
                          ),
                        ),
                      ),
                      Center(
                        child: Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _mapAccent,
                            border: Border.all(color: Colors.white, width: 1.4),
                            boxShadow: [
                              BoxShadow(
                                color: _mapAccent.withValues(alpha: 0.7),
                                blurRadius: 10,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        right: 8,
                        top: 8,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: const Color(
                              0xFF061015,
                            ).withValues(alpha: 0.88),
                            border: Border.all(
                              color: _mapAccent.withValues(alpha: 0.65),
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            child: Text(
                              'SG',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 9,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 0.7,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
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
  const _MapBadge({super.key, required this.country});

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
              '${country.name} · ${context.l10n.projectCount(country.projectCount)}',
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
          context.l10n.mappedCountries,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: const Color(0xFF9CB4BA),
            fontWeight: FontWeight.w800,
            letterSpacing: 0,
          ),
        ),
        const SizedBox(height: 8),
        for (final country in countries) ...[
          _CountryListRow(
            key: Key('world-map-country-${country.mapId}'),
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
                child: _SelectedCountryCard(
                  key: Key('selected-country-${activeCountry.mapId}'),
                  country: activeCountry,
                ),
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
            _SelectedCountryCard(
              key: Key('selected-country-${activeCountry.mapId}'),
              country: activeCountry,
            ),
            const SizedBox(height: 14),
            countryList,
          ],
        );
      },
    );
  }
}

class _SelectedCountryCard extends StatelessWidget {
  const _SelectedCountryCard({super.key, required this.country});

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
                  label: context.l10n.context,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _MiniMetric(
                  icon: Icons.auto_awesome_motion_outlined,
                  value: country.projectCount.toString(),
                  label: context.l10n.projects.toLowerCase(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            context.l10n.projects,
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
    super.key,
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

class _InteractiveWorldMapPainter extends CustomPainter {
  const _InteractiveWorldMapPainter({
    required this.activeCountryId,
    required this.elevatedCountryId,
    required this.selectedCountryId,
  });

  final String activeCountryId;
  final String? elevatedCountryId;
  final String selectedCountryId;

  @override
  void paint(Canvas canvas, Size size) {
    final mapRect = worldMapRectFor(size);
    final scaleX = mapRect.width / worldMapSourceSize.width;
    final scaleY = mapRect.height / worldMapSourceSize.height;
    final logicalScale = (scaleX + scaleY) / 2;
    final projectStroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1 / logicalScale
      ..color = _mapAccent.withValues(alpha: 0.9);
    final fill = Paint()
      ..style = PaintingStyle.fill
      ..color = _mapAccent.withValues(alpha: 0.74);
    final activeFill = Paint()
      ..style = PaintingStyle.fill
      ..color = _mapAccent.withValues(alpha: 0.95);
    final geometry = PortfolioWorldMapGeometry.shared;

    canvas.save();
    canvas.translate(mapRect.left, mapRect.top);
    canvas.scale(scaleX, scaleY);

    for (final countryId in geometry.countryIds) {
      if (countryId == elevatedCountryId) continue;

      final path = geometry.pathFor(countryId)!;
      final isActive = countryId == activeCountryId;
      canvas.drawPath(path, isActive ? activeFill : fill);
      canvas.drawPath(path, projectStroke);
    }

    final elevatedPath = elevatedCountryId == null
        ? null
        : geometry.pathFor(elevatedCountryId!);
    if (elevatedPath != null) {
      final raised = elevatedPath.shift(Offset(0, -5 / scaleY));
      canvas.drawShadow(
        raised,
        _mapAccent.withValues(alpha: 0.85),
        16 / logicalScale,
        true,
      );
      canvas.drawPath(raised, activeFill);
      canvas.drawPath(raised, projectStroke);
    }
    canvas.restore();

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
  bool shouldRepaint(_InteractiveWorldMapPainter oldDelegate) {
    return oldDelegate.activeCountryId != activeCountryId ||
        oldDelegate.elevatedCountryId != elevatedCountryId ||
        oldDelegate.selectedCountryId != selectedCountryId;
  }
}

class _SingaporeInsetConnectorPainter extends CustomPainter {
  const _SingaporeInsetConnectorPainter({
    required this.geometry,
    required this.active,
  });

  final _SingaporeInsetGeometry geometry;
  final bool active;

  @override
  void paint(Canvas canvas, Size size) {
    final towardsAnchor = geometry.anchor - geometry.center;
    final distance = towardsAnchor.distance;
    if (distance == 0) return;

    final lensEdge =
        geometry.center +
        (towardsAnchor / distance) * (geometry.lensRect.width / 2);
    final path = Path()
      ..moveTo(geometry.anchor.dx, geometry.anchor.dy)
      ..lineTo(lensEdge.dx, lensEdge.dy);
    final glow = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = active ? 5 : 3
      ..strokeCap = StrokeCap.round
      ..color = _mapAccent.withValues(alpha: active ? 0.16 : 0.07);
    final line = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = active ? 1.8 : 1.2
      ..strokeCap = StrokeCap.round
      ..color = _mapAccent.withValues(alpha: active ? 0.9 : 0.48);

    canvas.drawPath(path, glow);
    canvas.drawPath(path, line);
    canvas.drawCircle(
      geometry.anchor,
      active ? 4 : 3,
      Paint()..color = _mapAccent,
    );
    canvas.drawCircle(
      geometry.anchor,
      active ? 8 : 6,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1
        ..color = _mapAccent.withValues(alpha: active ? 0.72 : 0.36),
    );
  }

  @override
  bool shouldRepaint(_SingaporeInsetConnectorPainter oldDelegate) {
    return oldDelegate.active != active ||
        oldDelegate.geometry.anchor != geometry.anchor ||
        oldDelegate.geometry.center != geometry.center ||
        oldDelegate.geometry.lensRect != geometry.lensRect;
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

class _SingaporeInsetGeometry {
  const _SingaporeInsetGeometry({
    required this.anchor,
    required this.center,
    required this.lensRect,
  });

  final Offset anchor;
  final Offset center;
  final Rect lensRect;
}

PortfolioCountry? _countryAt(Offset position, Size size) {
  final countryId = PortfolioWorldMapGeometry.shared.hitTest(
    position,
    worldMapRectFor(size),
  );
  return countryId == null ? null : _portfolioCountryById[countryId];
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
  Size panelSize, {
  required _SingaporeInsetGeometry singaporeInset,
}) {
  final start = country.mapId == 'sg'
      ? singaporeInset.center
      : _anchorFor(country.mapId, mapRect) ?? Offset(panelSize.width / 2, 40);
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

_SingaporeInsetGeometry _singaporeInsetGeometryFor(
  Rect mapRect,
  Size panelSize,
) {
  final anchor = _anchorFor('sg', mapRect) ?? mapRect.center;
  final preferredDiameter = panelSize.width >= 720 ? 92.0 : 76.0;
  final diameter = math.min(
    preferredDiameter,
    math.max(44, math.min(panelSize.width - 28, panelSize.height - 28)),
  );
  final radius = diameter / 2;
  final verticalOffsetFactor = panelSize.width < 600 ? 1.45 : 0.96;
  final center = _clampOffset(
    anchor + Offset(-diameter * 0.8, -diameter * verticalOffsetFactor),
    Rect.fromLTRB(
      radius + 14,
      radius + 14,
      panelSize.width - radius - 14,
      panelSize.height - radius - 14,
    ),
  );

  return _SingaporeInsetGeometry(
    anchor: anchor,
    center: center,
    lensRect: Rect.fromCircle(center: center, radius: radius),
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
