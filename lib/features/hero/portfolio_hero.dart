import 'package:flutter/material.dart';

import '../../brand/leone_brand.dart';
import '../../ld_identity.dart';
import '../../l10n/l10n.dart';

const _green = LeoneBrandColors.interactive;
const _blue = LeoneBrandColors.intelligence;
const _coral = LeoneBrandColors.editorialHighlight;

class PortfolioHero extends StatefulWidget {
  const PortfolioHero({super.key, required this.autoPlay});

  final bool autoPlay;

  @override
  State<PortfolioHero> createState() => _HeroState();
}

class _HeroState extends State<PortfolioHero> {
  int focus = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final palette = context.leonePalette;
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 700;
        final nameSize = compact ? 68.0 : 108.0;
        final roleSize = compact ? 30.0 : 48.0;
        final accent = focus == 0 ? _green : _blue;
        final role = focus == 0
            ? l10n.mobileEngineer
            : l10n.aiAutomationEngineer;
        final supportingLine = focus == 0
            ? l10n.mobileSupporting
            : l10n.aiSupporting;
        return Container(
          height: compact ? 900 : 880,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: palette.canvas,
            borderRadius: BorderRadius.circular(compact ? 28 : 40),
            border: Border.all(color: palette.outline),
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
                      l10n.yearsBuildingSoftware,
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
                          color: palette.mutedInk,
                          fontSize: compact ? 14 : 17,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    SizedBox(height: compact ? 24 : 30),
                    Expanded(
                      child: _BrandedViewportFrame(autoPlay: widget.autoPlay),
                    ),
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
  const _BrandedViewportFrame({required this.autoPlay});

  final bool autoPlay;

  @override
  Widget build(BuildContext context) {
    return SelectionContainer.disabled(
      child: RepaintBoundary(
        child: LdViewportStage(
          autoPlay: autoPlay,
          child: const _IdentityFrameContent(),
        ),
      ),
    );
  }
}

class _IdentityFrameContent extends StatelessWidget {
  const _IdentityFrameContent();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return LayoutBuilder(
      builder: (context, constraints) {
        final horizontal = constraints.maxHeight < 170;
        final title = Text(
          'Flutter',
          maxLines: 1,
          style: TextStyle(
            color: LeoneBrandColors.ink,
            fontSize: horizontal ? 18 : 24,
            fontWeight: FontWeight.w800,
            letterSpacing: -.7,
          ),
        );
        final detail = Text(
          l10n.surfaceList,
          maxLines: 1,
          overflow: TextOverflow.fade,
          style: const TextStyle(
            color: LeoneBrandColors.mutedInk,
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
                      Text(
                        context.l10n.everySurface,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
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
  Widget build(BuildContext context) {
    final palette = context.leonePalette;
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: palette.surfaceRaised.withValues(alpha: .72),
        borderRadius: BorderRadius.circular(99),
        border: Border.all(color: palette.outline),
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
            label: context.l10n.aiAutomationTab,
            compact: compact,
            selected: selected == 1,
            accent: _blue,
            onTap: () => onSelected(1),
          ),
        ],
      ),
    );
  }
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
  Widget build(BuildContext context) {
    final palette = context.leonePalette;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(99),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 240),
        padding: EdgeInsets.symmetric(
          horizontal: compact ? 12 : 18,
          vertical: compact ? 9 : 10,
        ),
        decoration: BoxDecoration(
          color: selected ? palette.ink : Colors.transparent,
          borderRadius: BorderRadius.circular(99),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: accent.withValues(alpha: .22),
                    blurRadius: 18,
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? palette.canvas : palette.mutedInk,
            fontSize: compact ? 10 : 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
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
