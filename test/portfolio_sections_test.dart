import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:leone_portfolio/brand/leone_brand.dart';
import 'package:leone_portfolio/features/contact/contact_section.dart';
import 'package:leone_portfolio/features/proof/portfolio_proof_strip.dart';
import 'package:leone_portfolio/l10n/app_localizations.dart';
import 'package:url_launcher/link.dart';

void main() {
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
    expect(find.text('Brazil + Europe'), findsOneWidget);
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
    final schedule = tester.widget<Link>(
      find.byKey(const Key('contact-link-schedule')),
    );
    expect(linkedin.uri, Uri.parse('https://www.linkedin.com/in/leonedaher/'));
    expect(github.uri, Uri.parse('https://github.com/leo-daher'));
    expect(schedule.uri, Uri.parse('https://calendly.com/leonedaher/30min'));
    expect(tester.takeException(), isNull);
  });
}

Widget _localizedScaffold(Widget child) => MaterialApp(
  locale: const Locale('en'),
  theme: LeoneBrandTheme.dark(),
  localizationsDelegates: const [AppLocalizations.delegate],
  supportedLocales: AppLocalizations.supportedLocales,
  home: Scaffold(body: child),
);
