import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';
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

class _PortfolioContactButtonState extends State<PortfolioContactButton>
    with SingleTickerProviderStateMixin {
  final MenuController _menuController = MenuController();
  final FocusNode _buttonFocusNode = FocusNode(
    debugLabel: 'Portfolio contact menu',
  );
  final FocusScopeNode _menuFocus = FocusScopeNode(
    debugLabel: 'Contact destinations',
    traversalEdgeBehavior: TraversalEdgeBehavior.closedLoop,
  );
  final List<FocusNode> _itemFocus = List.generate(4, (_) => FocusNode());
  late final AnimationController _motion = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 420),
    reverseDuration: const Duration(milliseconds: 260),
  )..addStatusListener(_onMotionStatus);
  VoidCallback? _hideOverlay;
  bool _expanded = false;
  int _initialFocus = 0;

  bool get _reduceMotion =>
      MediaQuery.disableAnimationsOf(context) ||
      WidgetsBinding
          .instance
          .platformDispatcher
          .accessibilityFeatures
          .reduceMotion;

  @override
  void dispose() {
    _motion.dispose();
    _menuFocus.dispose();
    for (final node in _itemFocus) {
      node.dispose();
    }
    _buttonFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
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

    return RawMenuAnchor(
      key: const Key('header-contact-menu'),
      controller: _menuController,
      childFocusNode: _buttonFocusNode,
      useRootOverlay: true,
      onOpenRequested: _openMenu,
      onCloseRequested: _closeMenu,
      overlayBuilder: (context, info) =>
          _buildMenu(context, info, destinations),
      builder: (context, controller, _) {
        final expanded = _expanded;
        final visibleLabel = widget.compact ? l10n.hireMeCompact : l10n.hireMe;
        return CallbackShortcuts(
          bindings: {
            const SingleActivator(LogicalKeyboardKey.arrowDown): () =>
                _openFromKeyboard(0),
            const SingleActivator(LogicalKeyboardKey.arrowUp): () =>
                _openFromKeyboard(_itemFocus.length - 1),
            const SingleActivator(LogicalKeyboardKey.escape):
                _menuController.close,
          },
          child: Semantics(
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
                              .withValues(alpha: expanded ? .22 : .10),
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
                              .withValues(alpha: expanded ? .22 : .10),
                          side: BorderSide(
                            color: LeoneBrandColors.interactive.withValues(
                              alpha: .34,
                            ),
                          ),
                          shape: const StadiumBorder(),
                        ),
                        icon: AnimatedRotation(
                          turns: expanded ? .5 : 0,
                          duration: _reduceMotion
                              ? Duration.zero
                              : const Duration(milliseconds: 260),
                          curve: Curves.easeInOutCubic,
                          child: const Icon(
                            Icons.keyboard_arrow_down_rounded,
                            size: 18,
                          ),
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
          ),
        );
      },
    );
  }

  void _toggleMenu() {
    if (_expanded) {
      _menuController.close();
    } else {
      _initialFocus = 0;
      _menuController.open();
    }
  }

  void _openFromKeyboard(int index) {
    _initialFocus = index;
    if (_expanded && _motion.isCompleted) {
      _itemFocus[index].requestFocus();
    } else {
      _menuController.open();
    }
  }

  void _openMenu(Offset? position, VoidCallback showOverlay) {
    _hideOverlay = null;
    setState(() => _expanded = true);
    showOverlay();
    if (_reduceMotion) {
      _motion.value = 1;
    } else {
      _motion.forward();
    }
  }

  void _closeMenu(VoidCallback hideOverlay) {
    if (!_expanded) return;
    setState(() => _expanded = false);
    if (_menuFocus.hasFocus) _buttonFocusNode.requestFocus();
    _hideOverlay = hideOverlay;
    if (_reduceMotion || _motion.isDismissed) {
      _motion.value = 0;
      _finishClosing();
    } else {
      _motion.reverse();
    }
  }

  void _onMotionStatus(AnimationStatus status) {
    if (status == AnimationStatus.dismissed) _finishClosing();
    if (status == AnimationStatus.completed) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _expanded) _itemFocus[_initialFocus].requestFocus();
      });
    }
  }

  void _finishClosing() {
    final hide = _hideOverlay;
    _hideOverlay = null;
    hide?.call();
  }

  Widget _buildMenu(
    BuildContext context,
    RawMenuOverlayInfo info,
    List<_ContactMenuDestination> destinations,
  ) {
    final width = math.min(288.0, math.max(0.0, info.overlaySize.width - 16));
    // Allow large system text without clipping the contact labels vertically.
    final labelStyle = Theme.of(context).textTheme.labelLarge!;
    final rowHeight = math.max(
      52.0,
      MediaQuery.textScalerOf(context).scale(labelStyle.fontSize ?? 14) *
              (labelStyle.height ?? 1.43) +
          24,
    );
    final fullHeight = rowHeight * destinations.length + 16;
    final height = math.min(
      fullHeight,
      math.max(0.0, info.overlaySize.height - 16),
    );
    final left = (info.anchorRect.right - width)
        .clamp(8.0, math.max(8.0, info.overlaySize.width - width - 8))
        .toDouble();
    final top = (info.anchorRect.bottom + 10)
        .clamp(8.0, math.max(8.0, info.overlaySize.height - height - 8))
        .toDouble();
    final target = Rect.fromLTWH(left, top, width, height);
    final palette = context.leonePalette;
    final dark = Theme.of(context).brightness == Brightness.dark;
    final highContrast = MediaQuery.highContrastOf(context);
    final tint = dark ? const Color(0xFF262433) : const Color(0xFFF8F7FC);

    return AnimatedBuilder(
      animation: _motion,
      builder: (context, _) {
        final progress = Curves.easeOutCubic.transform(_motion.value);
        final rect = Rect.lerp(info.anchorRect, target, progress)!;
        final radius = BorderRadius.circular(24 + 4 * progress);
        final reveal = const Interval(
          .18,
          .85,
          curve: Curves.easeOut,
        ).transform(_motion.value);
        return Positioned.fromRect(
          rect: rect,
          child: TapRegion(
            groupId: info.tapRegionGroupId,
            onTapOutside: (_) => _menuController.close(),
            child: IgnorePointer(
              ignoring: !_expanded || _motion.value < .5,
              child: ExcludeSemantics(
                excluding: !_expanded || reveal == 0,
                child: ExcludeFocus(
                  excluding: !_expanded,
                  child: Semantics(
                    scopesRoute: true,
                    explicitChildNodes: true,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: radius,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(
                              alpha: (dark ? .32 : .14) * progress,
                            ),
                            blurRadius: 32,
                            offset: const Offset(0, 12),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        key: const Key('header-contact-glass-surface'),
                        borderRadius: radius,
                        child: BackdropFilter(
                          enabled: !highContrast,
                          filter: ui.ImageFilter.blur(sigmaX: 28, sigmaY: 28),
                          child: DecoratedBox(
                            key: const Key('header-contact-glass-tint'),
                            decoration: BoxDecoration(
                              color: tint.withValues(
                                alpha: highContrast ? 1 : (dark ? .90 : .86),
                              ),
                              borderRadius: radius,
                              border: Border.all(
                                color: highContrast
                                    ? palette.ink
                                    : Colors.white.withValues(
                                        alpha: dark ? .24 : .88,
                                      ),
                              ),
                              gradient: highContrast
                                  ? null
                                  : LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Color.alphaBlend(
                                          Colors.white.withValues(
                                            alpha: dark ? .09 : .32,
                                          ),
                                          tint.withValues(
                                            alpha: dark ? .90 : .86,
                                          ),
                                        ),
                                        tint.withValues(
                                          alpha: dark ? .90 : .86,
                                        ),
                                      ],
                                    ),
                            ),
                            child: OverflowBox(
                              alignment: Alignment.topRight,
                              minWidth: width,
                              maxWidth: width,
                              minHeight: height,
                              maxHeight: height,
                              child: Opacity(
                                opacity: reveal,
                                child: FocusScope(
                                  node: _menuFocus,
                                  child: CallbackShortcuts(
                                    bindings: {
                                      const SingleActivator(
                                        LogicalKeyboardKey.escape,
                                      ): _menuController.close,
                                      const SingleActivator(
                                        LogicalKeyboardKey.arrowDown,
                                      ): () =>
                                          _moveFocus(1),
                                      const SingleActivator(
                                        LogicalKeyboardKey.arrowUp,
                                      ): () =>
                                          _moveFocus(-1),
                                      const SingleActivator(
                                        LogicalKeyboardKey.home,
                                      ): () =>
                                          _itemFocus.first.requestFocus(),
                                      const SingleActivator(
                                        LogicalKeyboardKey.end,
                                      ): () =>
                                          _itemFocus.last.requestFocus(),
                                    },
                                    child: Material(
                                      type: MaterialType.transparency,
                                      child: SingleChildScrollView(
                                        padding: const EdgeInsets.all(8),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: [
                                            for (
                                              var index = 0;
                                              index < destinations.length;
                                              index++
                                            )
                                              SizedBox(
                                                height: rowHeight,
                                                child:
                                                    _PortfolioContactMenuLink(
                                                      destination:
                                                          destinations[index],
                                                      menuController:
                                                          _menuController,
                                                      focusNode:
                                                          _itemFocus[index],
                                                    ),
                                              ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _moveFocus(int delta) {
    final current = _itemFocus.indexWhere((node) => node.hasFocus);
    _itemFocus[(current + delta) % _itemFocus.length].requestFocus();
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
    required this.focusNode,
  });

  final _ContactMenuDestination destination;
  final MenuController menuController;
  final FocusNode focusNode;

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
            child: TextButton(
              key: Key('header-contact-item-${destination.id}'),
              focusNode: focusNode,
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
              child: Row(
                children: [
                  destination.iconAsset == null
                      ? Icon(destination.icon, color: accent, size: 21)
                      : SvgPicture.asset(
                          destination.iconAsset!,
                          width: 20,
                          height: 20,
                          colorFilter: ColorFilter.mode(
                            accent,
                            BlendMode.srcIn,
                          ),
                          excludeFromSemantics: true,
                        ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      destination.label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
