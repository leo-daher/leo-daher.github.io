import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'brand/leone_brand.dart';
import 'ld_identity.dart';
import 'world_experience_map.dart';

void main() => runApp(const LeonePortfolioApp());

const _bg = LeoneBrandColors.canvas;
const _panel = LeoneBrandColors.surface;
const _panelSoft = LeoneBrandColors.surfaceRaised;
const _ink = LeoneBrandColors.ink;
const _muted = LeoneBrandColors.mutedInk;
const _green = LeoneBrandColors.interactive;
const _blue = LeoneBrandColors.intelligence;
const _coral = LeoneBrandColors.editorialHighlight;
const _amber = LeoneBrandColors.editorialWarm;
const _radarInk = Color(0xFF07110D);
const _radarSurface = Color(0xFF0D1915);
const _radarRaised = Color(0xFF16241F);
const _radarMint = Color(0xFF22E29A);
const _radarCoral = Color(0xFFFF6B55);
const _radarMuted = Color(0xFF8FA39A);

class LeonePortfolioApp extends StatelessWidget {
  const LeonePortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '${LeoneBrand.name} — Software Engineer',
      theme: LeoneBrandTheme.dark(),
      home: const _PortfolioEntry(),
    );
  }
}

class _PortfolioEntry extends StatefulWidget {
  const _PortfolioEntry();

  @override
  State<_PortfolioEntry> createState() => _PortfolioEntryState();
}

class _PortfolioEntryState extends State<_PortfolioEntry> {
  bool _showOpening = true;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ExcludeSemantics(
          excluding: _showOpening,
          child: PortfolioHomePage(floatingActionButtonEnabled: !_showOpening),
        ),
        if (_showOpening)
          LdOpeningTransition(
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
  });

  final bool showFloatingActionButton;
  final bool floatingActionButtonEnabled;

  @override
  State<PortfolioHomePage> createState() => _PortfolioHomePageState();
}

enum _PortfolioDestination { home, system, projects, experience }

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
  bool _fabMenuExpanded = false;

  @override
  void didUpdateWidget(covariant PortfolioHomePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!widget.showFloatingActionButton && _fabMenuExpanded) {
      _fabMenuExpanded = false;
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _toggleFabMenu() {
    setState(() => _fabMenuExpanded = !_fabMenuExpanded);
  }

  void _closeFabMenu() {
    if (!_fabMenuExpanded) return;
    setState(() => _fabMenuExpanded = false);
  }

  void _navigateTo(_PortfolioDestination destination) {
    _closeFabMenu();
    if (destination == _PortfolioDestination.home) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 720),
        curve: Curves.easeInOutCubic,
      );
      return;
    }

    final target = switch (destination) {
      _PortfolioDestination.system => _systemSectionKey.currentContext,
      _PortfolioDestination.projects => _projectsSectionKey.currentContext,
      _PortfolioDestination.experience => _experienceSectionKey.currentContext,
      _PortfolioDestination.home => null,
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
    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.escape): _closeFabMenu,
      },
      child: PopScope<void>(
        canPop: !_fabMenuExpanded,
        onPopInvokedWithResult: (didPop, _) {
          if (!didPop) _closeFabMenu();
        },
        child: Scaffold(
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          floatingActionButton: widget.showFloatingActionButton
              ? IgnorePointer(
                  ignoring: !widget.floatingActionButtonEnabled,
                  child: _PortfolioFabMenu(
                    expanded: _fabMenuExpanded,
                    onToggle: _toggleFabMenu,
                    onSelected: _navigateTo,
                  ),
                )
              : null,
          body: Stack(
            children: [
              SelectionArea(
                child: CustomScrollView(
                  controller: _scrollController,
                  slivers: [
                    const SliverToBoxAdapter(child: _TopBar()),
                    SliverToBoxAdapter(
                      child: _SectionFrame(
                        maxWidth: 1440,
                        padding: const EdgeInsets.fromLTRB(24, 30, 24, 0),
                        child: const _Hero(),
                      ),
                    ),
                    const SliverToBoxAdapter(child: SizedBox(height: 42)),
                    SliverToBoxAdapter(
                      child: _SectionFrame(
                        key: _systemSectionKey,
                        maxWidth: 1080,
                        child: const _SystemOverviewSection(),
                      ),
                    ),
                    const SliverToBoxAdapter(child: SizedBox(height: 92)),
                    SliverToBoxAdapter(
                      child: _SectionFrame(
                        key: _projectsSectionKey,
                        child: const _ProjectProof(),
                      ),
                    ),
                    const SliverToBoxAdapter(child: SizedBox(height: 92)),
                    SliverToBoxAdapter(
                      child: _ExperienceSection(key: _experienceSectionKey),
                    ),
                    const SliverToBoxAdapter(child: SizedBox(height: 72)),
                    const SliverToBoxAdapter(child: _Footer()),
                  ],
                ),
              ),
              if (_fabMenuExpanded)
                Positioned.fill(
                  child: ModalBarrier(
                    color: Colors.transparent,
                    dismissible: true,
                    semanticsLabel: 'Descartar menu de navegação',
                    onDismiss: _closeFabMenu,
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
    required this.onToggle,
    required this.onSelected,
  });

  final bool expanded;
  final VoidCallback onToggle;
  final ValueChanged<_PortfolioDestination> onSelected;

  @override
  State<_PortfolioFabMenu> createState() => _PortfolioFabMenuState();
}

class _PortfolioFabMenuState extends State<_PortfolioFabMenu>
    with SingleTickerProviderStateMixin {
  static const _actions = <_PortfolioFabMenuAction>[
    _PortfolioFabMenuAction(
      destination: _PortfolioDestination.home,
      label: 'Início',
      icon: Icons.home_outlined,
      key: Key('fab-menu-home'),
    ),
    _PortfolioFabMenuAction(
      destination: _PortfolioDestination.system,
      label: 'Sistema',
      icon: Icons.account_tree_outlined,
      key: Key('fab-menu-system'),
    ),
    _PortfolioFabMenuAction(
      destination: _PortfolioDestination.projects,
      label: 'Projetos',
      icon: Icons.work_outline_rounded,
      key: Key('fab-menu-projects'),
    ),
    _PortfolioFabMenuAction(
      destination: _PortfolioDestination.experience,
      label: 'Experiência',
      icon: Icons.public_rounded,
      key: Key('fab-menu-experience'),
    ),
  ];

  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: LeoneBrandMotion.fabMenuExpand,
    reverseDuration: LeoneBrandMotion.fabMenuCollapse,
    value: widget.expanded ? 1 : 0,
  );
  late final FocusNode _toggleFocusNode = FocusNode(
    debugLabel: 'portfolio-fab-toggle',
  );
  late final List<FocusNode> _itemFocusNodes = List.generate(
    _actions.length,
    (index) => FocusNode(debugLabel: 'portfolio-fab-item-$index'),
  );

  @override
  void didUpdateWidget(covariant _PortfolioFabMenu oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.expanded == oldWidget.expanded) return;
    if (MediaQuery.disableAnimationsOf(context)) {
      _controller.value = widget.expanded ? 1 : 0;
      if (!widget.expanded) _restoreToggleFocus();
      return;
    }
    if (widget.expanded) {
      _controller.forward();
    } else {
      _controller.reverse().whenComplete(_restoreToggleFocus);
    }
  }

  void _restoreToggleFocus() {
    if (mounted) _toggleFocusNode.requestFocus();
  }

  @override
  void dispose() {
    _controller.dispose();
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
                    animation: _controller,
                    index: index,
                    itemCount: _actions.length,
                    action: _actions[index],
                    focusNode: _itemFocusNodes[index],
                    isLast: index == _actions.length - 1,
                    onClose: widget.onToggle,
                    onPressed: () =>
                        widget.onSelected(_actions[index].destination),
                  ),
                ),
              ),
            AnimatedBuilder(
              animation: _controller,
              builder: (context, _) => SizedBox(
                height: 8 * Curves.easeOut.transform(_controller.value),
              ),
            ),
            FocusTraversalOrder(
              order: const NumericFocusOrder(0),
              child: Focus(
                onKeyEvent: _handleToggleKey,
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, _) {
                    final progress = Curves.easeOutCubic.transform(
                      _controller.value,
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
                        ? 'Fechar menu de navegação'
                        : 'Abrir menu de navegação';
                    return Tooltip(
                      message: label,
                      excludeFromSemantics: true,
                      child: Semantics(
                        button: true,
                        toggled: widget.expanded,
                        label: label,
                        value: widget.expanded ? 'Expandido' : 'Recolhido',
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

class _PortfolioFabMenuAction {
  const _PortfolioFabMenuAction({
    required this.destination,
    required this.label,
    required this.icon,
    required this.key,
  });

  final _PortfolioDestination destination;
  final String label;
  final IconData icon;
  final Key key;
}

class _StaggeredFabMenuItem extends StatelessWidget {
  const _StaggeredFabMenuItem({
    required this.animation,
    required this.index,
    required this.itemCount,
    required this.action,
    required this.focusNode,
    required this.isLast,
    required this.onClose,
    required this.onPressed,
  });

  final Animation<double> animation;
  final int index;
  final int itemCount;
  final _PortfolioFabMenuAction action;
  final FocusNode focusNode;
  final bool isLast;
  final VoidCallback onClose;
  final VoidCallback onPressed;

  double _progress() {
    final revealOrder = itemCount - 1 - index;
    final start = revealOrder * .09;
    final end = (start + .7).clamp(0.0, 1.0);
    final value = ((animation.value - start) / (end - start)).clamp(0.0, 1.0);
    return Curves.easeOutCubic.transform(value);
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
                child: ClipRect(
                  child: Align(
                    alignment: Alignment.centerRight,
                    widthFactor: progress,
                    heightFactor: progress,
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
        label: action.label,
        customSemanticsActions: isLast
            ? {CustomSemanticsAction(label: 'Fechar menu'): onClose}
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
                    Text(action.label, style: labelStyle),
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
  const _TopBar();

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
            compact ? 'DISPONÍVEL' : 'DISPONÍVEL PARA NOVOS DESAFIOS',
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

class _Hero extends StatefulWidget {
  const _Hero();

  @override
  State<_Hero> createState() => _HeroState();
}

class _HeroState extends State<_Hero> {
  int focus = 0;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 700;
        final nameSize = compact ? 68.0 : 108.0;
        final roleSize = compact ? 30.0 : 48.0;
        final accent = focus == 0 ? _green : _blue;
        final role = focus == 0
            ? 'Mobile Software Engineer'
            : 'AI Automation Engineer';
        final supportingLine = focus == 0
            ? 'Mobile products powered by smart, connected systems.'
            : 'Python, agents and automation built around real work.';
        return Container(
          height: compact ? 900 : 880,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: _bg,
            borderRadius: BorderRadius.circular(compact ? 28 : 40),
            border: Border.all(color: Colors.white.withValues(alpha: .055)),
          ),
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Positioned.fill(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 600),
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: const Alignment(0, .28),
                      radius: compact ? .78 : .66,
                      colors: [
                        accent.withValues(alpha: .16),
                        _coral.withValues(alpha: .035),
                        Colors.transparent,
                      ],
                      stops: const [0, .43, 1],
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                child: IgnorePointer(
                  child: CustomPaint(
                    painter: _HeroStagePainter(accent: accent),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(
                  compact ? 18 : 42,
                  compact ? 32 : 44,
                  compact ? 18 : 42,
                  compact ? 18 : 28,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _HeroFocusSelector(
                      compact: compact,
                      selected: focus,
                      onSelected: (value) => setState(() => focus = value),
                    ),
                    SizedBox(height: compact ? 42 : 54),
                    Text(
                      '7+ YEARS BUILDING SOFTWARE',
                      style: TextStyle(
                        color: accent,
                        fontSize: compact ? 10 : 12,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.6,
                      ),
                    ),
                    SizedBox(height: compact ? 14 : 18),
                    Text(
                      'Leone',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: nameSize,
                        height: .88,
                        letterSpacing: compact ? -4.4 : -7.5,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: compact ? 22 : 28),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 320),
                      child: Text(
                        role,
                        key: ValueKey(role),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: roleSize,
                          height: 1.03,
                          letterSpacing: compact ? -1.2 : -2.1,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    SizedBox(height: compact ? 16 : 20),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 320),
                      child: Text(
                        supportingLine,
                        key: ValueKey(supportingLine),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: _muted,
                          fontSize: compact ? 14 : 17,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    SizedBox(height: compact ? 24 : 30),
                    const Expanded(child: _BrandedViewportFrame()),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _BrandedViewportFrame extends StatelessWidget {
  const _BrandedViewportFrame();

  @override
  Widget build(BuildContext context) {
    return SelectionContainer.disabled(
      child: RepaintBoundary(
        child: const LdViewportStage(child: _IdentityFrameContent()),
      ),
    );
  }
}

class _IdentityFrameContent extends StatelessWidget {
  const _IdentityFrameContent();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final horizontal = constraints.maxHeight < 170;
        final title = Text(
          'Flutter',
          maxLines: 1,
          style: TextStyle(
            fontSize: horizontal ? 18 : 24,
            fontWeight: FontWeight.w800,
            letterSpacing: -.7,
          ),
        );
        final detail = Text(
          'mobile  ·  desktop  ·  web',
          maxLines: 1,
          overflow: TextOverflow.fade,
          style: const TextStyle(
            color: _muted,
            fontSize: 9,
            fontWeight: FontWeight.w700,
            letterSpacing: .35,
          ),
        );
        return DecoratedBox(
          decoration: const BoxDecoration(
            gradient: RadialGradient(
              center: Alignment(.2, -.2),
              radius: 1.15,
              colors: [Color(0xFF171329), Color(0xFF0B0A12)],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: horizontal
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      title,
                      const SizedBox(width: 14),
                      Flexible(child: detail),
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'ONE FRAME · EVERY SURFACE',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: _green,
                          fontSize: 7,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 8),
                      title,
                      const SizedBox(height: 6),
                      detail,
                    ],
                  ),
          ),
        );
      },
    );
  }
}

class _SystemOverviewSection extends StatelessWidget {
  const _SystemOverviewSection();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 700;
        return Container(
          padding: EdgeInsets.fromLTRB(
            compact ? 16 : 24,
            compact ? 20 : 24,
            compact ? 16 : 24,
            compact ? 18 : 22,
          ),
          decoration: BoxDecoration(
            color: _panel.withValues(alpha: .78),
            borderRadius: BorderRadius.circular(compact ? 24 : 30),
            border: Border.all(color: Colors.white.withValues(alpha: .075)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'UM PRODUTO. O SISTEMA INTEIRO.',
                          style: TextStyle(
                            color: _green,
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.3,
                          ),
                        ),
                        SizedBox(height: 7),
                        Text(
                          'Mobile, serviços e inteligência conectados.',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (!compact)
                    const Text(
                      'PRODUCT → SYSTEM → RESULT',
                      style: TextStyle(
                        color: _muted,
                        fontSize: 8,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1,
                      ),
                    ),
                ],
              ),
              SizedBox(height: compact ? 20 : 26),
              _SystemDiagram(focus: 0, compact: compact),
            ],
          ),
        );
      },
    );
  }
}

class _HeroFocusSelector extends StatelessWidget {
  const _HeroFocusSelector({
    required this.compact,
    required this.selected,
    required this.onSelected,
  });

  final bool compact;
  final int selected;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(4),
    decoration: BoxDecoration(
      color: Colors.white.withValues(alpha: .045),
      borderRadius: BorderRadius.circular(99),
      border: Border.all(color: Colors.white.withValues(alpha: .1)),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _HeroFocusButton(
          label: 'Mobile',
          compact: compact,
          selected: selected == 0,
          accent: _green,
          onTap: () => onSelected(0),
        ),
        _HeroFocusButton(
          label: 'AI + Automation',
          compact: compact,
          selected: selected == 1,
          accent: _blue,
          onTap: () => onSelected(1),
        ),
      ],
    ),
  );
}

class _HeroFocusButton extends StatelessWidget {
  const _HeroFocusButton({
    required this.label,
    required this.compact,
    required this.selected,
    required this.accent,
    required this.onTap,
  });

  final String label;
  final bool compact;
  final bool selected;
  final Color accent;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(99),
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 240),
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 12 : 18,
        vertical: compact ? 9 : 10,
      ),
      decoration: BoxDecoration(
        color: selected ? _ink : Colors.transparent,
        borderRadius: BorderRadius.circular(99),
        boxShadow: selected
            ? [BoxShadow(color: accent.withValues(alpha: .22), blurRadius: 18)]
            : null,
      ),
      child: Text(
        label,
        style: TextStyle(
          color: selected ? _bg : _muted,
          fontSize: compact ? 10 : 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    ),
  );
}

class _SystemDiagram extends StatelessWidget {
  const _SystemDiagram({required this.focus, required this.compact});

  final int focus;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final mobile = _SystemNode(
      eyebrow: '01  /  PRODUCT',
      title: 'Mobile',
      detail: 'Flutter · Android · iOS',
      icon: Icons.phone_iphone_rounded,
      accent: _green,
      highlighted: focus == 0,
      compact: compact,
    );
    final backend = _SystemNode(
      eyebrow: '02  /  SERVICES',
      title: 'Python Backend',
      detail: 'APIs · data · integrations',
      icon: Icons.dns_rounded,
      accent: _amber,
      compact: compact,
    );
    final ai = _SystemNode(
      eyebrow: '03  /  INTELLIGENCE',
      title: 'AI Systems',
      detail: 'Agents · LLMs · automation',
      icon: Icons.auto_awesome_rounded,
      accent: _blue,
      highlighted: focus == 1,
      compact: compact,
    );

    return SizedBox(
      width: compact ? 310 : 940,
      height: compact ? 270 : 210,
      child: compact
          ? Column(
              children: [
                mobile,
                const _SystemConnector(label: 'REQUESTS', vertical: true),
                backend,
                const _SystemConnector(
                  label: 'CONTEXT + TOOLS',
                  vertical: true,
                ),
                ai,
                const SizedBox(height: 8),
                const _SystemReturnLabel(compact: true),
              ],
            )
          : Stack(
              children: [
                Positioned.fill(
                  child: CustomPaint(painter: const _SystemFlowPainter()),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: mobile),
                      const SizedBox(
                        width: 116,
                        child: _SystemConnector(label: 'REST / GRAPHQL'),
                      ),
                      Expanded(child: backend),
                      const SizedBox(
                        width: 116,
                        child: _SystemConnector(label: 'CONTEXT + TOOLS'),
                      ),
                      Expanded(child: ai),
                    ],
                  ),
                ),
                const Align(
                  alignment: Alignment.bottomCenter,
                  child: _SystemReturnLabel(compact: false),
                ),
              ],
            ),
    );
  }
}

class _SystemNode extends StatelessWidget {
  const _SystemNode({
    required this.eyebrow,
    required this.title,
    required this.detail,
    required this.icon,
    required this.accent,
    required this.compact,
    this.highlighted = false,
  });

  final String eyebrow;
  final String title;
  final String detail;
  final IconData icon;
  final Color accent;
  final bool compact;
  final bool highlighted;

  @override
  Widget build(BuildContext context) => AnimatedContainer(
    duration: const Duration(milliseconds: 360),
    height: compact ? 58 : 126,
    padding: EdgeInsets.symmetric(
      horizontal: compact ? 12 : 16,
      vertical: compact ? 8 : 14,
    ),
    decoration: BoxDecoration(
      color: highlighted
          ? accent.withValues(alpha: .12)
          : _panel.withValues(alpha: .84),
      borderRadius: BorderRadius.circular(compact ? 14 : 20),
      border: Border.all(
        color: accent.withValues(alpha: highlighted ? .62 : .2),
      ),
      boxShadow: highlighted
          ? [BoxShadow(color: accent.withValues(alpha: .16), blurRadius: 28)]
          : null,
    ),
    child: Row(
      children: [
        Container(
          width: compact ? 34 : 44,
          height: compact ? 34 : 44,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: accent.withValues(alpha: .12),
            borderRadius: BorderRadius.circular(compact ? 10 : 13),
          ),
          child: Icon(icon, color: accent, size: compact ? 18 : 23),
        ),
        SizedBox(width: compact ? 10 : 13),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!compact)
                Text(
                  eyebrow,
                  maxLines: 1,
                  style: TextStyle(
                    color: accent,
                    fontSize: 8,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1,
                  ),
                ),
              if (!compact) const SizedBox(height: 8),
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: compact ? 13 : 17,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: compact ? 2 : 5),
              Text(
                detail,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: _muted, fontSize: compact ? 8 : 10),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _SystemConnector extends StatelessWidget {
  const _SystemConnector({required this.label, this.vertical = false});

  final String label;
  final bool vertical;

  @override
  Widget build(BuildContext context) => SizedBox(
    height: vertical ? 22 : 126,
    child: vertical
        ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.arrow_downward_rounded, size: 12, color: _muted),
              const SizedBox(width: 5),
              Text(
                label,
                style: const TextStyle(
                  color: _muted,
                  fontSize: 7,
                  fontWeight: FontWeight.w800,
                  letterSpacing: .8,
                ),
              ),
            ],
          )
        : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: _muted,
                  fontSize: 8,
                  fontWeight: FontWeight.w800,
                  letterSpacing: .7,
                ),
              ),
              const SizedBox(height: 8),
              const Row(
                children: [
                  Expanded(child: Divider(color: Colors.white12, height: 1)),
                  Icon(Icons.arrow_forward_rounded, size: 14, color: _muted),
                ],
              ),
            ],
          ),
  );
}

class _SystemReturnLabel extends StatelessWidget {
  const _SystemReturnLabel({required this.compact});

  final bool compact;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(
        Icons.subdirectory_arrow_left_rounded,
        size: compact ? 12 : 15,
        color: _green,
      ),
      const SizedBox(width: 6),
      Text(
        compact
            ? 'RESULTS RETURN TO MOBILE'
            : 'DECISIONS + ACTIONS RETURN TO THE PRODUCT',
        style: TextStyle(
          color: _muted,
          fontSize: compact ? 7 : 9,
          fontWeight: FontWeight.w800,
          letterSpacing: compact ? .55 : .9,
        ),
      ),
    ],
  );
}

class _SystemFlowPainter extends CustomPainter {
  const _SystemFlowPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = _green.withValues(alpha: .2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    final path = Path()
      ..moveTo(size.width * .88, 136)
      ..cubicTo(
        size.width * .88,
        176,
        size.width * .12,
        176,
        size.width * .12,
        136,
      );
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _HeroStagePainter extends CustomPainter {
  const _HeroStagePainter({required this.accent});

  final Color accent;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height * .78);
    for (var index = 0; index < 4; index++) {
      final radius = size.width * (.18 + index * .12);
      canvas.drawCircle(
        center,
        radius,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1
          ..color = accent.withValues(alpha: .085 - index * .014),
      );
    }
  }

  @override
  bool shouldRepaint(_HeroStagePainter oldDelegate) =>
      oldDelegate.accent != accent;
}

enum _DeviceMode { mosaic, morph }

class _RadarDemoController extends ChangeNotifier {
  int section = 0;
  String query = '';
  String? selectedOfferId;
  final Set<String> savedOfferIds = {'ps5'};

  void selectSection(int value) {
    section = value;
    selectedOfferId = null;
    notifyListeners();
  }

  void updateQuery(String value) {
    query = value.trim().toLowerCase();
    selectedOfferId = null;
    notifyListeners();
  }

  void openOffer(String id) {
    selectedOfferId = id;
    notifyListeners();
  }

  void closeOffer() {
    selectedOfferId = null;
    notifyListeners();
  }

  void toggleSaved(String id) {
    savedOfferIds.contains(id)
        ? savedOfferIds.remove(id)
        : savedOfferIds.add(id);
    notifyListeners();
  }
}

class _DeviceLab extends StatefulWidget {
  const _DeviceLab();

  @override
  State<_DeviceLab> createState() => _DeviceLabState();
}

class _DeviceLabState extends State<_DeviceLab> {
  _DeviceMode mode = _DeviceMode.mosaic;
  late final _RadarDemoController demoController;

  @override
  void initState() {
    super.initState();
    demoController = _RadarDemoController();
  }

  @override
  void dispose() {
    demoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _panel,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white.withValues(alpha: .09)),
        boxShadow: [
          BoxShadow(
            color: _green.withValues(alpha: .07),
            blurRadius: 80,
            spreadRadius: 8,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'DEVICE LAB',
                      style: TextStyle(
                        fontSize: 11,
                        color: _muted,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.4,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Uma ação. Todas as telas.',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
              _ModeButton(
                label: 'Mosaico',
                selected: mode == _DeviceMode.mosaic,
                onTap: () => setState(() => mode = _DeviceMode.mosaic),
              ),
              const SizedBox(width: 6),
              _ModeButton(
                label: 'Metamorfo',
                selected: mode == _DeviceMode.morph,
                onTap: () => setState(() => mode = _DeviceMode.morph),
              ),
            ],
          ),
          const SizedBox(height: 18),
          AspectRatio(
            aspectRatio: 1.08,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              switchInCurve: Curves.easeOutCubic,
              switchOutCurve: Curves.easeInCubic,
              child: mode == _DeviceMode.mosaic
                  ? _DeviceMosaic(
                      key: const ValueKey('mosaic'),
                      controller: demoController,
                    )
                  : _MorphingDevice(
                      key: const ValueKey('morph'),
                      controller: demoController,
                    ),
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            'Explore ofertas, compare preços e salve itens — tudo sincronizado.',
            style: TextStyle(color: _muted, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _ModeButton extends StatelessWidget {
  const _ModeButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      label: 'Visualização $label',
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 9),
          decoration: BoxDecoration(
            color: selected ? _green : _panelSoft,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: selected ? _bg : _muted,
              fontSize: 11,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
    );
  }
}

class _DeviceMosaic extends StatelessWidget {
  const _DeviceMosaic({super.key, required this.controller});

  final _RadarDemoController controller;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Positioned(
          top: 22,
          left: 8,
          right: 64,
          bottom: 54,
          child: _DeviceFrame(
            label: 'TABLET',
            radius: 22,
            controller: controller,
          ),
        ),
        Positioned(
          top: 4,
          right: 3,
          width: 138,
          bottom: 6,
          child: _DeviceFrame(
            label: 'MOBILE',
            radius: 28,
            controller: controller,
          ),
        ),
      ],
    );
  }
}

class _MorphingDevice extends StatefulWidget {
  const _MorphingDevice({super.key, required this.controller});

  final _RadarDemoController controller;

  @override
  State<_MorphingDevice> createState() => _MorphingDeviceState();
}

class _MorphingDeviceState extends State<_MorphingDevice> {
  bool tablet = false;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: InkWell(
        onTap: () {
          setState(() => tablet = !tablet);
        },
        borderRadius: BorderRadius.circular(30),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 750),
          curve: Curves.easeInOutCubic,
          width: tablet ? 390 : 190,
          height: tablet ? 285 : 390,
          padding: const EdgeInsets.all(9),
          decoration: BoxDecoration(
            color: const Color(0xFF1C2430),
            borderRadius: BorderRadius.circular(tablet ? 24 : 32),
            border: Border.all(color: Colors.white.withValues(alpha: .19)),
            boxShadow: const [
              BoxShadow(
                color: Colors.black54,
                blurRadius: 26,
                offset: Offset(0, 14),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(tablet ? 16 : 24),
            child: _DemoScreen(controller: widget.controller),
          ),
        ),
      ),
    );
  }
}

class _DeviceFrame extends StatelessWidget {
  const _DeviceFrame({
    required this.label,
    required this.radius,
    required this.controller,
  });

  final String label;
  final double radius;
  final _RadarDemoController controller;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '$label com Radar de Ofertas interativo',
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFF1C2430),
          borderRadius: BorderRadius.circular(radius),
          border: Border.all(color: Colors.white.withValues(alpha: .2)),
          boxShadow: const [
            BoxShadow(
              color: Colors.black54,
              blurRadius: 24,
              offset: Offset(0, 12),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(radius - 8),
          child: _DemoScreen(controller: controller),
        ),
      ),
    );
  }
}

class _DemoScreen extends StatelessWidget {
  const _DemoScreen({required this.controller});

  final _RadarDemoController controller;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) => LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxHeight < 300) {
            return _RadarWidePreview(controller: controller);
          }
          final compact =
              constraints.maxWidth < 130 || constraints.maxHeight < 250;
          final wide = constraints.maxWidth >= 260;
          final inset = compact ? 7.0 : 12.0;

          return Container(
            color: _radarInk,
            padding: EdgeInsets.all(inset),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _RadarDemoHeader(compact: compact),
                SizedBox(height: compact ? 6 : 10),
                _RadarDemoSearch(
                  compact: compact,
                  query: controller.query,
                  onChanged: controller.updateQuery,
                ),
                SizedBox(height: compact ? 6 : 9),
                _RadarDemoTabs(
                  compact: compact,
                  selected: controller.section,
                  onSelected: controller.selectSection,
                ),
                SizedBox(height: compact ? 7 : 10),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 260),
                    child: controller.selectedOfferId == null
                        ? _RadarOfferGrid(
                            key: ValueKey(
                              '${controller.section}-${controller.query}-${controller.savedOfferIds.length}',
                            ),
                            controller: controller,
                            compact: compact,
                            wide: wide,
                          )
                        : _RadarOfferDetail(
                            key: ValueKey(controller.selectedOfferId),
                            offer: _radarDemoOffers.firstWhere(
                              (offer) => offer.id == controller.selectedOfferId,
                            ),
                            compact: compact,
                            isSaved: controller.savedOfferIds.contains(
                              controller.selectedOfferId,
                            ),
                            onBack: controller.closeOffer,
                            onToggleSaved: () => controller.toggleSaved(
                              controller.selectedOfferId!,
                            ),
                          ),
                  ),
                ),
                SizedBox(height: compact ? 5 : 8),
                _RadarBottomNav(
                  compact: compact,
                  selected: controller.section,
                  onSelected: controller.selectSection,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _RadarWidePreview extends StatelessWidget {
  const _RadarWidePreview({required this.controller});

  final _RadarDemoController controller;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final veryCompact = constraints.maxWidth < 300;
        final offers = _radarDemoOffers.take(veryCompact ? 2 : 3);
        return Container(
          color: _radarInk,
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              SizedBox(
                width: veryCompact ? 48 : 76,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.radar_rounded,
                      color: _radarMint,
                      size: 17,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      veryCompact ? 'RADAR' : 'RADAR DE OFERTAS',
                      maxLines: 2,
                      style: const TextStyle(
                        fontSize: 7,
                        height: 1.15,
                        fontWeight: FontWeight.w900,
                        letterSpacing: .5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'LIVE DEALS',
                      style: TextStyle(
                        color: _radarMuted,
                        fontSize: 5,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 7),
              for (final offer in offers) ...[
                Expanded(
                  child: Material(
                    color: _radarRaised,
                    borderRadius: BorderRadius.circular(8),
                    clipBehavior: Clip.antiAlias,
                    child: InkWell(
                      onTap: () => controller.openOffer(offer.id),
                      child: Padding(
                        padding: const EdgeInsets.all(6),
                        child: Row(
                          children: [
                            Icon(offer.icon, color: offer.color, size: 17),
                            const SizedBox(width: 5),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    offer.title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 6,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    offer.price,
                                    maxLines: 1,
                                    style: const TextStyle(
                                      color: _radarMint,
                                      fontSize: 8,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                if (offer != offers.last) const SizedBox(width: 6),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _RadarDemoHeader extends StatelessWidget {
  const _RadarDemoHeader({required this.compact});

  final bool compact;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Container(
        width: compact ? 19 : 25,
        height: compact ? 19 : 25,
        decoration: BoxDecoration(
          color: _radarMint.withValues(alpha: .12),
          borderRadius: BorderRadius.circular(compact ? 6 : 8),
          border: Border.all(color: _radarMint.withValues(alpha: .55)),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(
              Icons.radar_rounded,
              size: compact ? 14 : 18,
              color: _radarMint,
            ),
            Container(
              width: compact ? 3 : 4,
              height: compact ? 3 : 4,
              decoration: const BoxDecoration(
                color: _radarCoral,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      ),
      SizedBox(width: compact ? 5 : 8),
      Expanded(
        child: Text(
          compact ? 'RADAR' : 'RADAR DE OFERTAS',
          maxLines: 1,
          overflow: TextOverflow.fade,
          style: TextStyle(
            fontSize: compact ? 8 : 10,
            fontWeight: FontWeight.w900,
            letterSpacing: compact ? .5 : .8,
          ),
        ),
      ),
      Icon(
        Icons.notifications_none_rounded,
        size: compact ? 13 : 17,
        color: _radarMuted,
      ),
    ],
  );
}

class _RadarDemoSearch extends StatefulWidget {
  const _RadarDemoSearch({
    required this.compact,
    required this.query,
    required this.onChanged,
  });

  final bool compact;
  final String query;
  final ValueChanged<String> onChanged;

  @override
  State<_RadarDemoSearch> createState() => _RadarDemoSearchState();
}

class _RadarDemoSearchState extends State<_RadarDemoSearch> {
  late final TextEditingController textController;

  @override
  void initState() {
    super.initState();
    textController = TextEditingController(text: widget.query);
  }

  @override
  void didUpdateWidget(covariant _RadarDemoSearch oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.query != textController.text.toLowerCase()) {
      textController.value = TextEditingValue(
        text: widget.query,
        selection: TextSelection.collapsed(offset: widget.query.length),
      );
    }
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Container(
    height: widget.compact ? 25 : 32,
    padding: EdgeInsets.only(
      left: widget.compact ? 7 : 10,
      right: widget.compact ? 4 : 7,
    ),
    decoration: BoxDecoration(
      color: _radarSurface,
      borderRadius: BorderRadius.circular(widget.compact ? 7 : 10),
      border: Border.all(color: Colors.white.withValues(alpha: .08)),
    ),
    child: Row(
      children: [
        Icon(
          Icons.search_rounded,
          size: widget.compact ? 11 : 14,
          color: _radarMuted,
        ),
        SizedBox(width: widget.compact ? 4 : 6),
        Expanded(
          child: TextField(
            controller: textController,
            onChanged: widget.onChanged,
            cursorColor: _radarMint,
            cursorHeight: widget.compact ? 9 : 12,
            style: TextStyle(
              color: _ink,
              fontSize: widget.compact ? 7 : 9,
              height: 1,
            ),
            decoration: InputDecoration.collapsed(
              hintText: 'Buscar produto',
              hintStyle: TextStyle(
                color: _radarMuted,
                fontSize: widget.compact ? 6.5 : 8.5,
              ),
            ),
          ),
        ),
        if (textController.text.isNotEmpty)
          InkWell(
            onTap: () {
              textController.clear();
              widget.onChanged('');
            },
            child: Padding(
              padding: const EdgeInsets.all(2),
              child: Icon(
                Icons.close_rounded,
                size: widget.compact ? 10 : 13,
                color: _radarMint,
              ),
            ),
          )
        else
          Icon(
            Icons.tune_rounded,
            size: widget.compact ? 10 : 13,
            color: _radarMint,
          ),
      ],
    ),
  );
}

class _RadarDemoTabs extends StatelessWidget {
  const _RadarDemoTabs({
    required this.compact,
    required this.selected,
    required this.onSelected,
  });

  final bool compact;
  final int selected;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    const labels = ['Ofertas', 'Comparar', 'Salvos'];
    return Row(
      children: [
        for (var index = 0; index < labels.length; index++) ...[
          if (index > 0) SizedBox(width: compact ? 3 : 6),
          Expanded(
            child: InkWell(
              onTap: () => onSelected(index),
              borderRadius: BorderRadius.circular(99),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                height: compact ? 20 : 26,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: selected == index ? _radarMint : _radarRaised,
                  borderRadius: BorderRadius.circular(99),
                ),
                child: Text(
                  labels[index],
                  maxLines: 1,
                  style: TextStyle(
                    color: selected == index ? _radarInk : _radarMuted,
                    fontSize: compact ? 5.5 : 8,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _RadarDemoOffer {
  const _RadarDemoOffer({
    required this.id,
    required this.title,
    required this.store,
    required this.price,
    required this.oldPrice,
    required this.discount,
    required this.icon,
    required this.color,
    this.storeCount = 1,
  });

  final String id;
  final String title;
  final String store;
  final String price;
  final String oldPrice;
  final String discount;
  final IconData icon;
  final Color color;
  final int storeCount;
}

const _radarDemoOffers = [
  _RadarDemoOffer(
    id: 'buds-fe',
    title: 'Galaxy Buds FE Bluetooth Branco',
    store: 'Mercado Livre',
    price: 'R\$ 289',
    oldPrice: 'R\$ 399',
    discount: '-28%',
    icon: Icons.headphones_rounded,
    color: Color(0xFF55B8FF),
  ),
  _RadarDemoOffer(
    id: 'g-pro-x',
    title: 'Mouse Logitech G Pro X Superlight 2',
    store: '3 lojas',
    price: 'R\$ 649',
    oldPrice: 'R\$ 799',
    discount: '-19%',
    icon: Icons.mouse_rounded,
    color: Color(0xFF8A5CFF),
    storeCount: 3,
  ),
  _RadarDemoOffer(
    id: 'ps5',
    title: 'PlayStation 5 Slim Digital Edition',
    store: 'Amazon',
    price: 'R\$ 3.199',
    oldPrice: 'R\$ 3.699',
    discount: '-14%',
    icon: Icons.sports_esports_rounded,
    color: Color(0xFFFF6B55),
  ),
];

class _RadarOfferGrid extends StatelessWidget {
  const _RadarOfferGrid({
    super.key,
    required this.controller,
    required this.compact,
    required this.wide,
  });

  final _RadarDemoController controller;
  final bool compact;
  final bool wide;

  @override
  Widget build(BuildContext context) {
    var offers = _radarDemoOffers
        .where((offer) {
          final matchesQuery =
              controller.query.isEmpty ||
              offer.title.toLowerCase().contains(controller.query) ||
              offer.store.toLowerCase().contains(controller.query);
          if (!matchesQuery) return false;
          if (controller.section == 1) return offer.storeCount > 1;
          if (controller.section == 2) {
            return controller.savedOfferIds.contains(offer.id);
          }
          return true;
        })
        .toList(growable: false);

    if (offers.isEmpty) {
      return _RadarEmptyState(compact: compact, saved: controller.section == 2);
    }

    final primary = offers.first;
    if (!wide) {
      return _RadarOfferCard(
        offer: primary,
        compact: compact,
        isSaved: controller.savedOfferIds.contains(primary.id),
        onTap: () => controller.openOffer(primary.id),
        onToggleSaved: () => controller.toggleSaved(primary.id),
      );
    }

    final secondary = offers.length > 1 ? offers[1] : null;
    return Row(
      children: [
        Expanded(
          flex: 6,
          child: _RadarOfferCard(
            offer: primary,
            isSaved: controller.savedOfferIds.contains(primary.id),
            onTap: () => controller.openOffer(primary.id),
            onToggleSaved: () => controller.toggleSaved(primary.id),
          ),
        ),
        if (secondary != null) ...[
          const SizedBox(width: 8),
          Expanded(
            flex: 5,
            child: _RadarOfferCard(
              offer: secondary,
              isSaved: controller.savedOfferIds.contains(secondary.id),
              onTap: () => controller.openOffer(secondary.id),
              onToggleSaved: () => controller.toggleSaved(secondary.id),
            ),
          ),
        ],
      ],
    );
  }
}

class _RadarOfferCard extends StatelessWidget {
  const _RadarOfferCard({
    required this.offer,
    required this.isSaved,
    required this.onTap,
    required this.onToggleSaved,
    this.compact = false,
  });

  final _RadarDemoOffer offer;
  final bool isSaved;
  final VoidCallback onTap;
  final VoidCallback onToggleSaved;
  final bool compact;

  @override
  Widget build(BuildContext context) => Material(
    color: _radarRaised,
    borderRadius: BorderRadius.circular(compact ? 9 : 13),
    clipBehavior: Clip.antiAlias,
    child: InkWell(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      colors: [
                        offer.color.withValues(alpha: .34),
                        _radarSurface,
                      ],
                    ),
                  ),
                ),
                Icon(offer.icon, size: compact ? 34 : 44, color: offer.color),
                Positioned(
                  top: compact ? 5 : 7,
                  left: compact ? 5 : 7,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: compact ? 5 : 7,
                      vertical: compact ? 2 : 3,
                    ),
                    decoration: BoxDecoration(
                      color: _radarInk.withValues(alpha: .86),
                      borderRadius: BorderRadius.circular(99),
                    ),
                    child: Text(
                      offer.store,
                      style: TextStyle(
                        fontSize: compact ? 5.5 : 7,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: compact ? 4 : 6,
                  right: compact ? 4 : 6,
                  child: Semantics(
                    button: true,
                    label: isSaved ? 'Remover dos salvos' : 'Salvar oferta',
                    child: InkWell(
                      key: ValueKey('save-${offer.id}'),
                      onTap: onToggleSaved,
                      borderRadius: BorderRadius.circular(99),
                      child: Padding(
                        padding: const EdgeInsets.all(2),
                        child: Icon(
                          isSaved
                              ? Icons.favorite_rounded
                              : Icons.favorite_border_rounded,
                          size: compact ? 12 : 16,
                          color: isSaved ? _radarCoral : _radarMuted,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
              compact ? 7 : 9,
              compact ? 6 : 8,
              compact ? 7 : 9,
              compact ? 7 : 9,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  offer.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: compact ? 7 : 9,
                    height: 1.15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: compact ? 4 : 6),
                Text(
                  offer.oldPrice,
                  style: TextStyle(
                    color: _radarMuted,
                    fontSize: compact ? 5.5 : 7,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        offer.price,
                        maxLines: 1,
                        style: TextStyle(
                          color: _radarMint,
                          fontSize: compact ? 12 : 16,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    Text(
                      offer.discount,
                      style: TextStyle(
                        color: _radarCoral,
                        fontSize: compact ? 6 : 8,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
                if (offer.storeCount > 1) ...[
                  SizedBox(height: compact ? 3 : 5),
                  Row(
                    children: [
                      for (final color in const [
                        Color(0xFFFFC72C),
                        Color(0xFF55B8FF),
                        Color(0xFFFF6B55),
                      ])
                        Container(
                          width: compact ? 7 : 9,
                          height: compact ? 7 : 9,
                          margin: const EdgeInsets.only(right: 2),
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                            border: Border.all(color: _radarRaised),
                          ),
                        ),
                      const Spacer(),
                      Text(
                        'comparar',
                        style: TextStyle(
                          color: _radarMint,
                          fontSize: compact ? 5.5 : 7,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

class _RadarEmptyState extends StatelessWidget {
  const _RadarEmptyState({required this.compact, required this.saved});

  final bool compact;
  final bool saved;

  @override
  Widget build(BuildContext context) => Container(
    alignment: Alignment.center,
    decoration: BoxDecoration(
      color: _radarSurface,
      borderRadius: BorderRadius.circular(compact ? 9 : 13),
      border: Border.all(color: Colors.white.withValues(alpha: .07)),
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          saved ? Icons.favorite_border_rounded : Icons.search_off_rounded,
          size: compact ? 22 : 32,
          color: _radarMuted,
        ),
        SizedBox(height: compact ? 5 : 8),
        Text(
          saved ? 'Nada salvo' : 'Nenhuma oferta',
          style: TextStyle(
            color: _radarMuted,
            fontSize: compact ? 7 : 10,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    ),
  );
}

class _RadarOfferDetail extends StatelessWidget {
  const _RadarOfferDetail({
    super.key,
    required this.offer,
    required this.compact,
    required this.isSaved,
    required this.onBack,
    required this.onToggleSaved,
  });

  final _RadarDemoOffer offer;
  final bool compact;
  final bool isSaved;
  final VoidCallback onBack;
  final VoidCallback onToggleSaved;

  @override
  Widget build(BuildContext context) {
    final stores = offer.storeCount > 1
        ? const [
            ('Mercado Livre', 'R\$ 649'),
            ('Amazon', 'R\$ 679'),
            ('Kabum', 'R\$ 699'),
          ]
        : [(offer.store, offer.price)];

    return Container(
      padding: EdgeInsets.all(compact ? 7 : 10),
      decoration: BoxDecoration(
        color: _radarRaised,
        borderRadius: BorderRadius.circular(compact ? 9 : 13),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              InkWell(
                key: const ValueKey('detail-back'),
                onTap: onBack,
                borderRadius: BorderRadius.circular(99),
                child: Padding(
                  padding: const EdgeInsets.all(2),
                  child: Icon(
                    Icons.arrow_back_rounded,
                    size: compact ? 12 : 16,
                    color: _radarMint,
                  ),
                ),
              ),
              SizedBox(width: compact ? 4 : 7),
              Expanded(
                child: Text(
                  'DETALHES DA OFERTA',
                  maxLines: 1,
                  style: TextStyle(
                    color: _radarMuted,
                    fontSize: compact ? 5.5 : 7,
                    fontWeight: FontWeight.w800,
                    letterSpacing: .5,
                  ),
                ),
              ),
              InkWell(
                key: ValueKey('detail-save-${offer.id}'),
                onTap: onToggleSaved,
                borderRadius: BorderRadius.circular(99),
                child: Padding(
                  padding: const EdgeInsets.all(2),
                  child: Icon(
                    isSaved
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_rounded,
                    size: compact ? 13 : 17,
                    color: isSaved ? _radarCoral : _radarMuted,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: compact ? 5 : 8),
          Expanded(
            flex: 5,
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [offer.color.withValues(alpha: .3), _radarSurface],
                ),
                borderRadius: BorderRadius.circular(compact ? 7 : 10),
              ),
              child: Icon(
                offer.icon,
                size: compact ? 30 : 40,
                color: offer.color,
              ),
            ),
          ),
          SizedBox(height: compact ? 5 : 8),
          Text(
            offer.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: compact ? 7 : 9,
              height: 1.15,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: compact ? 4 : 6),
          Row(
            children: [
              Expanded(
                child: Text(
                  offer.price,
                  style: TextStyle(
                    color: _radarMint,
                    fontSize: compact ? 12 : 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              Text(
                offer.discount,
                style: TextStyle(
                  color: _radarCoral,
                  fontSize: compact ? 6 : 8,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          if (!compact || offer.storeCount > 1) ...[
            SizedBox(height: compact ? 4 : 6),
            Text(
              offer.storeCount > 1 ? 'PREÇOS NESTA BASE' : 'LOJA',
              style: TextStyle(
                color: _radarMuted,
                fontSize: compact ? 5 : 6.5,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: compact ? 2 : 4),
            for (final store in stores.take(compact ? 2 : 3))
              Padding(
                padding: EdgeInsets.only(bottom: compact ? 1 : 2),
                child: Row(
                  children: [
                    Container(
                      width: compact ? 5 : 7,
                      height: compact ? 5 : 7,
                      decoration: const BoxDecoration(
                        color: _radarMint,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: compact ? 3 : 5),
                    Expanded(
                      child: Text(
                        store.$1,
                        maxLines: 1,
                        style: TextStyle(
                          color: _radarMuted,
                          fontSize: compact ? 5.5 : 7,
                        ),
                      ),
                    ),
                    Text(
                      store.$2,
                      style: TextStyle(
                        fontSize: compact ? 5.5 : 7,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ],
      ),
    );
  }
}

class _RadarBottomNav extends StatelessWidget {
  const _RadarBottomNav({
    required this.compact,
    required this.selected,
    required this.onSelected,
  });

  final bool compact;
  final int selected;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    const icons = [
      Icons.local_fire_department_rounded,
      Icons.compare_arrows_rounded,
      Icons.favorite_rounded,
    ];
    return Container(
      height: compact ? 23 : 30,
      decoration: BoxDecoration(
        color: _radarSurface,
        borderRadius: BorderRadius.circular(compact ? 7 : 10),
      ),
      child: Row(
        children: [
          for (var index = 0; index < icons.length; index++)
            Expanded(
              child: InkWell(
                key: ValueKey('bottom-nav-$index'),
                onTap: () => onSelected(index),
                borderRadius: BorderRadius.circular(compact ? 7 : 10),
                child: Center(
                  child: Icon(
                    icons[index],
                    size: compact ? 11 : 15,
                    color: selected == index ? _radarMint : _radarMuted,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ProjectProof extends StatelessWidget {
  const _ProjectProof();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionHeading(
          eyebrow: 'SOLUÇÕES EM DESTAQUE',
          title: 'Código com impacto visível.',
          copy:
              'Projetos próprios e experiência de produto transformados em demonstrações que você pode explorar.',
        ),
        const SizedBox(height: 34),
        LayoutBuilder(
          builder: (context, constraints) {
            final columns = constraints.maxWidth >= 980
                ? 3
                : constraints.maxWidth >= 620
                ? 2
                : 1;
            const gap = 14.0;
            final width =
                (constraints.maxWidth - gap * (columns - 1)) / columns;
            return Wrap(
              spacing: gap,
              runSpacing: gap,
              children: [
                _ProjectCard(
                  width: width,
                  label: '01  •  RADAR DE OFERTAS',
                  title: 'Mobile Systems',
                  copy:
                      'Produto em movimento: interfaces adaptativas, estado sincronizado e integrações nativas em uma experiência que flui.',
                  accent: _green,
                  visual: _ProjectVisualType.mobile,
                ),
                _ProjectCard(
                  width: width,
                  label: '02  •  CAREER COPILOT',
                  title: 'Agentic Workflows',
                  copy:
                      'Inteligência que decide e executa: agentes conectam contexto, ferramentas e validação sem perder o controle humano.',
                  accent: _blue,
                  visual: _ProjectVisualType.agents,
                ),
                _ProjectCard(
                  width: width,
                  label: '03  •  LOCAL LLM LAB',
                  title: 'Automation Lab',
                  copy:
                      'Processo mensurável: Python transforma tarefas repetitivas em pipelines observáveis, reproduzíveis e confiáveis.',
                  accent: _coral,
                  visual: _ProjectVisualType.automation,
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _SectionHeading extends StatelessWidget {
  const _SectionHeading({
    required this.eyebrow,
    required this.title,
    required this.copy,
  });

  final String eyebrow;
  final String title;
  final String copy;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 36,
      runSpacing: 16,
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.end,
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 650),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                eyebrow,
                style: const TextStyle(
                  color: _green,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 42,
                  height: 1.05,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -1.5,
                ),
              ),
            ],
          ),
        ),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Text(
            copy,
            style: const TextStyle(color: _muted, height: 1.55),
          ),
        ),
      ],
    );
  }
}

class _ProjectCard extends StatelessWidget {
  const _ProjectCard({
    required this.width,
    required this.label,
    required this.title,
    required this.copy,
    required this.accent,
    required this.visual,
  });

  final double width;
  final String label;
  final String title;
  final String copy;
  final Color accent;
  final _ProjectVisualType visual;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 430,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF12111E), Color(0xFF0A0A11)],
        ),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: accent.withValues(alpha: .24)),
        boxShadow: [
          BoxShadow(
            color: accent.withValues(alpha: .08),
            blurRadius: 34,
            spreadRadius: -10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: _NeonProjectVisual(type: visual, accent: accent),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 20, 12, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: accent,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 10),
                Text(copy, style: const TextStyle(color: _muted, height: 1.45)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

enum _ProjectVisualType { mobile, agents, automation }

class _NeonProjectVisual extends StatelessWidget {
  const _NeonProjectVisual({required this.type, required this.accent});

  final _ProjectVisualType type;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          center: Alignment(0, .18),
          radius: .92,
          colors: [Color(0xFF1C1741), Color(0xFF0A0912)],
          stops: [0, 1],
        ),
      ),
      child: CustomPaint(
        painter: _NeonVisualPainter(type: type, accent: accent),
        child: const SizedBox.expand(),
      ),
    );
  }
}

class _NeonVisualPainter extends CustomPainter {
  const _NeonVisualPainter({required this.type, required this.accent});

  final _ProjectVisualType type;
  final Color accent;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final glow = Paint()
      ..color = accent.withValues(alpha: .20)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 28);
    canvas.drawCircle(center, size.shortestSide * .23, glow);

    switch (type) {
      case _ProjectVisualType.mobile:
        _paintMobile(canvas, size, center);
      case _ProjectVisualType.agents:
        _paintAgents(canvas, size, center);
      case _ProjectVisualType.automation:
        _paintAutomation(canvas, size, center);
    }
  }

  Paint _stroke(Color color, double width) => Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = width
    ..strokeCap = StrokeCap.round
    ..strokeJoin = StrokeJoin.round
    ..color = color;

  void _paintMobile(Canvas canvas, Size size, Offset center) {
    final phone = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: center,
        width: size.shortestSide * .34,
        height: size.shortestSide * .58,
      ),
      const Radius.circular(18),
    );
    canvas.drawRRect(phone, _stroke(_green.withValues(alpha: .88), 3));
    canvas.drawRRect(
      phone.deflate(9),
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0x449A7BFF), Color(0x33FF6F91)],
        ).createShader(phone.outerRect),
    );

    final leftCard = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        center.dx - size.shortestSide * .43,
        center.dy - 14,
        size.shortestSide * .27,
        size.shortestSide * .18,
      ),
      const Radius.circular(10),
    );
    final rightCard = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        center.dx + size.shortestSide * .18,
        center.dy - size.shortestSide * .22,
        size.shortestSide * .25,
        size.shortestSide * .17,
      ),
      const Radius.circular(10),
    );
    canvas.drawRRect(leftCard, _stroke(_blue.withValues(alpha: .72), 2));
    canvas.drawRRect(rightCard, _stroke(_coral.withValues(alpha: .8), 2));
    canvas.drawCircle(
      Offset(center.dx, center.dy + size.shortestSide * .12),
      7,
      Paint()..color = _amber,
    );
  }

  void _paintAgents(Canvas canvas, Size size, Offset center) {
    final nodes = [
      Offset(center.dx, center.dy - size.shortestSide * .30),
      Offset(center.dx - size.shortestSide * .34, center.dy + 3),
      Offset(center.dx + size.shortestSide * .34, center.dy + 3),
      Offset(
        center.dx - size.shortestSide * .21,
        center.dy + size.shortestSide * .29,
      ),
      Offset(
        center.dx + size.shortestSide * .21,
        center.dy + size.shortestSide * .29,
      ),
    ];
    final line = _stroke(_blue.withValues(alpha: .46), 1.5);
    for (final node in nodes) {
      canvas.drawLine(node, center, line);
      canvas.drawCircle(node, 9, Paint()..color = _panelSoft);
      canvas.drawCircle(node, 7, _stroke(_blue.withValues(alpha: .9), 2));
    }
    canvas.drawCircle(
      center,
      32,
      Paint()..color = _green.withValues(alpha: .16),
    );
    canvas.drawCircle(center, 22, _stroke(_green, 3));
    canvas.drawCircle(center, 7, Paint()..color = _coral);
  }

  void _paintAutomation(Canvas canvas, Size size, Offset center) {
    final startX = size.width * .15;
    final endX = size.width * .85;
    final path = Path()
      ..moveTo(startX, center.dy)
      ..cubicTo(
        size.width * .34,
        center.dy - size.height * .24,
        size.width * .54,
        center.dy + size.height * .24,
        endX,
        center.dy,
      );
    canvas.drawPath(path, _stroke(_green.withValues(alpha: .68), 3));

    final checkpoints = [
      Offset(startX, center.dy),
      Offset(size.width * .36, center.dy - size.height * .08),
      Offset(size.width * .60, center.dy + size.height * .07),
      Offset(endX, center.dy),
    ];
    final colors = [_blue, _green, _coral, _amber];
    for (var i = 0; i < checkpoints.length; i++) {
      canvas.drawCircle(
        checkpoints[i],
        13,
        Paint()..color = colors[i].withValues(alpha: .15),
      );
      canvas.drawCircle(checkpoints[i], 6, Paint()..color = colors[i]);
    }
    final output = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(endX, center.dy), width: 52, height: 52),
      const Radius.circular(15),
    );
    canvas.drawRRect(output, _stroke(_amber.withValues(alpha: .9), 2));
  }

  @override
  bool shouldRepaint(covariant _NeonVisualPainter oldDelegate) =>
      oldDelegate.type != type || oldDelegate.accent != accent;
}

class _ExperienceSection extends StatelessWidget {
  const _ExperienceSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1240),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: _SectionHeading(
                eyebrow: 'EXPERIÊNCIA GLOBAL',
                title: 'Produtos usados no mundo real.',
                copy:
                    'Mobile, backend, automação e infraestrutura em operações distribuídas por diferentes mercados.',
              ),
            ),
          ),
        ),
        const SizedBox(height: 34),
        const WorldExperienceMap(),
      ],
    );
  }
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
                    const Text(
                      'Vamos construir algo que funcione de verdade?',
                      style: TextStyle(
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
                  const Expanded(
                    child: Text(
                      'Vamos construir algo que funcione de verdade?',
                      style: TextStyle(
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
