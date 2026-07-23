import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';

import '../../brand/leone_brand.dart';
import '../../ld_identity.dart';
import '../../l10n/l10n.dart';

const _bg = LeoneBrandColors.canvas;
const _green = LeoneBrandColors.interactive;

enum PortfolioDestination { home, apps, system, clients, contact }

class PortfolioFabMenuScaffold extends StatefulWidget {
  const PortfolioFabMenuScaffold({
    super.key,
    required this.body,
    required this.showFloatingActionButton,
    required this.floatingActionButtonEnabled,
    required this.onSelected,
  });

  final Widget body;
  final bool showFloatingActionButton;
  final bool floatingActionButtonEnabled;
  final ValueChanged<PortfolioDestination> onSelected;

  @override
  State<PortfolioFabMenuScaffold> createState() =>
      _PortfolioFabMenuScaffoldState();
}

class _PortfolioFabMenuScaffoldState extends State<PortfolioFabMenuScaffold>
    with SingleTickerProviderStateMixin {
  bool _expanded = false;
  late final AnimationController _menuController = AnimationController(
    vsync: this,
    duration: LeoneBrandMotion.fabMenuExpand,
    reverseDuration: LeoneBrandMotion.fabMenuCollapse,
  );

  @override
  void dispose() {
    _menuController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant PortfolioFabMenuScaffold oldWidget) {
    super.didUpdateWidget(oldWidget);
    if ((!widget.showFloatingActionButton ||
            !widget.floatingActionButtonEnabled) &&
        _expanded) {
      _expanded = false;
      _animateMenu(expanded: false);
    }
  }

  void _animateMenu({required bool expanded}) {
    if (MediaQuery.maybeOf(context)?.disableAnimations ?? false) {
      _menuController.value = expanded ? 1 : 0;
      return;
    }
    if (expanded) {
      _menuController.forward();
    } else {
      _menuController.reverse();
    }
  }

  void _setExpanded(bool expanded) {
    if (_expanded == expanded) return;
    setState(() => _expanded = expanded);
    _animateMenu(expanded: expanded);
  }

  void _toggle() => _setExpanded(!_expanded);

  void _close() => _setExpanded(false);

  void _select(PortfolioDestination destination) {
    _close();
    widget.onSelected(destination);
  }

  @override
  Widget build(BuildContext context) {
    return CallbackShortcuts(
      bindings: {const SingleActivator(LogicalKeyboardKey.escape): _close},
      child: PopScope<void>(
        canPop: !_expanded,
        onPopInvokedWithResult: (didPop, _) {
          if (!didPop) _close();
        },
        child: Scaffold(
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          floatingActionButton: widget.showFloatingActionButton
              ? IgnorePointer(
                  ignoring: !widget.floatingActionButtonEnabled,
                  child: _PortfolioFabMenu(
                    expanded: _expanded,
                    animation: _menuController,
                    onToggle: _toggle,
                    onSelected: _select,
                  ),
                )
              : null,
          body: Stack(
            children: [
              widget.body,
              Positioned.fill(
                child: _PortfolioMenuBackdrop(
                  animation: _menuController,
                  expanded: _expanded,
                  semanticsLabel: context.l10n.dismissNavigationMenu,
                  onDismiss: _close,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PortfolioFabMenu extends StatefulWidget {
  const _PortfolioFabMenu({
    required this.expanded,
    required this.animation,
    required this.onToggle,
    required this.onSelected,
  });

  final bool expanded;
  final Animation<double> animation;
  final VoidCallback onToggle;
  final ValueChanged<PortfolioDestination> onSelected;

  @override
  State<_PortfolioFabMenu> createState() => _PortfolioFabMenuState();
}

class _PortfolioFabMenuState extends State<_PortfolioFabMenu> {
  static const _actions = <_PortfolioFabMenuAction>[
    _PortfolioFabMenuAction(
      destination: PortfolioDestination.home,
      icon: Icons.home_outlined,
      key: Key('fab-menu-home'),
    ),
    _PortfolioFabMenuAction(
      destination: PortfolioDestination.apps,
      icon: Icons.apps_outlined,
      key: Key('fab-menu-apps'),
    ),
    _PortfolioFabMenuAction(
      destination: PortfolioDestination.system,
      icon: Icons.account_tree_outlined,
      key: Key('fab-menu-system'),
    ),
    _PortfolioFabMenuAction(
      destination: PortfolioDestination.clients,
      icon: Icons.domain_outlined,
      key: Key('fab-menu-clients'),
    ),
    _PortfolioFabMenuAction(
      destination: PortfolioDestination.contact,
      icon: Icons.alternate_email_rounded,
      key: Key('fab-menu-contact'),
    ),
  ];

  late final FocusNode _toggleFocusNode = FocusNode(
    debugLabel: 'portfolio-fab-toggle',
  );
  late final List<FocusNode> _itemFocusNodes = List.generate(
    _actions.length,
    (index) => FocusNode(debugLabel: 'portfolio-fab-item-$index'),
  );

  @override
  void initState() {
    super.initState();
    widget.animation.addStatusListener(_handleAnimationStatus);
  }

  @override
  void didUpdateWidget(covariant _PortfolioFabMenu oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.animation == oldWidget.animation) return;
    oldWidget.animation.removeStatusListener(_handleAnimationStatus);
    widget.animation.addStatusListener(_handleAnimationStatus);
  }

  void _handleAnimationStatus(AnimationStatus status) {
    if (status == AnimationStatus.dismissed && !widget.expanded) {
      _restoreToggleFocus();
    }
  }

  void _restoreToggleFocus() {
    if (mounted) _toggleFocusNode.requestFocus();
  }

  @override
  void dispose() {
    widget.animation.removeStatusListener(_handleAnimationStatus);
    _toggleFocusNode.dispose();
    for (final node in _itemFocusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  KeyEventResult _handleToggleKey(FocusNode _, KeyEvent event) {
    if (!widget.expanded || event is! KeyDownEvent) {
      return KeyEventResult.ignored;
    }
    final key = event.logicalKey;
    final moveIntoMenu =
        key == LogicalKeyboardKey.arrowDown ||
        (key == LogicalKeyboardKey.tab &&
            !HardwareKeyboard.instance.isShiftPressed);
    if (!moveIntoMenu) return KeyEventResult.ignored;
    _itemFocusNodes.first.requestFocus();
    return KeyEventResult.handled;
  }

  KeyEventResult _handleFirstItemKey(FocusNode _, KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;
    final key = event.logicalKey;
    final moveToToggle =
        key == LogicalKeyboardKey.arrowUp ||
        (key == LogicalKeyboardKey.tab &&
            HardwareKeyboard.instance.isShiftPressed);
    if (!moveToToggle) return KeyEventResult.ignored;
    _toggleFocusNode.requestFocus();
    return KeyEventResult.handled;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return FocusTraversalGroup(
      policy: OrderedTraversalPolicy(),
      child: Semantics(
        container: true,
        explicitChildNodes: true,
        child: Column(
          key: const Key('portfolio-fab-menu'),
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            for (var index = 0; index < _actions.length; index++)
              FocusTraversalOrder(
                order: NumericFocusOrder(index + 1),
                child: Focus(
                  onKeyEvent: index == 0 ? _handleFirstItemKey : null,
                  child: _StaggeredFabMenuItem(
                    animation: widget.animation,
                    index: index,
                    itemCount: _actions.length,
                    action: _actions[index],
                    label: switch (_actions[index].destination) {
                      PortfolioDestination.home => l10n.navHome,
                      PortfolioDestination.apps => l10n.navApps,
                      PortfolioDestination.system => l10n.navSystem,
                      PortfolioDestination.clients => l10n.navClients,
                      PortfolioDestination.contact => l10n.navContact,
                    },
                    closeMenuLabel: l10n.closeMenu,
                    focusNode: _itemFocusNodes[index],
                    isLast: index == _actions.length - 1,
                    onClose: widget.onToggle,
                    onPressed: () =>
                        widget.onSelected(_actions[index].destination),
                  ),
                ),
              ),
            AnimatedBuilder(
              animation: widget.animation,
              builder: (context, _) => SizedBox(
                height: 8 * Curves.easeOut.transform(widget.animation.value),
              ),
            ),
            FocusTraversalOrder(
              order: const NumericFocusOrder(0),
              child: Focus(
                onKeyEvent: _handleToggleKey,
                child: AnimatedBuilder(
                  animation: widget.animation,
                  builder: (context, _) {
                    final progress = Curves.easeOutCubic.transform(
                      widget.animation.value,
                    );
                    final color = Color.lerp(
                      ldFloatingActionColor,
                      _green,
                      progress,
                    )!;
                    final radius =
                        ldFloatingActionRadius +
                        (LeoneBrandGeometry.fabExpandedRadius -
                                ldFloatingActionRadius) *
                            progress;
                    final label = widget.expanded
                        ? l10n.closeNavigationMenu
                        : l10n.openNavigationMenu;
                    return Tooltip(
                      message: label,
                      excludeFromSemantics: true,
                      child: Semantics(
                        button: true,
                        toggled: widget.expanded,
                        label: label,
                        value: widget.expanded ? l10n.expanded : l10n.collapsed,
                        onTap: widget.onToggle,
                        child: ExcludeSemantics(
                          child: FloatingActionButton(
                            key: const Key('portfolio-floating-action'),
                            focusNode: _toggleFocusNode,
                            onPressed: widget.onToggle,
                            elevation: 6,
                            hoverElevation: 8,
                            focusElevation: 8,
                            highlightElevation: 6,
                            backgroundColor: color,
                            foregroundColor: _bg,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(radius),
                            ),
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 180),
                              switchInCurve: Curves.easeOut,
                              switchOutCurve: Curves.easeIn,
                              transitionBuilder: (child, animation) =>
                                  FadeTransition(
                                    opacity: animation,
                                    child: child,
                                  ),
                              child: Icon(
                                widget.expanded
                                    ? Icons.close_rounded
                                    : Icons.menu_rounded,
                                key: ValueKey(widget.expanded),
                                size: widget.expanded ? 20 : 24,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PortfolioMenuBackdrop extends StatelessWidget {
  const _PortfolioMenuBackdrop({
    required this.animation,
    required this.expanded,
    required this.semanticsLabel,
    required this.onDismiss,
  });

  final Animation<double> animation;
  final bool expanded;
  final String semanticsLabel;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, _) {
        if (animation.isDismissed && !expanded) {
          return const SizedBox.shrink();
        }
        final progress = Curves.easeOutCubic.transform(animation.value);
        final sigma = LeoneBrandGeometry.fabMenuBackdropSigma * progress;
        return IgnorePointer(
          ignoring: !expanded,
          child: ExcludeSemantics(
            excluding: !expanded,
            child: ClipRect(
              child: BackdropFilter(
                key: const Key('portfolio-menu-backdrop'),
                filter: ui.ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
                child: ModalBarrier(
                  key: const Key('portfolio-menu-backdrop-barrier'),
                  color: Colors.transparent,
                  dismissible: expanded,
                  semanticsLabel: semanticsLabel,
                  onDismiss: expanded ? onDismiss : null,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _PortfolioFabMenuAction {
  const _PortfolioFabMenuAction({
    required this.destination,
    required this.icon,
    required this.key,
  });

  final PortfolioDestination destination;
  final IconData icon;
  final Key key;
}

class _StaggeredFabMenuItem extends StatelessWidget {
  const _StaggeredFabMenuItem({
    required this.animation,
    required this.index,
    required this.itemCount,
    required this.action,
    required this.label,
    required this.closeMenuLabel,
    required this.focusNode,
    required this.isLast,
    required this.onClose,
    required this.onPressed,
  });

  final Animation<double> animation;
  final int index;
  final int itemCount;
  final _PortfolioFabMenuAction action;
  final String label;
  final String closeMenuLabel;
  final FocusNode focusNode;
  final bool isLast;
  final VoidCallback onClose;
  final VoidCallback onPressed;

  double _progress() {
    final revealOrder = itemCount - 1 - index;
    final start = revealOrder * .065;
    final end = (start + .74).clamp(0.0, 1.0);
    final value = ((animation.value - start) / (end - start)).clamp(0.0, 1.0);
    return LeoneBrandMotion.fabMenuSpatialCurve.transform(value);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final labelStyle = Theme.of(context).textTheme.titleMedium?.copyWith(
      color: scheme.onPrimaryContainer,
      fontWeight: FontWeight.w700,
    );
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final progress = _progress();
        final visible = progress > .94;
        return ExcludeSemantics(
          excluding: !visible,
          child: ExcludeFocus(
            excluding: !visible,
            child: IgnorePointer(
              ignoring: !visible,
              child: Opacity(
                opacity: progress,
                child: Transform.translate(
                  offset: Offset(0, 10 * (1 - progress)),
                  child: Transform.scale(
                    alignment: Alignment.centerRight,
                    scaleX: .82 + (.18 * progress),
                    child: Padding(
                      padding: EdgeInsets.only(bottom: isLast ? 0 : 4),
                      child: child,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
      child: Semantics(
        button: true,
        label: label,
        customSemanticsActions: isLast
            ? {CustomSemanticsAction(label: closeMenuLabel): onClose}
            : null,
        child: Material(
          key: action.key,
          color: scheme.primaryContainer,
          shadowColor: Colors.black.withValues(alpha: .42),
          surfaceTintColor: scheme.surfaceTint,
          elevation: 6,
          shape: const StadiumBorder(),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            focusNode: focusNode,
            onTap: onPressed,
            child: ConstrainedBox(
              constraints: const BoxConstraints(minWidth: 56, minHeight: 56),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      action.icon,
                      size: 24,
                      color: scheme.onPrimaryContainer,
                    ),
                    const SizedBox(width: 8),
                    Text(label, style: labelStyle),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
