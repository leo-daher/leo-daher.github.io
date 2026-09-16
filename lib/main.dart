import 'package:material_ui/material_ui.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'brand/leone_brand.dart';
import 'brand/leone_glass.dart';
import 'features/articles/articles.dart';
import 'features/apps/production_apps.dart';
import 'features/certificates/certifications_section.dart';
import 'features/clients/client_logo_cloud.dart';
import 'features/contact/contact_section.dart';
import 'features/hero/portfolio_hero.dart';
import 'features/navigation/portfolio_fab_menu.dart';
import 'features/navigation/portfolio_page_transition.dart';
import 'features/navigation/portfolio_top_bar.dart';
import 'features/proof/portfolio_proof_strip.dart';
import 'features/system/system_overview_section.dart';
import 'ld_identity.dart';
import 'l10n/app_localizations.dart';
import 'l10n/l10n.dart';
import 'seo/portfolio_seo_metadata.dart';
import 'telemetry/portfolio_telemetry.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy();
  await PortfolioTelemetry.initialize(() => runApp(const LeonePortfolioApp()));
}

class LeonePortfolioApp extends StatefulWidget {
  const LeonePortfolioApp({super.key, this.initialRoute});

  final String? initialRoute;

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
  bool _homeReady = false;
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  final GlobalKey<_PortfolioHomePageState> _homePageKey =
      GlobalKey<_PortfolioHomePageState>();
  final _navigationObserver = _PortfolioNavigationObserver();
  late final PortfolioSeoRouteObserver _seoRouteObserver =
      PortfolioSeoRouteObserver(
        initialLanguageCode:
            WidgetsBinding.instance.platformDispatcher.locale.languageCode,
      );

  @override
  void initState() {
    super.initState();
    _restorePreferences();
  }

  @override
  void dispose() {
    _navigationObserver.dispose();
    super.dispose();
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
    if (languageCode == 'en' || languageCode == 'pt') {
      _seoRouteObserver.setLanguageCode(languageCode!);
    }
  }

  Future<void> _setLocale(Locale locale) async {
    if (_locale?.languageCode == locale.languageCode) return;
    _localeChosenInSession = true;
    setState(() => _locale = locale);
    _seoRouteObserver.setLanguageCode(locale.languageCode);
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

  void _markHomeReady() {
    if (_homeReady || !mounted) return;
    setState(() => _homeReady = true);
  }

  void _scrollHomeToTop() {
    PortfolioTelemetry.sectionSelected(PortfolioDestination.home.name);
    _homePageKey.currentState?.scrollToTop();
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
        ...GlobalMaterialLocalizations.delegates,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      navigatorKey: _navigatorKey,
      navigatorObservers: [_seoRouteObserver, _navigationObserver],
      builder: (context, navigator) => LeoneGlassExperience(
        child: _PortfolioNavigationFrame(
          navigator: navigator!,
          navigatorKey: _navigatorKey,
          navigationObserver: _navigationObserver,
          showHeader: _homeReady || _navigationObserver.canNavigateBack,
          onHomePressed: _scrollHomeToTop,
          onLocaleChanged: _setLocale,
          onThemeModeChanged: _setThemeMode,
        ),
      ),
      initialRoute: widget.initialRoute,
      onGenerateInitialRoutes: (initialRouteName) {
        final routeSettings = RouteSettings(name: initialRouteName);
        final initialRoute = _generateRoute(routeSettings);
        final routeName = _normalizedRoutePath(initialRouteName);
        final startsAwayFromHome =
            initialRoute != null &&
            routeName != null &&
            routeName != '/' &&
            routeName != _iosRouteName;
        if (startsAwayFromHome) {
          final homeRouteName = routeName.startsWith('/ios/')
              ? _iosRouteName
              : '/';
          return [
            _generateRoute(
              RouteSettings(name: homeRouteName),
              skipHomeOpening: true,
              maintainState: false,
            )!,
            initialRoute,
          ];
        }
        return [
          initialRoute ?? _generateRoute(const RouteSettings(name: '/'))!,
        ];
      },
      onGenerateRoute: _generateRoute,
    );
  }

  Route<void>? _generateRoute(
    RouteSettings settings, {
    bool skipHomeOpening = false,
    bool maintainState = true,
  }) {
    final routeName = _normalizedRoutePath(settings.name);
    if (routeName == null || routeName == '/' || routeName == _iosRouteName) {
      return PortfolioPlanePageRoute<void>(
        settings: settings,
        reduceMotion: _reduceMotion,
        maintainState: maintainState,
        pageBuilder: (_, _, _) => _PortfolioEntry(
          homePageKey: _homePageKey,
          skipOpening: skipHomeOpening,
          onReady: _markHomeReady,
          onLocaleChanged: _setLocale,
          onThemeModeChanged: _setThemeMode,
        ),
      );
    }
    if (ProductionAppsRoutes.isCatalog(settings.name)) {
      return PortfolioPlanePageRoute<void>(
        settings: settings,
        reduceMotion: _reduceMotion,
        pageBuilder: (context, _, _) {
          final presentation = ProductionAppsPresentation.localized(
            context.l10n,
          );
          return ProductionAppsCatalogPage(
            content: presentation.storefrontContent,
            items: presentation.storefrontItems,
          );
        },
      );
    }
    final appItemId = ProductionAppsRoutes.detailItemId(settings.name);
    if (appItemId != null &&
        ProductionAppsRoutes.supportedItemIds.contains(appItemId)) {
      return PortfolioPlanePageRoute<void>(
        settings: settings,
        reduceMotion: _reduceMotion,
        pageBuilder: (context, _, _) {
          final presentation = ProductionAppsPresentation.localized(
            context.l10n,
          );
          final item = presentation.storefrontItems.singleWhere(
            (item) => item.id == appItemId,
          );
          final app = presentation.apps.singleWhere(
            (app) => app.id == item.appCaseId,
          );
          return ProductionAppDetailPage(
            content: presentation.content,
            app: app,
          );
        },
      );
    }
    if (routeName == ArticlesPage.routeName ||
        routeName == _iosArticleRouteName) {
      return PortfolioPlanePageRoute<void>(
        settings: settings,
        reduceMotion: _reduceMotion,
        pageBuilder: (_, _, _) {
          return ArticlesPage(
            useEmbeddedTopBar: false,
            onLocaleChanged: _setLocale,
            onThemeModeChanged: _setThemeMode,
          );
        },
      );
    }
    return null;
  }
}

bool get _reduceMotion {
  final accessibilityFeatures =
      WidgetsBinding.instance.platformDispatcher.accessibilityFeatures;
  return accessibilityFeatures.disableAnimations ||
      accessibilityFeatures.reduceMotion;
}

String? _normalizedRoutePath(String? routeName) {
  if (routeName == null) return null;
  final path = Uri.tryParse(routeName)?.path;
  if (path == null || path.isEmpty) return '/';
  return path.length > 1 && path.endsWith('/')
      ? path.substring(0, path.length - 1)
      : path;
}

const _iosRouteName = '/ios';
const _iosArticleRouteName = '/ios/artigos/identidade-visual';

class _PortfolioNavigationObserver extends NavigatorObserver
    with ChangeNotifier {
  final List<Route<dynamic>> _routes = [];
  bool _notificationScheduled = false;
  bool _disposed = false;

  bool get canNavigateBack => _routes.length > 1;

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    _routes.add(route);
    _scheduleNotification();
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    if (route is TransitionRoute<dynamic>) {
      route.completed.then((_) => _removePoppedRoute(route));
    } else {
      _removePoppedRoute(route);
    }
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didRemove(route, previousRoute);
    _routes.remove(route);
    _scheduleNotification();
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    final oldIndex = oldRoute == null ? -1 : _routes.indexOf(oldRoute);
    if (oldIndex >= 0 && newRoute != null) {
      _routes[oldIndex] = newRoute;
    } else {
      if (oldRoute != null) _routes.remove(oldRoute);
      if (newRoute != null) _routes.add(newRoute);
    }
    _scheduleNotification();
  }

  void _scheduleNotification() {
    if (_disposed || _notificationScheduled) return;
    _notificationScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _notificationScheduled = false;
      if (_disposed) return;
      notifyListeners();
    });
  }

  void _removePoppedRoute(Route<dynamic> route) {
    if (_disposed || !_routes.remove(route)) return;
    _scheduleNotification();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}

class _PortfolioNavigationFrame extends StatefulWidget {
  const _PortfolioNavigationFrame({
    required this.navigator,
    required this.navigatorKey,
    required this.navigationObserver,
    required this.showHeader,
    required this.onHomePressed,
    required this.onLocaleChanged,
    required this.onThemeModeChanged,
  });

  final Widget navigator;
  final GlobalKey<NavigatorState> navigatorKey;
  final _PortfolioNavigationObserver navigationObserver;
  final bool showHeader;
  final VoidCallback onHomePressed;
  final ValueChanged<Locale> onLocaleChanged;
  final ValueChanged<ThemeMode> onThemeModeChanged;

  @override
  State<_PortfolioNavigationFrame> createState() =>
      _PortfolioNavigationFrameState();
}

class _PortfolioNavigationFrameState extends State<_PortfolioNavigationFrame> {
  late final OverlayEntry _frameEntry = OverlayEntry(builder: _buildFrame);

  @override
  void didUpdateWidget(covariant _PortfolioNavigationFrame oldWidget) {
    super.didUpdateWidget(oldWidget);
    _frameEntry.markNeedsBuild();
  }

  @override
  void dispose() {
    _frameEntry.remove();
    _frameEntry.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Overlay(initialEntries: [_frameEntry]);
  }

  Widget _buildFrame(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.navigationObserver,
      builder: (context, _) {
        final canNavigateBack = widget.navigationObserver.canNavigateBack;
        return Stack(
          fit: StackFit.expand,
          children: [
            widget.navigator,
            if (widget.showHeader || canNavigateBack)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: PortfolioFixedTopBar(
                  canNavigateBack: canNavigateBack,
                  onHomePressed: widget.onHomePressed,
                  onBackPressed: () =>
                      widget.navigatorKey.currentState?.maybePop(),
                  onLocaleChanged: widget.onLocaleChanged,
                  onThemeModeChanged: widget.onThemeModeChanged,
                ),
              ),
          ],
        );
      },
    );
  }
}

class _PortfolioEntry extends StatefulWidget {
  const _PortfolioEntry({
    required this.homePageKey,
    required this.skipOpening,
    required this.onReady,
    required this.onLocaleChanged,
    required this.onThemeModeChanged,
  });

  final GlobalKey<_PortfolioHomePageState> homePageKey;
  final bool skipOpening;
  final VoidCallback onReady;
  final ValueChanged<Locale> onLocaleChanged;
  final ValueChanged<ThemeMode> onThemeModeChanged;

  @override
  State<_PortfolioEntry> createState() => _PortfolioEntryState();
}

class _PortfolioEntryState extends State<_PortfolioEntry> {
  late bool _homeMounted;
  late bool _showOpening;

  @override
  void initState() {
    super.initState();
    _homeMounted = widget.skipOpening;
    _showOpening = !widget.skipOpening;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (widget.skipOpening) {
        widget.onReady();
      } else {
        setState(() => _homeMounted = true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (_homeMounted)
          ExcludeSemantics(
            excluding: _showOpening,
            child: KeyedSubtree(
              key: const Key('portfolio-home-page'),
              child: PortfolioHomePage(
                key: widget.homePageKey,
                floatingActionButtonEnabled: !_showOpening,
                heroAutoPlay: !_showOpening,
                onLocaleChanged: widget.onLocaleChanged,
                onThemeModeChanged: widget.onThemeModeChanged,
              ),
            ),
          ),
        if (_showOpening)
          LdOpeningTransition(
            start: _homeMounted,
            onCompleted: () {
              if (!mounted) return;
              setState(() => _showOpening = false);
              widget.onReady();
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
  bool _atTop = true;
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
    _scrollController.addListener(_handleScroll);
  }

  void _handleScroll() {
    _trackScrollDepth();
    final atTop =
        !_scrollController.hasClients || _scrollController.offset <= .5;
    if (atTop != _atTop && mounted) setState(() => _atTop = atTop);
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
    _scrollController.removeListener(_handleScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void scrollToTop() {
    if (!_scrollController.hasClients) return;
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 480),
      curve: LeoneBrandMotion.pageTransitionCurve,
    );
  }

  void _navigateTo(PortfolioDestination destination) {
    PortfolioTelemetry.sectionSelected(destination.name);
    if (destination == PortfolioDestination.home) {
      scrollToTop();
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
    return PopScope<void>(
      canPop: _atTop,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop && !_atTop) scrollToTop();
      },
      child: PortfolioFabMenuScaffold(
        showFloatingActionButton: widget.showFloatingActionButton,
        floatingActionButtonEnabled: widget.floatingActionButtonEnabled,
        onSelected: _navigateTo,
        body: SelectionArea(
          child: CustomScrollView(
            key: const Key('portfolio-scroll-view'),
            controller: _scrollController,
            slivers: [
              SliverToBoxAdapter(
                child: SizedBox(height: PortfolioFixedTopBar.heightOf(context)),
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
                  items: appsPresentation.storefrontItems,
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
