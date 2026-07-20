import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'brand/leone_brand.dart';
import 'features/experience/experience_section.dart';
import 'features/hero/portfolio_hero.dart';
import 'features/navigation/portfolio_fab_menu.dart';
import 'features/projects/portfolio_projects.dart';
import 'features/system/system_overview_section.dart';
import 'ld_identity.dart';
import 'l10n/app_localizations.dart';
import 'l10n/l10n.dart';

void main() => runApp(const LeonePortfolioApp());

const _bg = LeoneBrandColors.canvas;
const _ink = LeoneBrandColors.ink;
const _muted = LeoneBrandColors.mutedInk;
const _green = LeoneBrandColors.interactive;

class LeonePortfolioApp extends StatefulWidget {
  const LeonePortfolioApp({super.key});

  @override
  State<LeonePortfolioApp> createState() => _LeonePortfolioAppState();
}

class _LeonePortfolioAppState extends State<LeonePortfolioApp> {
  static const _localePreferenceKey = 'portfolio_locale';
  Locale? _locale;
  bool _localeChosenInSession = false;

  @override
  void initState() {
    super.initState();
    _restoreLocale();
  }

  Future<void> _restoreLocale() async {
    final preferences = await SharedPreferences.getInstance();
    final languageCode = preferences.getString(_localePreferenceKey);
    if (!mounted ||
        _localeChosenInSession ||
        (languageCode != 'en' && languageCode != 'pt')) {
      return;
    }
    setState(() => _locale = Locale(languageCode!));
  }

  Future<void> _setLocale(Locale locale) async {
    if (_locale?.languageCode == locale.languageCode) return;
    _localeChosenInSession = true;
    setState(() => _locale = locale);
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_localePreferenceKey, locale.languageCode);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateTitle: (context) => context.l10n.appTitle,
      theme: LeoneBrandTheme.dark(),
      locale: _locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: _PortfolioEntry(onLocaleChanged: _setLocale),
    );
  }
}

class _PortfolioEntry extends StatefulWidget {
  const _PortfolioEntry({required this.onLocaleChanged});

  final ValueChanged<Locale> onLocaleChanged;

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
            ),
          ),
        if (_showOpening)
          LdOpeningTransition(
            start: _homeMounted,
            onCompleted: () {
              if (mounted) setState(() => _showOpening = false);
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
  });

  final bool showFloatingActionButton;
  final bool floatingActionButtonEnabled;
  final bool heroAutoPlay;
  final ValueChanged<Locale> onLocaleChanged;

  @override
  State<PortfolioHomePage> createState() => _PortfolioHomePageState();
}

class _PortfolioHomePageState extends State<PortfolioHomePage> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _systemSectionKey = GlobalKey(
    debugLabel: 'portfolio-system-section',
  );
  final GlobalKey _projectsSectionKey = GlobalKey(
    debugLabel: 'portfolio-projects-section',
  );
  final GlobalKey _experienceSectionKey = GlobalKey(
    debugLabel: 'portfolio-experience-section',
  );

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _navigateTo(PortfolioDestination destination) {
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
      PortfolioDestination.system => _systemSectionKey.currentContext,
      PortfolioDestination.projects => _projectsSectionKey.currentContext,
      PortfolioDestination.experience => _experienceSectionKey.currentContext,
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
    return PortfolioFabMenuScaffold(
      showFloatingActionButton: widget.showFloatingActionButton,
      floatingActionButtonEnabled: widget.floatingActionButtonEnabled,
      onSelected: _navigateTo,
      body: SelectionArea(
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverToBoxAdapter(
              child: _TopBar(onLocaleChanged: widget.onLocaleChanged),
            ),
            SliverToBoxAdapter(
              child: _SectionFrame(
                maxWidth: 1440,
                padding: const EdgeInsets.fromLTRB(24, 30, 24, 0),
                child: PortfolioHero(autoPlay: widget.heroAutoPlay),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 42)),
            SliverToBoxAdapter(
              child: _SectionFrame(
                key: _systemSectionKey,
                maxWidth: 1080,
                child: const SystemOverviewSection(),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 92)),
            SliverToBoxAdapter(
              child: _SectionFrame(
                key: _projectsSectionKey,
                child: const PortfolioProjectsSection(),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 92)),
            SliverToBoxAdapter(
              child: ExperienceSection(key: _experienceSectionKey),
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
  const _TopBar({required this.onLocaleChanged});

  final ValueChanged<Locale> onLocaleChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 76,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: _bg.withValues(alpha: .9),
        border: Border(
          bottom: BorderSide(color: Colors.white.withValues(alpha: .07)),
        ),
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
                        'assets/brand/ld-mark-inverse.svg',
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
                  _AvailabilityBadge(compact: compact),
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
            foregroundColor: _ink,
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
                    style: TextStyle(color: englishSelected ? _ink : _muted),
                  ),
                  const TextSpan(
                    text: ' / ',
                    style: TextStyle(color: _muted),
                  ),
                  TextSpan(
                    text: 'PT',
                    style: TextStyle(color: englishSelected ? _muted : _ink),
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

class _AvailabilityBadge extends StatelessWidget {
  const _AvailabilityBadge({required this.compact});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: _green.withValues(alpha: .08),
        borderRadius: BorderRadius.circular(99),
        border: Border.all(color: _green.withValues(alpha: .22)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const _PulseDot(),
          const SizedBox(width: 8),
          Text(
            compact
                ? context.l10n.availableCompact
                : context.l10n.availableFull,
            style: const TextStyle(
              color: _green,
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: .8,
            ),
          ),
        ],
      ),
    );
  }
}

class _PulseDot extends StatelessWidget {
  const _PulseDot();

  @override
  Widget build(BuildContext context) => Container(
    width: 7,
    height: 7,
    decoration: const BoxDecoration(color: _green, shape: BoxShape.circle),
  );
}

class _Footer extends StatelessWidget {
  const _Footer();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 42),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.white.withValues(alpha: .07)),
        ),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1240),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final compact = constraints.maxWidth < 620;
              final signature = Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 28,
                    height: 28,
                    child: SvgPicture.asset('assets/brand/ld-mark-inverse.svg'),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'LEONE DAHER  •  2026',
                    style: TextStyle(color: _muted, fontSize: 11),
                  ),
                ],
              );
              if (compact) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.l10n.footerInvitation,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 18),
                    signature,
                  ],
                );
              }
              return Row(
                children: [
                  Expanded(
                    child: Text(
                      context.l10n.footerInvitation,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  signature,
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
