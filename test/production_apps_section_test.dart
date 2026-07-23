import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:leone_portfolio/brand/leone_brand.dart';
import 'package:leone_portfolio/features/apps/production_apps.dart';
import 'package:leone_portfolio/l10n/app_localizations_en.dart';
import 'package:url_launcher/link.dart';

const _content = ProductionAppsSectionContent(
  semanticLabel: 'Apps em produção em que atuei',
  title: 'Apps em produção.',
  roleLabel: 'Papel',
  contributionLabel: 'Contribuição',
  stackLabel: 'Stack',
  storeProofLabel: 'Prova da loja',
  screenshotsLabel: 'Telas do aplicativo',
  imageUnavailableLabel: 'Imagem indisponível',
);

void main() {
  test('keeps platform and state-management metadata explicit', () {
    final apps = ProductionAppsPresentation.localized(
      AppLocalizationsEn(),
    ).apps;
    final van = apps.singleWhere((app) => app.id == 'van-cranenbroek');
    final lyzer = apps.singleWhere((app) => app.id == 'lyzer-collect-deliver');
    final mag = apps.singleWhere((app) => app.id == 'mag-venda-digital');

    expect(van.stack, contains('Riverpod'));
    expect(van.contribution, contains('Flutter with Riverpod'));
    expect(lyzer.contextLabel, contains('Android and iOS'));
    expect(
      lyzer.stack,
      containsAll(<String>[
        'Flutter',
        'Android',
        'iOS',
        'Proprietary GetX engine',
      ]),
    );
    expect(lyzer.contribution, contains('proprietary GetX-based engine'));
    expect(van.accent, const Color(0xFF008932));
    expect(
      van.storeProof
          .singleWhere((proof) => proof.store == ProductionAppStore.appStore)
          .evidence,
      '4.7 ★ · 143 ratings · 6,511 first-time downloads',
    );
    expect(lyzer.accent, LeoneBrandColors.editorialWarm);
    expect(mag.accent, LeoneBrandColors.intelligence);
    expect(lyzer.storeProof, hasLength(4));
    expect(
      lyzer.storeProof
          .where((proof) => proof.store == ProductionAppStore.appStore)
          .map((proof) => proof.evidence),
      everyElement(isNull),
    );
    expect(mag.storeProof.single.evidence, '1K+ downloads');
    expect(
      lyzer.storeProof.map((proof) => (proof.productId, proof.store)).toSet(),
      {
        ('lyzer-collect', ProductionAppStore.googlePlay),
        ('lyzer-collect', ProductionAppStore.appStore),
        ('lyzer-deliver', ProductionAppStore.googlePlay),
        ('lyzer-deliver', ProductionAppStore.appStore),
      },
    );
    expect(
      lyzer.storeProof
          .singleWhere(
            (proof) =>
                proof.productId == 'lyzer-collect' &&
                proof.store == ProductionAppStore.appStore,
          )
          .uri,
      Uri.parse('https://apps.apple.com/pt/app/lyzer-collect/id6738952338'),
    );
    expect(
      lyzer.storeProof
          .singleWhere(
            (proof) =>
                proof.productId == 'lyzer-deliver' &&
                proof.store == ProductionAppStore.appStore,
          )
          .uri,
      Uri.parse('https://apps.apple.com/br/app/lyzer-deliver/id6748221787'),
    );
  });

  testWidgets(
    'renders the three supplied production cases and their evidence',
    (tester) async {
      await _pumpSection(tester, size: const Size(1440, 2200));

      expect(find.text('Van Cranenbroek'), findsOneWidget);
      expect(find.text('Apps em produção.'), findsOneWidget);
      expect(find.text('APPS EM PRODUÇÃO'), findsNothing);
      expect(find.text('Lyzer Collect+Deliver'), findsOneWidget);
      expect(find.text('MAG Venda Digital'), findsOneWidget);
      expect(find.textContaining('4,6 ★', findRichText: true), findsOneWidget);
      expect(find.textContaining('Flutter'), findsWidgets);
      expect(find.textContaining('Riverpod'), findsOneWidget);
      expect(find.textContaining('Proprietary GetX engine'), findsOneWidget);
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
      final headingNarrow = tester.getRect(
        find.byKey(const Key('production-app-heading-van-cranenbroek')),
      );
      final contentNarrow = tester.getRect(
        find.byKey(const Key('production-app-content-van-cranenbroek')),
      );
      expect(headingNarrow.bottom, lessThan(galleryNarrow.top));
      expect(galleryNarrow.bottom, lessThan(contentNarrow.top));
      expect(galleryNarrow.height, closeTo(224, .01));
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('exposes compact store proof as a native link control', (
    tester,
  ) async {
    await _pumpSection(tester, size: const Size(1440, 2200));

    final storeProof = find.byKey(
      const Key(
        'production-app-store-proof-van-cranenbroek-van-cranenbroek-googlePlay',
      ),
    );
    final storeLink = tester.widget<Link>(
      find.descendant(of: storeProof, matching: find.byType(Link)),
    );
    expect(storeLink.uri, Uri.parse('https://example.com/van/store'));
    expect(storeLink.target, LinkTarget.blank);
    expect(find.byType(ListTile), findsNothing);
    expect(find.byType(Chip), findsNothing);
    expect(find.byIcon(Icons.verified_outlined), findsNothing);
    expect(find.byIcon(Icons.play_arrow_rounded), findsOneWidget);
    expect(tester.getSize(storeProof).height, greaterThanOrEqualTo(48));
    expect(tester.getSize(storeProof).height, lessThan(80));
    expect(tester.takeException(), isNull);
  });

  testWidgets('links both Lyzer products to Google Play and the App Store', (
    tester,
  ) async {
    final lyzer = ProductionAppsPresentation.localized(
      AppLocalizationsEn(),
    ).apps.singleWhere((app) => app.id == 'lyzer-collect-deliver');
    await _pumpSection(tester, size: const Size(1440, 1500), apps: [lyzer]);

    final collectAppStore = find.byKey(
      const Key(
        'production-app-store-proof-lyzer-collect-deliver-lyzer-collect-appStore',
      ),
    );
    final deliverAppStore = find.byKey(
      const Key(
        'production-app-store-proof-lyzer-collect-deliver-lyzer-deliver-appStore',
      ),
    );
    final collectLink = tester.widget<Link>(
      find.descendant(of: collectAppStore, matching: find.byType(Link)),
    );
    final deliverLink = tester.widget<Link>(
      find.descendant(of: deliverAppStore, matching: find.byType(Link)),
    );

    expect(
      collectLink.uri,
      Uri.parse('https://apps.apple.com/pt/app/lyzer-collect/id6738952338'),
    );
    expect(
      deliverLink.uri,
      Uri.parse('https://apps.apple.com/br/app/lyzer-deliver/id6748221787'),
    );
    expect(find.text('COLLECT'), findsNWidgets(2));
    expect(find.text('DELIVER'), findsNWidgets(2));
    expect(find.text('APP STORE'), findsNWidgets(2));
    expect(find.byIcon(Icons.apple), findsNWidgets(2));
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
    stack: const ['Flutter', 'Riverpod', 'Kotlin', 'Firebase', 'Python'],
    screenshots: const [
      ProductionAppScreenshot(
        assetPath: 'assets/client_logos/human_robotics.png',
        semanticLabel: 'Tela de ofertas do Van Cranenbroek',
      ),
      ProductionAppScreenshot(
        assetPath: 'assets/client_logos/human_robotics.png',
        semanticLabel: 'Tela do catálogo do Van Cranenbroek',
      ),
      ProductionAppScreenshot(
        assetPath: 'assets/client_logos/human_robotics.png',
        semanticLabel: 'Tela de lojas do Van Cranenbroek',
      ),
    ],
    storeProof: [
      ProductionAppStoreProof(
        productId: 'van-cranenbroek',
        store: ProductionAppStore.googlePlay,
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
        'Atuação em uma engine proprietária baseada em GetX, workflows logísticos e contratos entre aplicativo, BFF e GraphQL.',
    stack: const [
      'Flutter',
      'Android',
      'iOS',
      'Proprietary GetX engine',
      'Offline-first',
      '.NET BFF',
      'GraphQL',
    ],
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
