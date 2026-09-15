import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'brand/leone_brand.dart';
import 'features/articles/articles.dart';
import 'features/apps/production_apps.dart';
import 'features/certificates/certifications_section.dart';
import 'features/clients/client_logo_cloud.dart';
import 'features/contact/contact_section.dart';
import 'features/hero/portfolio_hero.dart';
import 'features/navigation/portfolio_fab_menu.dart';
import 'features/navigation/portfolio_top_bar.dart';
import 'features/proof/portfolio_proof_strip.dart';
import 'features/system/system_overview_section.dart';
import 'ld_identity.dart';
import 'l10n/app_localizations.dart';
import 'l10n/l10n.dart';
import 'telemetry/portfolio_telemetry.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PortfolioTelemetry.initialize(() => runApp(const LeonePortfolioApp()));
}

class LeonePortfolioApp extends StatefulWidget {
  const LeonePortfolioApp({super.key});

  @override
  State<LeonePortfolioApp> createState() => _LeonePortfolioAppState();
}

class _LeonePortfolioAppState extends State<LeonePortfolioApp> {
  static const _localePreferenceKey = 'portfolio_locale';
  static const _themePreferenceKey = 'portfolio_theme';
  Locale? _locale;
  ThemeMode _themeMode = ThemeMode.dark;
  bool _localeChosenInSession = false;
  bool _themeChosenInSession = false;

  @override
  void initState() {
    super.initState();
    _restorePreferences();
  }

  Future<void> _restorePreferences() async {
    final preferences = await SharedPreferences.getInstance();
    final languageCode = preferences.getString(_localePreferenceKey);
    final savedTheme = preferences.getString(_themePreferenceKey);
    if (!mounted) return;
    setState(() {
      if (!_localeChosenInSession &&
          (languageCode == 'en' || languageCode == 'pt')) {
        _locale = Locale(languageCode!);
      }
      if (!_themeChosenInSession &&
          (savedTheme == 'light' || savedTheme == 'dark')) {
        _themeMode = ThemeMode.values.byName(savedTheme!);
      }
    });
  }

  Future<void> _setLocale(Locale locale) async {
    if (_locale?.languageCode == locale.languageCode) return;
    _localeChosenInSession = true;
    setState(() => _locale = locale);
    PortfolioTelemetry.preferenceChanged('language', locale.languageCode);
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_localePreferenceKey, locale.languageCode);
  }

  Future<void> _setThemeMode(ThemeMode themeMode) async {
    if (_themeMode == themeMode) return;
    _themeChosenInSession = true;
    setState(() => _themeMode = themeMode);
    PortfolioTelemetry.preferenceChanged('theme', themeMode.name);
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_themePreferenceKey, themeMode.name);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateTitle: (context) => context.l10n.appTitle,
      theme: LeoneBrandTheme.light(),
      darkTheme: LeoneBrandTheme.dark(),
      themeMode: _themeMode,
      locale: _locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      onGenerateRoute: (settings) {
        if (settings.name == ArticlesPage.routeName) {
          return PageRouteBuilder<void>(
            pageBuilder: (_, _, _) => ArticlesPage(
              onLocaleChanged: _setLocale,
              onThemeModeChanged: _setThemeMode,
            ),
            settings: settings,
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
            transitionsBuilder: (_, _, _, child) => child,
          );
        }
        return null;
      },
      home: _PortfolioEntry(
        onLocaleChanged: _setLocale,
        onThemeModeChanged: _setThemeMode,
      ),
    );
  }
}

class _PortfolioEntry extends StatefulWidget {
  const _PortfolioEntry({
    required this.onLocaleChanged,
    required this.onThemeModeChanged,
  });

  final ValueChanged<Locale> onLocaleChanged;
  final ValueChanged<ThemeMode> onThemeModeChanged;

  @override
  State<_PortfolioEntry> createState() => _PortfolioEntryState();
}

class _PortfolioEntryState extends State<_PortfolioEntry> {
  bool _homeMounted = false;
  bool _showOpening = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() => _homeMounted = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (_homeMounted)
          ExcludeSemantics(
            excluding: _showOpening,
            child: PortfolioHomePage(
              key: const Key('portfolio-home-page'),
              floatingActionButtonEnabled: !_showOpening,
              heroAutoPlay: !_showOpening,
              onLocaleChanged: widget.onLocaleChanged,
              onThemeModeChanged: widget.onThemeModeChanged,
            ),
          ),
        if (_showOpening)
          LdOpeningTransition(
            start: _homeMounted,
            onCompleted: () {
              if (!mounted) return;
              setState(() => _showOpening = false);
              PortfolioTelemetry.portfolioViewed(
                locale: Localizations.localeOf(context).languageCode,
                theme: Theme.of(context).brightness.name,
              );
            },
          ),
      ],
    );
  }
}

class PortfolioHomePage extends StatefulWidget {
  const PortfolioHomePage({
    super.key,
    this.showFloatingActionButton = true,
    this.floatingActionButtonEnabled = true,
    this.heroAutoPlay = true,
    required this.onLocaleChanged,
    required this.onThemeModeChanged,
  });

  final bool showFloatingActionButton;
  final bool floatingActionButtonEnabled;
  final bool heroAutoPlay;
  final ValueChanged<Locale> onLocaleChanged;
  final ValueChanged<ThemeMode> onThemeModeChanged;

  @override
  State<PortfolioHomePage> createState() => _PortfolioHomePageState();
}

class _PortfolioHomePageState extends State<PortfolioHomePage> {
  static const _scrollDepthThresholds = [25, 50, 75, 90];
  final ScrollController _scrollController = ScrollController();
  final Set<int> _reportedScrollDepths = {};
  final GlobalKey _appsSectionKey = GlobalKey(
    debugLabel: 'portfolio-apps-section',
  );
  final GlobalKey _systemSectionKey = GlobalKey(
    debugLabel: 'portfolio-system-section',
  );
  final GlobalKey _clientsSectionKey = GlobalKey(
    debugLabel: 'portfolio-clients-section',
  );
  final GlobalKey _articlesSectionKey = GlobalKey(
    debugLabel: 'portfolio-articles-section',
  );
  final GlobalKey _contactSectionKey = GlobalKey(
    debugLabel: 'portfolio-contact-section',
  );

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_trackScrollDepth);
  }

  void _trackScrollDepth() {
    if (!_scrollController.hasClients) return;
    final maxScrollExtent = _scrollController.position.maxScrollExtent;
    if (maxScrollExtent <= 0) return;
    final percent = (_scrollController.offset / maxScrollExtent * 100).clamp(
      0,
      100,
    );
    for (final threshold in _scrollDepthThresholds) {
      if (percent >= threshold && _reportedScrollDepths.add(threshold)) {
        PortfolioTelemetry.scrollDepth(threshold);
      }
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_trackScrollDepth);
    _scrollController.dispose();
    super.dispose();
  }

  void _navigateTo(PortfolioDestination destination) {
    PortfolioTelemetry.sectionSelected(destination.name);
    if (destination == PortfolioDestination.home) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 720),
        curve: Curves.easeInOutCubic,
      );
      return;
    }

    final target = switch (destination) {
      PortfolioDestination.apps => _appsSectionKey.currentContext,
      PortfolioDestination.system => _systemSectionKey.currentContext,
      PortfolioDestination.clients => _clientsSectionKey.currentContext,
      PortfolioDestination.contact => _contactSectionKey.currentContext,
      PortfolioDestination.home => null,
    };
    if (target == null) return;
    Scrollable.ensureVisible(
      target,
      duration: const Duration(milliseconds: 720),
      curve: Curves.easeInOutCubic,
      alignment: .04,
    );
  }

  @override
  Widget build(BuildContext context) {
    final appsPresentation = ProductionAppsPresentation.localized(context.l10n);
    return PortfolioFabMenuScaffold(
      showFloatingActionButton: widget.showFloatingActionButton,
      floatingActionButtonEnabled: widget.floatingActionButtonEnabled,
      onSelected: _navigateTo,
      body: SelectionArea(
        child: CustomScrollView(
          key: const Key('portfolio-scroll-view'),
          controller: _scrollController,
          slivers: [
            PortfolioSliverTopBar(
              onLocaleChanged: widget.onLocaleChanged,
              onThemeModeChanged: widget.onThemeModeChanged,
              onHomePressed: () => _navigateTo(PortfolioDestination.home),
            ),
            SliverToBoxAdapter(
              child: _SectionFrame(
                maxWidth: 1440,
                padding: const EdgeInsets.fromLTRB(24, 30, 24, 0),
                child: PortfolioHero(autoPlay: widget.heroAutoPlay),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 32)),
            const SliverToBoxAdapter(
              child: _SectionFrame(child: PortfolioProofStrip()),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 92)),
            SliverToBoxAdapter(
              child: SizedBox(key: _appsSectionKey, height: 1),
            ),
            SliverToBoxAdapter(
              child: ProductionAppsStorefront(
                content: appsPresentation.storefrontContent,
                caseContent: appsPresentation.content,
                items: appsPresentation.storefrontItems,
                apps: appsPresentation.apps,
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 72)),
            SliverToBoxAdapter(
              child: _SectionFrame(
                key: _systemSectionKey,
                child: const SystemOverviewSection(),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 92)),
            SliverToBoxAdapter(
              child: _SectionFrame(
                key: _clientsSectionKey,
                child: const ClientLogoCloud(),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 92)),
            SliverToBoxAdapter(child: const CertificationsSection()),
            const SliverToBoxAdapter(child: SizedBox(height: 92)),
            SliverToBoxAdapter(
              child: _SectionFrame(
                key: _articlesSectionKey,
                child: ArticlesSection(
                  onOpenArticles: () =>
                      Navigator.of(context).pushNamed(ArticlesPage.routeName),
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 92)),
            SliverToBoxAdapter(
              child: _SectionFrame(
                key: _contactSectionKey,
                child: const ContactSection(),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 72)),
            const SliverToBoxAdapter(child: _Footer()),
          ],
        ),
      ),
    );
  }
}

class _SectionFrame extends StatelessWidget {
  const _SectionFrame({
    super.key,
    required this.child,
    this.maxWidth = 1240,
    this.padding,
  });

  final Widget child;
  final double maxWidth;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Padding(
          padding: padding ?? const EdgeInsets.symmetric(horizontal: 24),
          child: child,
        ),
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer();

  @override
  Widget build(BuildContext context) {
    final palette = context.leonePalette;
    final lightMode = Theme.of(context).brightness == Brightness.light;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 42),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: palette.outline)),
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1240),
          child: Row(
            key: const Key('footer-signature'),
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 28,
                height: 28,
                child: SvgPicture.asset(
                  lightMode
                      ? 'assets/brand/ld-mark.svg'
                      : 'assets/brand/ld-mark-inverse.svg',
                ),
              ),
              const SizedBox(width: 10),
              Text(
                'LEONE DAHER  •  2026',
                style: TextStyle(color: palette.mutedInk, fontSize: 11),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
