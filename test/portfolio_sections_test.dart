import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:leone_portfolio/brand/leone_brand.dart';
import 'package:leone_portfolio/features/clients/client_logo_cloud.dart';
import 'package:leone_portfolio/features/contact/contact_section.dart';
import 'package:leone_portfolio/features/proof/portfolio_proof_strip.dart';
import 'package:leone_portfolio/features/system/system_overview_section.dart';
import 'package:leone_portfolio/l10n/app_localizations.dart';
import 'package:url_launcher/link.dart';

void main() {
  testWidgets('client relationship groups keep a two-column mobile grid', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      _localizedScaffold(
        const SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: ClientLogoCloud(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final mag = tester.getRect(
      find.byKey(const Key('client-logo-mag-seguros')),
    );
    final human = tester.getRect(
      find.byKey(const Key('client-logo-human-robotics')),
    );
    final visagio = tester.getRect(
      find.byKey(const Key('client-logo-visagio')),
    );
    final directGroup = tester.getRect(
      find.byKey(const Key('client-logo-group-direct')),
    );
    final latituddeGroup = tester.getRect(
      find.byKey(const Key('client-logo-group-latitudde')),
    );

    expect(mag.top, closeTo(human.top, .01));
    expect(mag.right, lessThan(human.left));
    expect(visagio.top, greaterThan(mag.bottom));
    expect(directGroup.bottom, lessThan(latituddeGroup.top));
    expect(find.text('Clients'), findsOneWidget);
    expect(find.text('DIRECT'), findsOneWidget);
    expect(find.text('VIA LATITUDDE / CONKORD'), findsOneWidget);
    expect(find.byKey(const Key('client-logo-conkord')), findsOneWidget);
    expect(find.byKey(const Key('client-logo-ascendi')), findsOneWidget);
    expect(find.text('CLIENTS SERVED'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('strengthens the Visagio wordmark only on the light theme', (
    tester,
  ) async {
    Widget app(ThemeData theme) => MaterialApp(
      locale: const Locale('en'),
      theme: theme,
      localizationsDelegates: const [AppLocalizations.delegate],
      supportedLocales: AppLocalizations.supportedLocales,
      home: const Scaffold(body: ClientLogoCloud()),
    );

    await tester.pumpWidget(app(LeoneBrandTheme.light()));
    await tester.pumpAndSettle();

    final visagio = find.descendant(
      of: find.byKey(const Key('client-logo-visagio')),
      matching: find.byType(SvgPicture),
    );
    final lightPicture = tester.widget<SvgPicture>(visagio);
    final lightLoader = lightPicture.bytesLoader as SvgAssetLoader;
    expect(lightLoader.colorMapper, isNotNull);
    expect(
      lightLoader.colorMapper!.substitute(
        null,
        'path',
        'fill',
        const Color(0xFFD6D5C9),
      ),
      const Color(0xFF00363D),
    );
    expect(
      lightLoader.colorMapper!.substitute(
        null,
        'path',
        'fill',
        const Color(0xFFA9FDAC),
      ),
      const Color(0xFFA9FDAC),
    );

    await tester.pumpWidget(app(LeoneBrandTheme.dark()));
    await tester.pumpAndSettle();

    final darkPicture = tester.widget<SvgPicture>(visagio);
    final darkLoader = darkPicture.bytesLoader as SvgAssetLoader;
    expect(darkLoader.colorMapper, isNull);
    expect(tester.takeException(), isNull);
  });

  testWidgets('proof strip reflows into two columns on mobile', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      _localizedScaffold(
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: PortfolioProofStrip(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('portfolio-proof-strip')), findsOneWidget);
    expect(find.text('Android + iOS'), findsOneWidget);
    expect(find.text('LATAM · USA · EU'), findsOneWidget);
    expect(find.text('≈20K'), findsOneWidget);
    final appsRect = tester.getRect(find.text('4'));
    final platformsRect = tester.getRect(find.text('Android + iOS'));
    final marketsRect = tester.getRect(find.text('LATAM · USA · EU'));
    final downloadsRect = tester.getRect(find.text('≈20K'));
    expect(appsRect.top, closeTo(platformsRect.top, 8));
    expect(marketsRect.top, closeTo(downloadsRect.top, 8));
    expect(appsRect.right, lessThan(platformsRect.left));
    expect(marketsRect.top, greaterThan(appsRect.bottom));
    expect(
      tester.getSize(find.byKey(const Key('portfolio-proof-strip'))).width,
      closeTo(342, .01),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('contact cards remain usable on mobile and expose real links', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      _localizedScaffold(
        const SingleChildScrollView(
          padding: EdgeInsets.all(24),
          child: ContactSection(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final linkedin = tester.widget<Link>(
      find.byKey(const Key('contact-link-linkedin')),
    );
    final github = tester.widget<Link>(
      find.byKey(const Key('contact-link-github')),
    );
    final whatsApp = tester.widget<Link>(
      find.byKey(const Key('contact-link-whatsapp')),
    );
    final schedule = tester.widget<Link>(
      find.byKey(const Key('contact-link-schedule')),
    );
    expect(linkedin.uri, Uri.parse('https://www.linkedin.com/in/leonedaher/'));
    expect(github.uri, Uri.parse('https://github.com/leo-daher'));
    expect(whatsApp.uri, Uri.parse('https://wa.me/5521999997667'));
    expect(schedule.uri, Uri.parse('https://calendly.com/leonedaher/30min'));
    expect(find.byKey(const Key('contact-icon-linkedin')), findsOneWidget);
    expect(find.byKey(const Key('contact-icon-whatsapp')), findsOneWidget);
    expect(find.byKey(const Key('contact-icon-github')), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'architecture section states the full scope without a flow diagram',
    (tester) async {
      tester.view.physicalSize = const Size(1440, 1000);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        _localizedScaffold(
          const Padding(
            padding: EdgeInsets.all(24),
            child: SystemOverviewSection(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('End-to-end product architecture.'), findsOneWidget);
      expect(find.text('END-TO-END ARCHITECTURE'), findsNothing);
      expect(
        find.textContaining('From product flows and offline state'),
        findsNothing,
      );
      expect(find.text('Product and mobile'), findsOneWidget);
      expect(find.text('Services and data'), findsOneWidget);
      expect(find.text('Delivery and reliability'), findsOneWidget);
      expect(find.text('AI and automation'), findsOneWidget);
      expect(find.textContaining('DECISIONS + ACTIONS'), findsNothing);
      expect(find.byIcon(Icons.arrow_forward_rounded), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );
}

Widget _localizedScaffold(Widget child) => MaterialApp(
  locale: const Locale('en'),
  theme: LeoneBrandTheme.dark(),
  localizationsDelegates: const [AppLocalizations.delegate],
  supportedLocales: AppLocalizations.supportedLocales,
  home: Scaffold(body: child),
);
