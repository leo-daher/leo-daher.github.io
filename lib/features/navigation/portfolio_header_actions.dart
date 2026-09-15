import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/link.dart';

import '../../brand/leone_brand.dart';
import '../../l10n/l10n.dart';
import '../../telemetry/portfolio_telemetry.dart';
import '../contact/portfolio_contact_links.dart';

class PortfolioHeaderActions extends StatelessWidget {
  const PortfolioHeaderActions({
    super.key,
    required this.compact,
    required this.onLocaleChanged,
    required this.onThemeModeChanged,
  });

  final bool compact;
  final ValueChanged<Locale> onLocaleChanged;
  final ValueChanged<ThemeMode> onThemeModeChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        PortfolioLanguageToggle(onLocaleChanged: onLocaleChanged),
        SizedBox(width: compact ? 4 : 10),
        PortfolioThemeToggle(onThemeModeChanged: onThemeModeChanged),
        SizedBox(width: compact ? 4 : 10),
        PortfolioContactButton(compact: compact),
      ],
    );
  }
}

class PortfolioLanguageToggle extends StatelessWidget {
  const PortfolioLanguageToggle({super.key, required this.onLocaleChanged});

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

class PortfolioThemeToggle extends StatelessWidget {
  const PortfolioThemeToggle({super.key, required this.onThemeModeChanged});

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

class PortfolioContactButton extends StatelessWidget {
  const PortfolioContactButton({super.key, required this.compact});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    final label = compact ? context.l10n.hireMeCompact : context.l10n.hireMe;
    final uri = PortfolioContactLinks.whatsApp;

    return Link(
      key: const Key('header-contact-link'),
      uri: uri,
      target: LinkTarget.blank,
      builder: (context, followLink) => Semantics(
        link: true,
        label: label,
        onTap: followLink == null ? null : () => _openContact(followLink, uri),
        child: ExcludeSemantics(
          child: Tooltip(
            message: label,
            excludeFromSemantics: true,
            child: compact
                ? IconButton(
                    key: const Key('header-contact-button'),
                    onPressed: followLink == null
                        ? null
                        : () => _openContact(followLink, uri),
                    style: IconButton.styleFrom(
                      foregroundColor: LeoneBrandColors.interactive,
                      fixedSize: const Size(48, 48),
                      backgroundColor: LeoneBrandColors.interactive.withValues(
                        alpha: .10,
                      ),
                      side: BorderSide(
                        color: LeoneBrandColors.interactive.withValues(
                          alpha: .34,
                        ),
                      ),
                    ),
                    icon: SvgPicture.asset(
                      'assets/brand/whatsapp-symbol.svg',
                      width: 18,
                      height: 18,
                      colorFilter: const ColorFilter.mode(
                        LeoneBrandColors.interactive,
                        BlendMode.srcIn,
                      ),
                      excludeFromSemantics: true,
                    ),
                  )
                : TextButton.icon(
                    key: const Key('header-contact-button'),
                    onPressed: followLink == null
                        ? null
                        : () => _openContact(followLink, uri),
                    style: TextButton.styleFrom(
                      foregroundColor: LeoneBrandColors.interactive,
                      minimumSize: const Size(0, 48),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      backgroundColor: LeoneBrandColors.interactive.withValues(
                        alpha: .10,
                      ),
                      side: BorderSide(
                        color: LeoneBrandColors.interactive.withValues(
                          alpha: .34,
                        ),
                      ),
                      shape: const StadiumBorder(),
                    ),
                    icon: const Icon(Icons.arrow_outward_rounded, size: 17),
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
        ),
      ),
    );
  }

  void _openContact(VoidCallback followLink, Uri uri) {
    PortfolioTelemetry.contactIntent('whatsapp', uri, isLead: true);
    followLink();
  }
}
