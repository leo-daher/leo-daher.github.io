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

class PortfolioContactButton extends StatefulWidget {
  const PortfolioContactButton({super.key, required this.compact});

  final bool compact;

  @override
  State<PortfolioContactButton> createState() => _PortfolioContactButtonState();
}

class _PortfolioContactButtonState extends State<PortfolioContactButton> {
  final MenuController _menuController = MenuController();
  final FocusNode _buttonFocusNode = FocusNode(
    debugLabel: 'Portfolio contact menu',
  );

  @override
  void dispose() {
    _buttonFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final palette = context.leonePalette;
    final menuWidth = (MediaQuery.sizeOf(context).width - 16)
        .clamp(0, 264)
        .toDouble();
    final destinations = [
      _ContactMenuDestination(
        id: 'whatsapp',
        label: l10n.contactWhatsApp,
        uri: PortfolioContactLinks.whatsApp,
        iconAsset: 'assets/brand/whatsapp-symbol.svg',
        isLead: true,
      ),
      _ContactMenuDestination(
        id: 'calendly',
        label: l10n.contactSchedule,
        uri: PortfolioContactLinks.calendly,
        icon: Icons.calendar_month_outlined,
        isLead: true,
      ),
      _ContactMenuDestination(
        id: 'linkedin',
        label: l10n.contactLinkedIn,
        uri: PortfolioContactLinks.linkedin,
        iconAsset: 'assets/brand/linkedin-symbol.svg',
      ),
      _ContactMenuDestination(
        id: 'github',
        label: l10n.contactGitHub,
        uri: PortfolioContactLinks.github,
        iconAsset: 'assets/brand/github-symbol.svg',
      ),
    ];

    return MenuAnchor(
      key: const Key('header-contact-menu'),
      controller: _menuController,
      childFocusNode: _buttonFocusNode,
      alignmentOffset: Offset(-menuWidth, 8),
      reservedPadding: const EdgeInsets.all(8),
      crossAxisUnconstrained: false,
      useRootOverlay: true,
      onOpen: _refreshMenuState,
      onClose: _refreshMenuState,
      style: MenuStyle(
        alignment: AlignmentDirectional.bottomEnd,
        backgroundColor: WidgetStatePropertyAll(palette.surfaceRaised),
        surfaceTintColor: const WidgetStatePropertyAll(Colors.transparent),
        shadowColor: WidgetStatePropertyAll(
          Colors.black.withValues(alpha: .30),
        ),
        elevation: const WidgetStatePropertyAll(8),
        padding: const WidgetStatePropertyAll(EdgeInsets.all(8)),
        fixedSize: WidgetStatePropertyAll(Size.fromWidth(menuWidth)),
        side: WidgetStatePropertyAll(BorderSide(color: palette.outline)),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
      ),
      menuChildren: [
        for (final destination in destinations)
          _PortfolioContactMenuLink(
            destination: destination,
            menuController: _menuController,
          ),
      ],
      builder: (context, controller, _) {
        final expanded = controller.isOpen;
        final visibleLabel = widget.compact ? l10n.hireMeCompact : l10n.hireMe;
        return Semantics(
          button: true,
          label: l10n.contactMenuLabel,
          expanded: expanded,
          value: expanded ? l10n.expanded : l10n.collapsed,
          onTap: _toggleMenu,
          child: ExcludeSemantics(
            child: Tooltip(
              message: l10n.contactMenuLabel,
              excludeFromSemantics: true,
              child: widget.compact
                  ? IconButton(
                      key: const Key('header-contact-button'),
                      focusNode: _buttonFocusNode,
                      onPressed: _toggleMenu,
                      style: IconButton.styleFrom(
                        foregroundColor: LeoneBrandColors.interactive,
                        fixedSize: const Size(48, 48),
                        backgroundColor: LeoneBrandColors.interactive
                            .withValues(alpha: .10),
                        side: BorderSide(
                          color: LeoneBrandColors.interactive.withValues(
                            alpha: .34,
                          ),
                        ),
                      ),
                      icon: Icon(
                        expanded ? Icons.close_rounded : Icons.forum_outlined,
                        size: 20,
                      ),
                    )
                  : TextButton.icon(
                      key: const Key('header-contact-button'),
                      focusNode: _buttonFocusNode,
                      onPressed: _toggleMenu,
                      style: TextButton.styleFrom(
                        foregroundColor: LeoneBrandColors.interactive,
                        minimumSize: const Size(0, 48),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        backgroundColor: LeoneBrandColors.interactive
                            .withValues(alpha: .10),
                        side: BorderSide(
                          color: LeoneBrandColors.interactive.withValues(
                            alpha: .34,
                          ),
                        ),
                        shape: const StadiumBorder(),
                      ),
                      icon: Icon(
                        expanded
                            ? Icons.keyboard_arrow_up_rounded
                            : Icons.keyboard_arrow_down_rounded,
                        size: 18,
                      ),
                      label: Text(
                        visibleLabel.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          letterSpacing: .8,
                        ),
                      ),
                    ),
            ),
          ),
        );
      },
    );
  }

  void _toggleMenu() {
    if (_menuController.isOpen) {
      _menuController.close();
    } else {
      _menuController.open();
    }
  }

  void _refreshMenuState() {
    if (mounted) setState(() {});
  }
}

class _ContactMenuDestination {
  const _ContactMenuDestination({
    required this.id,
    required this.label,
    required this.uri,
    this.icon,
    this.iconAsset,
    this.isLead = false,
  }) : assert(icon != null || iconAsset != null);

  final String id;
  final String label;
  final Uri uri;
  final IconData? icon;
  final String? iconAsset;
  final bool isLead;
}

class _PortfolioContactMenuLink extends StatelessWidget {
  const _PortfolioContactMenuLink({
    required this.destination,
    required this.menuController,
  });

  final _ContactMenuDestination destination;
  final MenuController menuController;

  @override
  Widget build(BuildContext context) {
    final palette = context.leonePalette;
    final accent = LeoneBrandColors.interactive;
    return Link(
      key: Key('header-contact-link-${destination.id}'),
      uri: destination.uri,
      target: LinkTarget.blank,
      builder: (context, followLink) {
        final openLink = followLink == null
            ? null
            : () {
                PortfolioTelemetry.contactIntent(
                  destination.id,
                  destination.uri,
                  isLead: destination.isLead,
                );
                followLink();
                menuController.close();
              };
        return Semantics(
          link: true,
          label: destination.label,
          onTap: openLink,
          child: ExcludeSemantics(
            child: MenuItemButton(
              key: Key('header-contact-item-${destination.id}'),
              closeOnActivate: false,
              onPressed: openLink,
              style: ButtonStyle(
                foregroundColor: WidgetStatePropertyAll(palette.ink),
                minimumSize: const WidgetStatePropertyAll(Size(0, 48)),
                padding: const WidgetStatePropertyAll(
                  EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                ),
                shape: WidgetStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
              leadingIcon: destination.iconAsset == null
                  ? Icon(destination.icon, color: accent, size: 21)
                  : SvgPicture.asset(
                      destination.iconAsset!,
                      width: 20,
                      height: 20,
                      colorFilter: ColorFilter.mode(accent, BlendMode.srcIn),
                      excludeFromSemantics: true,
                    ),
              child: Text(
                destination.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ),
        );
      },
    );
  }
}
