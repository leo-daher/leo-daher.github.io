import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'brand/leone_brand.dart';
import 'features/apps/production_apps.dart';
import 'features/certificates/certifications_section.dart';
import 'features/clients/client_logo_cloud.dart';
import 'features/contact/contact_section.dart';
import 'features/hero/portfolio_hero.dart';
import 'features/navigation/portfolio_fab_menu.dart';
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

const _green = LeoneBrandColors.interactive;

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
            SliverToBoxAdapter(
              child: _TopBar(
                onLocaleChanged: widget.onLocaleChanged,
                onThemeModeChanged: widget.onThemeModeChanged,
                onViewApps: () => _navigateTo(PortfolioDestination.apps),
              ),
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
              child: ProductionAppsSection(
                content: appsPresentation.content,
                apps: appsPresentation.apps,
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 92)),
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

class _TopBar extends StatelessWidget {
  const _TopBar({
    required this.onLocaleChanged,
    required this.onThemeModeChanged,
    required this.onViewApps,
  });

  final ValueChanged<Locale> onLocaleChanged;
  final ValueChanged<ThemeMode> onThemeModeChanged;
  final VoidCallback onViewApps;

  @override
  Widget build(BuildContext context) {
    final palette = context.leonePalette;
    final lightMode = Theme.of(context).brightness == Brightness.light;
    return Container(
      height: 76,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: palette.canvas.withValues(alpha: .9),
        border: Border(bottom: BorderSide(color: palette.outline)),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1392),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final compact = constraints.maxWidth < 440;
              return Row(
                children: [
                  Semantics(
                    label: 'Leone Daher',
                    image: true,
                    child: SizedBox(
                      key: const Key('ld-topbar-mark'),
                      width: 34,
                      height: 34,
                      child: SvgPicture.asset(
                        lightMode
                            ? 'assets/brand/ld-mark.svg'
                            : 'assets/brand/ld-mark-inverse.svg',
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  if (!compact)
                    const Expanded(
                      child: Text(
                        'LEONE DAHER',
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 12,
                          letterSpacing: 1.8,
                        ),
                      ),
                    )
                  else
                    const Spacer(),
                  _LanguageToggle(onLocaleChanged: onLocaleChanged),
                  SizedBox(width: compact ? 6 : 12),
                  _ThemeToggle(onThemeModeChanged: onThemeModeChanged),
                  SizedBox(width: compact ? 6 : 12),
                  _ViewAppsButton(compact: compact, onPressed: onViewApps),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _LanguageToggle extends StatelessWidget {
  const _LanguageToggle({required this.onLocaleChanged});

  final ValueChanged<Locale> onLocaleChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final palette = context.leonePalette;
    final selectedLanguage = Localizations.localeOf(context).languageCode;
    final englishSelected = selectedLanguage == 'en';
    final targetLocale = Locale(englishSelected ? 'pt' : 'en');
    final targetLanguage = englishSelected
        ? l10n.portugueseLanguage
        : l10n.englishLanguage;

    return Semantics(
      button: true,
      label: '${l10n.languageSelectorLabel}: $targetLanguage',
      child: Tooltip(
        message: targetLanguage,
        excludeFromSemantics: true,
        child: TextButton(
          key: const Key('language-toggle'),
          onPressed: () => onLocaleChanged(targetLocale),
          style: TextButton.styleFrom(
            foregroundColor: palette.ink,
            fixedSize: const Size(64, 48),
            padding: EdgeInsets.zero,
            shape: const StadiumBorder(),
          ),
          child: ExcludeSemantics(
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'EN',
                    style: TextStyle(
                      color: englishSelected ? palette.ink : palette.mutedInk,
                    ),
                  ),
                  TextSpan(
                    text: ' / ',
                    style: TextStyle(color: palette.mutedInk),
                  ),
                  TextSpan(
                    text: 'PT',
                    style: TextStyle(
                      color: englishSelected ? palette.mutedInk : palette.ink,
                    ),
                  ),
                ],
              ),
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w800,
                letterSpacing: .5,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ThemeToggle extends StatelessWidget {
  const _ThemeToggle({required this.onThemeModeChanged});

  final ValueChanged<ThemeMode> onThemeModeChanged;

  @override
  Widget build(BuildContext context) {
    final lightMode = Theme.of(context).brightness == Brightness.light;
    final targetMode = lightMode ? ThemeMode.dark : ThemeMode.light;
    final label = lightMode
        ? context.l10n.switchToDarkTheme
        : context.l10n.switchToLightTheme;
    return Semantics(
      button: true,
      label: label,
      child: Tooltip(
        message: label,
        excludeFromSemantics: true,
        child: IconButton(
          key: const Key('theme-toggle'),
          onPressed: () => onThemeModeChanged(targetMode),
          icon: Icon(
            lightMode ? Icons.dark_mode_outlined : Icons.light_mode_outlined,
          ),
        ),
      ),
    );
  }
}

class _ViewAppsButton extends StatelessWidget {
  const _ViewAppsButton({required this.compact, required this.onPressed});

  final bool compact;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final label = compact
        ? context.l10n.viewAppsCompact
        : context.l10n.viewApps;
    return Semantics(
      button: true,
      label: label,
      child: Tooltip(
        message: label,
        excludeFromSemantics: true,
        child: TextButton.icon(
          key: const Key('view-apps-button'),
          onPressed: onPressed,
          style: TextButton.styleFrom(
            foregroundColor: _green,
            minimumSize: const Size(0, 48),
            padding: EdgeInsets.symmetric(horizontal: compact ? 12 : 16),
            backgroundColor: _green.withValues(alpha: .10),
            side: BorderSide(color: _green.withValues(alpha: .34)),
            shape: const StadiumBorder(),
          ),
          icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 17),
          label: Text(
            label.toUpperCase(),
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: .8,
            ),
          ),
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
