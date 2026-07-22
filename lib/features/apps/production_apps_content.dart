import 'package:flutter/material.dart';

import '../../brand/leone_brand.dart';
import '../../l10n/app_localizations.dart';
import 'production_app_models.dart';

const _vanCranenbroekGreen = Color(0xFF008932);

class ProductionAppsPresentation {
  const ProductionAppsPresentation({required this.content, required this.apps});

  final ProductionAppsSectionContent content;
  final List<ProductionAppCase> apps;

  factory ProductionAppsPresentation.localized(AppLocalizations l10n) {
    final checked = l10n.storeCheckedJuly2026;
    final googlePlay = Uri.parse('https://play.google.com/store/apps/details');

    Uri playStore(String packageName) =>
        googlePlay.replace(queryParameters: {'id': packageName});

    ProductionAppScreenshot screenshot(
      String appName,
      String path,
      int index, {
      String? caption,
    }) => ProductionAppScreenshot(
      assetPath: path,
      semanticLabel: '$appName · ${l10n.appScreenshotsLabel} ${index + 1}',
      caption: caption,
    );

    ProductionAppStoreProof proof({
      required String appName,
      required String productId,
      String? productLabel,
      required ProductionAppStore store,
      String? evidence,
      required Uri uri,
      String? supportingText,
    }) {
      final resolvedSupportingText =
          supportingText ?? (evidence == null ? null : checked);
      final semanticParts = [
        appName,
        store.displayName,
        ?evidence,
        ?resolvedSupportingText,
      ];
      return ProductionAppStoreProof(
        productId: productId,
        productLabel: productLabel,
        store: store,
        evidence: evidence,
        semanticLabel: semanticParts.join(' · '),
        supportingText: resolvedSupportingText,
        uri: uri,
      );
    }

    const vanName = 'Van Cranenbroek';
    const lyzerName = 'Lyzer Collect + Deliver';
    const magName = 'MAG Venda Digital';
    final vanPlay = playStore('nl.vancranenbroek');
    final vanAppStore = Uri.parse(
      'https://apps.apple.com/nl/app/van-cranenbroek/id6462761167',
    );
    final collectPlay = playStore('tech.lyzer.collect');
    final collectAppStore = Uri.parse(
      'https://apps.apple.com/pt/app/lyzer-collect/id6738952338',
    );
    final deliverPlay = playStore('tech.lyzer.deliver');
    final deliverAppStore = Uri.parse(
      'https://apps.apple.com/br/app/lyzer-deliver/id6748221787',
    );
    final magPlay = playStore('com.mongeralaegon.vendadigital');

    return ProductionAppsPresentation(
      content: ProductionAppsSectionContent(
        semanticLabel: l10n.productionAppsSemanticLabel,
        title: l10n.productionAppsTitle,
        roleLabel: l10n.appRoleLabel,
        contributionLabel: l10n.appContributionLabel,
        stackLabel: l10n.appStackLabel,
        storeProofLabel: l10n.appStoreProofLabel,
        screenshotsLabel: l10n.appScreenshotsLabel,
        imageUnavailableLabel: l10n.appImageUnavailableLabel,
      ),
      apps: [
        ProductionAppCase(
          id: 'van-cranenbroek',
          semanticLabel: '$vanName. ${l10n.vanCranenbroekSummary}',
          name: vanName,
          contextLabel: l10n.vanCranenbroekContext,
          summary: l10n.vanCranenbroekSummary,
          role: l10n.vanCranenbroekRole,
          contribution: l10n.vanCranenbroekContribution,
          stack: const [
            'Flutter',
            'Riverpod',
            'Kotlin',
            'Firebase',
            'Firestore',
            'Python',
            'CI/CD',
          ],
          iconAssetPaths: const ['assets/apps/van-cranenbroek-icon.png'],
          screenshots: [
            screenshot(vanName, 'assets/apps/van-cranenbroek-01.png', 0),
            screenshot(vanName, 'assets/apps/van-cranenbroek-02.png', 1),
            screenshot(vanName, 'assets/apps/van-cranenbroek-03.png', 2),
          ],
          storeProof: [
            proof(
              appName: vanName,
              productId: 'van-cranenbroek',
              store: ProductionAppStore.googlePlay,
              evidence: l10n.vanCranenbroekPlayProof,
              uri: vanPlay,
            ),
            proof(
              appName: vanName,
              productId: 'van-cranenbroek',
              store: ProductionAppStore.appStore,
              evidence: l10n.vanCranenbroekAppStoreProof,
              uri: vanAppStore,
            ),
          ],
          accent: _vanCranenbroekGreen,
        ),
        ProductionAppCase(
          id: 'lyzer-collect-deliver',
          semanticLabel: '$lyzerName. ${l10n.lyzerSummary}',
          name: lyzerName,
          contextLabel: l10n.lyzerContext,
          summary: l10n.lyzerSummary,
          role: l10n.lyzerRole,
          contribution: l10n.lyzerContribution,
          stack: const [
            'Flutter',
            'Android',
            'iOS',
            'Proprietary GetX engine',
            'Offline-first',
            'Barcode',
            '.NET BFF',
            'GraphQL',
          ],
          iconAssetPaths: const [
            'assets/apps/lyzer-collect-icon.png',
            'assets/apps/lyzer-deliver-icon.png',
          ],
          screenshots: [
            screenshot(
              'Lyzer Collect',
              'assets/apps/lyzer-collect-01.png',
              0,
              caption: 'Collect',
            ),
            screenshot(
              'Lyzer Collect',
              'assets/apps/lyzer-collect-02.png',
              1,
              caption: 'Collect',
            ),
            screenshot(
              'Lyzer Deliver',
              'assets/apps/lyzer-deliver-01.png',
              0,
              caption: 'Deliver',
            ),
            screenshot(
              'Lyzer Deliver',
              'assets/apps/lyzer-deliver-02.png',
              1,
              caption: 'Deliver',
            ),
          ],
          storeProof: [
            proof(
              appName: 'Lyzer Collect',
              productId: 'lyzer-collect',
              productLabel: 'Collect',
              store: ProductionAppStore.googlePlay,
              evidence: l10n.lyzerCollectProof,
              uri: collectPlay,
              supportingText: l10n.lyzerCollectProofDetails,
            ),
            proof(
              appName: 'Lyzer Collect',
              productId: 'lyzer-collect',
              productLabel: 'Collect',
              store: ProductionAppStore.appStore,
              uri: collectAppStore,
            ),
            proof(
              appName: 'Lyzer Deliver',
              productId: 'lyzer-deliver',
              productLabel: 'Deliver',
              store: ProductionAppStore.googlePlay,
              evidence: l10n.lyzerDeliverProof,
              uri: deliverPlay,
              supportingText: l10n.lyzerDeliverProofDetails,
            ),
            proof(
              appName: 'Lyzer Deliver',
              productId: 'lyzer-deliver',
              productLabel: 'Deliver',
              store: ProductionAppStore.appStore,
              uri: deliverAppStore,
            ),
          ],
          accent: LeoneBrandColors.editorialWarm,
        ),
        ProductionAppCase(
          id: 'mag-venda-digital',
          semanticLabel: '$magName. ${l10n.magSummary}',
          name: magName,
          contextLabel: l10n.magContext,
          summary: l10n.magSummary,
          role: l10n.magRole,
          contribution: l10n.magContribution,
          stack: const [
            'Android',
            'Java',
            'Kotlin',
            'Realm',
            'Firebase',
            'Azure',
          ],
          iconAssetPaths: const ['assets/apps/mag-venda-digital-icon.jpg'],
          screenshots: [
            screenshot(magName, 'assets/apps/mag-venda-digital-01.jpg', 0),
            screenshot(magName, 'assets/apps/mag-venda-digital-02.jpg', 1),
            screenshot(magName, 'assets/apps/mag-venda-digital-03.jpg', 2),
          ],
          storeProof: [
            proof(
              appName: magName,
              productId: 'mag-venda-digital',
              store: ProductionAppStore.googlePlay,
              evidence: l10n.magPlayProof,
              uri: magPlay,
              supportingText: l10n.magPlayProofDetails,
            ),
          ],
          accent: LeoneBrandColors.intelligence,
        ),
      ],
    );
  }
}
