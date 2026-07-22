import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:leone_portfolio/brand/leone_brand.dart';
import 'package:leone_portfolio/features/apps/production_apps.dart';
import 'package:url_launcher/link.dart';

const _content = ProductionAppsSectionContent(
  semanticLabel: 'Apps em produção em que atuei',
  eyebrow: 'APPS EM PRODUÇÃO',
  title: 'Produtos publicados, trabalho verificável.',
  description:
      'Aplicativos e operações digitais em que contribuí com engenharia.',
  roleLabel: 'Papel',
  contributionLabel: 'Contribuição',
  stackLabel: 'Stack',
  storeProofLabel: 'Prova da loja',
  screenshotsLabel: 'Telas do aplicativo',
  imageUnavailableLabel: 'Imagem indisponível',
);

void main() {
  testWidgets(
    'renders the three supplied production cases and their evidence',
    (tester) async {
      await _pumpSection(tester, size: const Size(1440, 2200));

      expect(find.text('Van Cranenbroek'), findsOneWidget);
      expect(find.text('Lyzer Collect+Deliver'), findsOneWidget);
      expect(find.text('MAG Venda Digital'), findsOneWidget);
      expect(find.textContaining('4,6 ★ · 120 avaliações'), findsOneWidget);
      expect(find.textContaining('Flutter'), findsWidgets);
      expect(find.text('Stack'), findsNothing);
      expect(find.text('Prova da loja'), findsNothing);

      expect(
        find.bySemanticsLabel('Apps em produção em que atuei'),
        findsOneWidget,
      );
      expect(
        find.bySemanticsLabel('Case do app Van Cranenbroek'),
        findsOneWidget,
      );
      expect(
        find.bySemanticsLabel(RegExp('Tela de ofertas do Van Cranenbroek')),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'uses horizontal case rows on desktop and stacked rows on mobile',
    (tester) async {
      await _pumpSection(tester, size: const Size(1440, 2200));

      final vanWide = tester.getRect(
        find.byKey(const Key('production-app-card-van-cranenbroek')),
      );
      final lyzerWide = tester.getRect(
        find.byKey(const Key('production-app-card-lyzer-collect-deliver')),
      );
      final magWide = tester.getRect(
        find.byKey(const Key('production-app-card-mag-venda-digital')),
      );
      expect(lyzerWide.top, greaterThan(vanWide.bottom));
      expect(magWide.top, greaterThan(lyzerWide.bottom));
      expect(vanWide.width, closeTo(lyzerWide.width, .01));
      expect(lyzerWide.width, closeTo(magWide.width, .01));

      final galleryWide = tester.getRect(
        find.byKey(const Key('production-app-screenshots-van-cranenbroek')),
      );
      final contentWide = tester.getRect(
        find.byKey(const Key('production-app-content-van-cranenbroek')),
      );
      expect(galleryWide.right, lessThan(contentWide.left));

      await _pumpSection(tester, size: const Size(390, 3600));

      final vanNarrow = tester.getRect(
        find.byKey(const Key('production-app-card-van-cranenbroek')),
      );
      final lyzerNarrow = tester.getRect(
        find.byKey(const Key('production-app-card-lyzer-collect-deliver')),
      );
      final magNarrow = tester.getRect(
        find.byKey(const Key('production-app-card-mag-venda-digital')),
      );
      expect(vanNarrow.width, closeTo(342, .01));
      expect(lyzerNarrow.top, greaterThan(vanNarrow.bottom));
      expect(magNarrow.top, greaterThan(lyzerNarrow.bottom));
      final galleryNarrow = tester.getRect(
        find.byKey(const Key('production-app-screenshots-van-cranenbroek')),
      );
      final contentNarrow = tester.getRect(
        find.byKey(const Key('production-app-content-van-cranenbroek')),
      );
      expect(galleryNarrow.bottom, lessThan(contentNarrow.top));
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('exposes compact store proof as a native link control', (
    tester,
  ) async {
    await _pumpSection(tester, size: const Size(1440, 2200));

    final storeProof = find.byKey(
      const Key('production-app-store-proof-van-cranenbroek-0'),
    );
    final storeLink = tester.widget<Link>(
      find.descendant(of: storeProof, matching: find.byType(Link)),
    );
    expect(storeLink.uri, Uri.parse('https://example.com/van/store'));
    expect(storeLink.target, LinkTarget.blank);
    expect(find.byType(ListTile), findsNothing);
    expect(find.byType(Chip), findsNothing);
    expect(tester.getSize(storeProof).height, greaterThanOrEqualTo(48));
    expect(tester.takeException(), isNull);
  });

  testWidgets('keeps a localized fallback inside an invalid screenshot frame', (
    tester,
  ) async {
    await _pumpSection(
      tester,
      size: const Size(600, 1400),
      apps: [
        _apps().first.copyWithScreenshots(const [
          ProductionAppScreenshot(
            assetPath: 'assets/apps/missing.png',
            semanticLabel: 'Tela que não foi encontrada',
          ),
        ]),
      ],
    );
    await tester.pumpAndSettle();

    expect(find.text('Imagem indisponível'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

Future<void> _pumpSection(
  WidgetTester tester, {
  required Size size,
  List<ProductionAppCase>? apps,
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  await tester.pumpWidget(
    MaterialApp(
      theme: LeoneBrandTheme.dark(),
      home: Scaffold(
        body: SingleChildScrollView(
          child: ProductionAppsSection(
            content: _content,
            apps: apps ?? _apps(),
          ),
        ),
      ),
    ),
  );
  await tester.pump();
}

List<ProductionAppCase> _apps() => [
  ProductionAppCase(
    id: 'van-cranenbroek',
    semanticLabel: 'Case do app Van Cranenbroek',
    name: 'Van Cranenbroek',
    contextLabel: 'Retail mobile · Países Baixos',
    summary: 'Aplicativo de catálogo e vendas usado em uma operação de varejo.',
    role: 'Contribuição em engenharia mobile e integração de produto.',
    contribution:
        'Atuação em fluxos híbridos, mapas SVG, dados sincronizados e entrega contínua.',
    stack: const ['Flutter', 'Kotlin', 'Firebase', 'Python'],
    screenshots: const [
      ProductionAppScreenshot(
        assetPath: 'assets/client_logos/human_robotics.png',
        semanticLabel: 'Tela de ofertas do Van Cranenbroek',
        caption: 'Ofertas',
      ),
    ],
    storeProof: [
      ProductionAppStoreProof(
        storeName: 'Google Play',
        evidence: '4,6 ★ · 120 avaliações',
        semanticLabel:
            'Van Cranenbroek na Google Play, 4,6 estrelas e 120 avaliações',
        supportingText: 'consultado em julho de 2026',
        uri: Uri.parse('https://example.com/van/store'),
      ),
    ],
  ),
  ProductionAppCase(
    id: 'lyzer-collect-deliver',
    semanticLabel: 'Case do app Lyzer Collect+Deliver',
    name: 'Lyzer Collect+Deliver',
    contextLabel: 'Logística · Retail e e-commerce',
    summary:
        'Fluxos operacionais de coleta e entrega conectados ao backoffice.',
    role: 'Contribuição em produto mobile e integração de serviços.',
    contribution:
        'Atuação em workflows logísticos e contratos entre aplicativo, BFF e GraphQL.',
    stack: const ['Flutter', '.NET', 'GraphQL'],
    screenshots: const [
      ProductionAppScreenshot(
        assetPath: 'assets/client_logos/human_robotics.png',
        semanticLabel: 'Tela de coleta do Lyzer Collect+Deliver',
      ),
    ],
  ),
  ProductionAppCase(
    id: 'mag-venda-digital',
    semanticLabel: 'Case do app MAG Venda Digital',
    name: 'MAG Venda Digital',
    contextLabel: 'Seguros · Venda assistida',
    summary: 'Aplicativo de apoio ao processo comercial e à venda de seguros.',
    role: 'Contribuição em engenharia Android e evolução do produto.',
    contribution:
        'Atuação em jornadas de venda, persistência local, integrações e CI/CD.',
    stack: const ['Android', 'Java', 'Kotlin', 'Realm', 'Firebase'],
    screenshots: const [
      ProductionAppScreenshot(
        assetPath: 'assets/client_logos/human_robotics.png',
        semanticLabel: 'Tela da jornada de venda MAG',
      ),
    ],
  ),
];

extension on ProductionAppCase {
  ProductionAppCase copyWithScreenshots(
    List<ProductionAppScreenshot> screenshots,
  ) => ProductionAppCase(
    id: id,
    semanticLabel: semanticLabel,
    name: name,
    contextLabel: contextLabel,
    summary: summary,
    role: role,
    contribution: contribution,
    stack: stack,
    iconAssetPaths: iconAssetPaths,
    screenshots: screenshots,
    storeProof: storeProof,
    accent: accent,
  );
}
