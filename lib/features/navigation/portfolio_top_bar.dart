import 'dart:ui';

import 'package:material_ui/material_ui.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../brand/leone_brand.dart';
import '../../l10n/l10n.dart';
import 'portfolio_header_actions.dart';

class PortfolioSliverTopBar extends StatelessWidget {
  const PortfolioSliverTopBar({
    super.key,
    required this.onHomePressed,
    required this.onLocaleChanged,
    required this.onThemeModeChanged,
  });

  final VoidCallback onHomePressed;
  final ValueChanged<Locale> onLocaleChanged;
  final ValueChanged<ThemeMode> onThemeModeChanged;

  @override
  Widget build(BuildContext context) {
    final palette = context.leonePalette;
    return SliverAppBar(
      key: const Key('portfolio-top-app-bar'),
      pinned: true,
      automaticallyImplyLeading: false,
      toolbarHeight: PortfolioTopBarContent.height,
      elevation: 0,
      scrolledUnderElevation: 3,
      shadowColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      backgroundColor: _topBarBackground(palette),
      flexibleSpace: const _FrostedTopBarBackdrop(),
      foregroundColor: palette.ink,
      titleSpacing: 0,
      title: PortfolioTopBarContent(
        onHomePressed: onHomePressed,
        onLocaleChanged: onLocaleChanged,
        onThemeModeChanged: onThemeModeChanged,
      ),
    );
  }
}

class PortfolioPageTopBar extends StatelessWidget
    implements PreferredSizeWidget {
  const PortfolioPageTopBar({
    super.key,
    required this.onBackPressed,
    required this.onLocaleChanged,
    required this.onThemeModeChanged,
  });

  final VoidCallback onBackPressed;
  final ValueChanged<Locale> onLocaleChanged;
  final ValueChanged<ThemeMode> onThemeModeChanged;

  @override
  Size get preferredSize =>
      const Size.fromHeight(PortfolioTopBarContent.height);

  @override
  Widget build(BuildContext context) {
    final palette = context.leonePalette;
    return AppBar(
      key: const Key('portfolio-page-app-bar'),
      automaticallyImplyLeading: false,
      toolbarHeight: PortfolioTopBarContent.height,
      elevation: 0,
      scrolledUnderElevation: 3,
      shadowColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      backgroundColor: _topBarBackground(palette),
      flexibleSpace: const _FrostedTopBarBackdrop(),
      foregroundColor: palette.ink,
      titleSpacing: 0,
      title: PortfolioTopBarContent(
        onBackPressed: onBackPressed,
        onLocaleChanged: onLocaleChanged,
        onThemeModeChanged: onThemeModeChanged,
      ),
    );
  }
}

WidgetStateColor _topBarBackground(LeonePalette palette) =>
    WidgetStateColor.resolveWith(
      (states) => states.contains(WidgetState.scrolledUnder)
          ? palette.canvas.withValues(alpha: .72)
          : palette.canvas,
    );

class _FrostedTopBarBackdrop extends StatelessWidget {
  const _FrostedTopBarBackdrop();

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: const SizedBox.expand(),
      ),
    );
  }
}

class PortfolioTopBarContent extends StatelessWidget {
  const PortfolioTopBarContent({
    super.key,
    this.onHomePressed,
    this.onBackPressed,
    required this.onLocaleChanged,
    required this.onThemeModeChanged,
  }) : assert((onHomePressed == null) != (onBackPressed == null));

  static const height = 72.0;

  final VoidCallback? onHomePressed;
  final VoidCallback? onBackPressed;
  final ValueChanged<Locale> onLocaleChanged;
  final ValueChanged<ThemeMode> onThemeModeChanged;

  @override
  Widget build(BuildContext context) {
    final compactControls = MediaQuery.sizeOf(context).width < 440;
    final showBrandName = MediaQuery.sizeOf(context).width >= 520;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1440),
        child: Padding(
          key: const Key('portfolio-top-bar-content'),
          padding: EdgeInsets.symmetric(horizontal: compactControls ? 16 : 24),
          child: Row(
            children: [
              _LeadingAction(
                onHomePressed: onHomePressed,
                onBackPressed: onBackPressed,
              ),
              if (showBrandName) ...[
                const SizedBox(width: 12),
                const Text(
                  'LEONE DAHER',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 12,
                    letterSpacing: 1.8,
                  ),
                ),
              ],
              const Spacer(),
              PortfolioHeaderActions(
                compact: compactControls,
                onLocaleChanged: onLocaleChanged,
                onThemeModeChanged: onThemeModeChanged,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LeadingAction extends StatelessWidget {
  const _LeadingAction({this.onHomePressed, this.onBackPressed});

  final VoidCallback? onHomePressed;
  final VoidCallback? onBackPressed;

  @override
  Widget build(BuildContext context) {
    if (onBackPressed != null) {
      return IconButton(
        key: const Key('article-back-button'),
        tooltip: MaterialLocalizations.of(context).backButtonTooltip,
        onPressed: onBackPressed,
        style: IconButton.styleFrom(fixedSize: const Size(48, 48)),
        icon: const Icon(Icons.arrow_back_rounded),
      );
    }

    final lightMode = Theme.of(context).brightness == Brightness.light;
    return Tooltip(
      message: context.l10n.navHome,
      child: Semantics(
        button: true,
        label: 'Leone Daher · ${context.l10n.navHome}',
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            key: const Key('ld-topbar-mark'),
            onTap: onHomePressed,
            customBorder: const CircleBorder(),
            child: SizedBox(
              width: 48,
              height: 48,
              child: Center(
                child: SizedBox(
                  width: 34,
                  height: 34,
                  child: SvgPicture.asset(
                    lightMode
                        ? 'assets/brand/ld-mark.svg'
                        : 'assets/brand/ld-mark-inverse.svg',
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
