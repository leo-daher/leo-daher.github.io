import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:leone_portfolio/brand/leone_brand.dart';
import 'package:leone_portfolio/features/apps/production_apps.dart';
import 'package:leone_portfolio/l10n/app_localizations_en.dart';

void main() {
  testWidgets(
    'shows four compact featured apps and opens an app detail route',
    (tester) async {
      await _pumpStorefront(tester, size: const Size(390, 1000));

      expect(
        find.byKey(const Key('production-apps-storefront')),
        findsOneWidget,
      );
      expect(
        find.byKey(const Key('app-store-tile-van-cranenbroek')),
        findsOneWidget,
      );
      expect(
        find.byKey(const Key('app-store-tile-lyzer-collect')),
        findsOneWidget,
      );
      expect(
        find.byKey(const Key('app-store-tile-lyzer-deliver')),
        findsOneWidget,
      );
      expect(
        find.byKey(const Key('app-store-tile-mag-venda-digital')),
        findsOneWidget,
      );
      expect(
        find.text('11.5K+ downloads · Flutter · Kotlin · Swift'),
        findsOneWidget,
      );

      await tester.tap(find.byKey(const Key('app-store-tile-van-cranenbroek')));
      await tester.pumpAndSettle();

      expect(
        find.byKey(const Key('app-detail-scroll-view-van-cranenbroek')),
        findsOneWidget,
      );
      expect(
        ModalRoute.of(
          tester.element(
            find.byKey(const Key('app-detail-scroll-view-van-cranenbroek')),
          ),
        )?.settings.name,
        '/apps/van-cranenbroek',
      );
      expect(
        find.byKey(const Key('production-app-card-van-cranenbroek')),
        findsOneWidget,
      );
      expect(find.byKey(const Key('store-page-app-bar')), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('opens the complete catalog and reaches the fourth app', (
    tester,
  ) async {
    await _pumpStorefront(tester, size: const Size(390, 1000));

    await tester.tap(find.byKey(const Key('view-all-apps-button')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('all-apps-scroll-view')), findsOneWidget);
    expect(find.byKey(const Key('all-apps-list')), findsOneWidget);
    expect(
      ModalRoute.of(
        tester.element(find.byKey(const Key('all-apps-scroll-view'))),
      )?.settings.name,
      ProductionAppsRoutes.catalog,
    );
    expect(
      find.byKey(const Key('app-store-tile-mag-venda-digital')),
      findsOneWidget,
    );

    await tester.tap(find.byKey(const Key('app-store-tile-mag-venda-digital')));
    await tester.pumpAndSettle();

    expect(
      find.byKey(const Key('app-detail-scroll-view-mag-venda-digital')),
      findsOneWidget,
    );
    expect(
      ModalRoute.of(
        tester.element(
          find.byKey(const Key('app-detail-scroll-view-mag-venda-digital')),
        ),
      )?.settings.name,
      '/apps/mag-venda-digital',
    );
    expect(tester.takeException(), isNull);
  });

  test('recognizes catalog and app detail paths with URL suffixes', () {
    final presentation = ProductionAppsPresentation.localized(
      AppLocalizationsEn(),
    );
    expect(
      presentation.storefrontItems.map((item) => item.id).toSet(),
      ProductionAppsRoutes.supportedItemIds,
    );
    expect(ProductionAppsRoutes.isCatalog('/apps/'), isTrue);
    expect(ProductionAppsRoutes.isCatalog('/apps?ref=menu'), isTrue);
    expect(
      ProductionAppsRoutes.detailItemId('/apps/lyzer-collect/?ref=home'),
      'lyzer-collect',
    );
    expect(ProductionAppsRoutes.detailItemId('/apps/'), isNull);
    expect(ProductionAppsRoutes.detailItemId('/apps/not/valid'), isNull);
  });

  testWidgets('uses a horizontal storefront on a wide desktop window', (
    tester,
  ) async {
    await _pumpStorefront(tester, size: const Size(1440, 900));

    final van = tester.getRect(
      find.byKey(const Key('app-store-tile-van-cranenbroek')),
    );
    final lyzer = tester.getRect(
      find.byKey(const Key('app-store-tile-lyzer-collect')),
    );
    final deliver = tester.getRect(
      find.byKey(const Key('app-store-tile-lyzer-deliver')),
    );
    final mag = tester.getRect(
      find.byKey(const Key('app-store-tile-mag-venda-digital')),
    );
    expect(van.top, closeTo(lyzer.top, .01));
    expect(van.right, lessThan(lyzer.left));
    expect(van.width, closeTo(lyzer.width, .01));
    expect(deliver.top, closeTo(mag.top, .01));
    expect(deliver.right, lessThan(mag.left));
    expect(deliver.top, greaterThan(van.bottom));
    expect(deliver.width, closeTo(van.width, .01));
    expect(tester.takeException(), isNull);
  });
}

Future<void> _pumpStorefront(WidgetTester tester, {required Size size}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  final presentation = ProductionAppsPresentation.localized(
    AppLocalizationsEn(),
  );
  await tester.pumpWidget(
    MaterialApp(
      theme: LeoneBrandTheme.dark(),
      onGenerateRoute: (settings) {
        if (ProductionAppsRoutes.isCatalog(settings.name)) {
          return MaterialPageRoute<void>(
            settings: settings,
            builder: (_) => ProductionAppsCatalogPage(
              content: presentation.storefrontContent,
              items: presentation.storefrontItems,
            ),
          );
        }

        final itemId = ProductionAppsRoutes.detailItemId(settings.name);
        if (itemId == null) return null;
        final item = presentation.storefrontItems.singleWhere(
          (item) => item.id == itemId,
        );
        final app = presentation.apps.singleWhere(
          (app) => app.id == item.appCaseId,
        );
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) =>
              ProductionAppDetailPage(content: presentation.content, app: app),
        );
      },
      home: Scaffold(
        body: SingleChildScrollView(
          child: ProductionAppsStorefront(
            content: presentation.storefrontContent,
            items: presentation.storefrontItems,
          ),
        ),
      ),
    ),
  );
  await tester.pump();
}
