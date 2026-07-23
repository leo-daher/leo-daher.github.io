import 'package:flutter/material.dart';

import '../../brand/leone_brand.dart';
import '../../ld_identity.dart';
import '../../l10n/l10n.dart';

const _green = LeoneBrandColors.interactive;
const _blue = LeoneBrandColors.intelligence;
const _coral = LeoneBrandColors.editorialHighlight;

class PortfolioHero extends StatelessWidget {
  const PortfolioHero({super.key, required this.autoPlay});

  final bool autoPlay;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final palette = context.leonePalette;
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 700;
        final nameSize = compact ? 68.0 : 108.0;
        final roleSize = compact ? 30.0 : 48.0;
        const accent = _green;
        return Container(
          key: const Key('portfolio-hero'),
          height: compact ? 620 : 880,
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
                    Text(
                      l10n.mobileEngineer,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: roleSize,
                        height: 1.03,
                        letterSpacing: compact ? -1.2 : -2.1,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: compact ? 24 : 30),
                    Expanded(
                      child: _BrandedViewportFrame(
                        autoPlay: autoPlay,
                        showDesktopAccessories: compact,
                        alignment: compact
                            ? Alignment.topCenter
                            : Alignment.center,
                      ),
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
  const _BrandedViewportFrame({
    required this.autoPlay,
    required this.showDesktopAccessories,
    required this.alignment,
  });

  final bool autoPlay;
  final bool showDesktopAccessories;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    return SelectionContainer.disabled(
      child: RepaintBoundary(
        child: LdViewportStage(
          key: const Key('hero-viewport-stage'),
          autoPlay: autoPlay,
          alignment: alignment,
          mobilePresetScale: .82,
          accessoryBuilder: showDesktopAccessories
              ? (context, morph, frameSize) =>
                    _DesktopInputSketch(morph: morph, frameSize: frameSize)
              : null,
          frames: [
            LdViewportFrameSpec(
              id: 'content',
              showActionButton: false,
              builder: (context, morph) => _IdentityFrameContent(morph: morph),
            ),
          ],
        ),
      ),
    );
  }
}

class _DesktopInputSketch extends StatelessWidget {
  const _DesktopInputSketch({required this.morph, required this.frameSize});

  final LdViewportMorph morph;
  final Size frameSize;

  @override
  Widget build(BuildContext context) {
    final desktopPresence = switch ((morph.from, morph.to)) {
      (LdViewportPreset.desktop, LdViewportPreset.desktop) => 1.0,
      (LdViewportPreset.desktop, _) => 1 - morph.progress,
      (_, LdViewportPreset.desktop) => morph.progress,
      _ => 0.0,
    };
    final height = (frameSize.width * .26).clamp(82.0, 112.0);
    return IgnorePointer(
      child: Opacity(
        key: const Key('hero-desktop-input-sketch'),
        opacity: desktopPresence * .38,
        child: Transform.translate(
          offset: Offset(0, (1 - desktopPresence) * 8),
          child: CustomPaint(
            size: Size(frameSize.width, height),
            painter: _DesktopInputPainter(color: context.leonePalette.mutedInk),
          ),
        ),
      ),
    );
  }
}

class _DesktopInputPainter extends CustomPainter {
  const _DesktopInputPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final stroke = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.15
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final keyboard = Rect.fromLTWH(
      size.width * .11,
      size.height * .08,
      size.width * .62,
      size.height * .68,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(keyboard, const Radius.circular(10)),
      stroke,
    );

    final keyLeft = keyboard.left + keyboard.width * .08;
    final keyRight = keyboard.right - keyboard.width * .08;
    final keyWidth = (keyRight - keyLeft) / 10;
    for (var row = 0; row < 3; row++) {
      final y = keyboard.top + keyboard.height * (.23 + row * .20);
      final inset = row == 1 ? keyWidth * .35 : 0.0;
      for (var key = 0; key < 9; key++) {
        final x = keyLeft + inset + key * keyWidth;
        canvas.drawLine(Offset(x, y), Offset(x + keyWidth * .48, y), stroke);
      }
    }
    canvas.drawLine(
      Offset(keyboard.left + keyboard.width * .34, keyboard.bottom - 11),
      Offset(keyboard.right - keyboard.width * .34, keyboard.bottom - 11),
      stroke,
    );

    final mouse = Rect.fromLTWH(
      size.width * .80,
      size.height * .12,
      size.width * .09,
      size.height * .58,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(mouse, Radius.circular(mouse.width * .48)),
      stroke,
    );
    canvas.drawLine(
      Offset(mouse.center.dx, mouse.top + mouse.height * .08),
      Offset(mouse.center.dx, mouse.top + mouse.height * .34),
      stroke,
    );
    canvas.drawLine(
      Offset(mouse.center.dx, mouse.top + mouse.height * .17),
      Offset(mouse.center.dx, mouse.top + mouse.height * .23),
      stroke..strokeWidth = 2.2,
    );
  }

  @override
  bool shouldRepaint(covariant _DesktopInputPainter oldDelegate) =>
      oldDelegate.color != color;
}

class _IdentityFrameContent extends StatelessWidget {
  const _IdentityFrameContent({required this.morph});

  final LdViewportMorph morph;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Size(constraints.maxWidth, constraints.maxHeight);
        final from = _InterfaceLayout.resolve(morph.from, size);
        final to = _InterfaceLayout.resolve(morph.to, size);
        Rect position(Rect a, Rect b) => Rect.lerp(a, b, morph.progress)!;
        return DecoratedBox(
          decoration: const BoxDecoration(
            gradient: RadialGradient(
              center: Alignment(.2, -.2),
              radius: 1.15,
              colors: [Color(0xFF171329), Color(0xFF0B0A12)],
            ),
          ),
          child: Stack(
            children: [
              Positioned.fromRect(
                rect: position(from.topBar, to.topBar),
                child: const _InterfaceTopBar(
                  key: Key('hero-interface-topbar'),
                ),
              ),
              Positioned.fromRect(
                rect: position(from.navigation, to.navigation),
                child: const _InterfaceNavigation(
                  key: Key('hero-interface-navigation'),
                ),
              ),
              Positioned.fromRect(
                rect: position(from.message, to.message),
                child: _InterfaceMessage(
                  key: const Key('hero-interface-message'),
                  label: context.l10n.everySurface,
                ),
              ),
              Positioned.fromRect(
                rect: position(from.primaryCard, to.primaryCard),
                child: const _InterfaceCard(
                  key: Key('hero-interface-primary-card'),
                  identifier: _green,
                  emphasis: true,
                ),
              ),
              Positioned.fromRect(
                rect: position(from.secondaryCard, to.secondaryCard),
                child: const _InterfaceCard(
                  key: Key('hero-interface-secondary-card'),
                  identifier: _blue,
                ),
              ),
              Positioned.fromRect(
                rect: position(from.identifiers, to.identifiers),
                child: const _InterfaceIdentifiers(
                  key: Key('hero-interface-identifiers'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _InterfaceLayout {
  const _InterfaceLayout({
    required this.topBar,
    required this.navigation,
    required this.message,
    required this.primaryCard,
    required this.secondaryCard,
    required this.identifiers,
  });

  final Rect topBar;
  final Rect navigation;
  final Rect message;
  final Rect primaryCard;
  final Rect secondaryCard;
  final Rect identifiers;

  static _InterfaceLayout resolve(LdViewportPreset preset, Size size) {
    Rect area(double left, double top, double width, double height) =>
        Rect.fromLTWH(
          size.width * left,
          size.height * top,
          size.width * width,
          size.height * height,
        );
    return switch (preset) {
      LdViewportPreset.desktop => _InterfaceLayout(
        topBar: area(.05, .06, .90, .11),
        navigation: area(.05, .23, .14, .67),
        message: area(.24, .23, .41, .23),
        primaryCard: area(.24, .53, .41, .37),
        secondaryCard: area(.69, .23, .26, .32),
        identifiers: area(.69, .63, .26, .15),
      ),
      LdViewportPreset.tablet => _InterfaceLayout(
        topBar: area(.06, .06, .88, .12),
        navigation: area(.06, .24, .88, .12),
        message: area(.06, .42, .54, .19),
        primaryCard: area(.06, .67, .54, .27),
        secondaryCard: area(.65, .42, .29, .31),
        identifiers: area(.65, .80, .29, .14),
      ),
      LdViewportPreset.mobile => _InterfaceLayout(
        topBar: area(.08, .05, .84, .09),
        navigation: area(.53, .86, .39, .08),
        message: area(.08, .20, .84, .15),
        primaryCard: area(.08, .41, .84, .23),
        secondaryCard: area(.08, .70, .84, .12),
        identifiers: area(.08, .86, .39, .08),
      ),
    };
  }
}

class _InterfaceTopBar extends StatelessWidget {
  const _InterfaceTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .05),
        borderRadius: BorderRadius.circular(99),
        border: Border.all(color: Colors.white.withValues(alpha: .07)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          children: [
            const _Identifier(color: _green),
            const SizedBox(width: 7),
            const Expanded(child: _SkeletonLine(widthFactor: .55)),
            const Spacer(flex: 2),
            const SizedBox(width: 24, child: _SkeletonLine(widthFactor: .75)),
            const SizedBox(width: 7),
            Container(
              width: 7,
              height: 7,
              decoration: const BoxDecoration(
                color: LeoneBrandColors.action,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InterfaceNavigation extends StatelessWidget {
  const _InterfaceNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final vertical = constraints.maxHeight > constraints.maxWidth;
        final items = <Widget>[
          const _NavigationItem(color: _green),
          const _NavigationItem(color: _blue),
          const _NavigationItem(color: _coral),
        ];
        return DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: .04),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withValues(alpha: .06)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: Flex(
              direction: vertical ? Axis.vertical : Axis.horizontal,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: items,
            ),
          ),
        );
      },
    );
  }
}

class _NavigationItem extends StatelessWidget {
  const _NavigationItem({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 18 || constraints.maxHeight < 7) {
            final size = Size(
              constraints.maxWidth,
              constraints.maxHeight,
            ).shortestSide.clamp(0.0, 5.0);
            return Center(
              child: _Identifier(color: color, size: size),
            );
          }
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _Identifier(color: color),
              const SizedBox(width: 5),
              const Flexible(child: _SkeletonLine(widthFactor: .65)),
            ],
          );
        },
      ),
    );
  }
}

class _InterfaceMessage extends StatelessWidget {
  const _InterfaceMessage({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxHeight < 48;
        final fontSize = (constraints.maxHeight * .30).clamp(7.5, 14.0);
        final displayLabel = constraints.maxWidth < 280
            ? label.replaceFirst('. ', '.\n')
            : label;
        return Padding(
          padding: EdgeInsets.symmetric(vertical: compact ? 0 : 2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                displayLabel,
                maxLines: 2,
                overflow: TextOverflow.clip,
                softWrap: true,
                style: TextStyle(
                  color: _green,
                  fontSize: fontSize,
                  height: 1,
                  fontWeight: FontWeight.w800,
                  letterSpacing: .8,
                ),
              ),
              const _SkeletonLine(widthFactor: .94, strong: true),
              if (!compact) ...[
                const _SkeletonLine(widthFactor: .72, strong: true),
                const _SkeletonLine(widthFactor: .48),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _InterfaceCard extends StatelessWidget {
  const _InterfaceCard({
    super.key,
    required this.identifier,
    this.emphasis = false,
  });

  final Color identifier;
  final bool emphasis;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxHeight < 48;
        return DecoratedBox(
          decoration: BoxDecoration(
            color: emphasis
                ? _green.withValues(alpha: .10)
                : Colors.white.withValues(alpha: .045),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: emphasis
                  ? _green.withValues(alpha: .20)
                  : Colors.white.withValues(alpha: .07),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(compact ? 6 : 8),
            child: compact
                ? Row(
                    children: [
                      _Identifier(color: identifier),
                      const SizedBox(width: 6),
                      const Expanded(
                        child: _SkeletonLine(widthFactor: .82, strong: true),
                      ),
                      const SizedBox(width: 6),
                      const Expanded(child: _SkeletonLine(widthFactor: .54)),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          _Identifier(color: identifier),
                          const SizedBox(width: 6),
                          const Expanded(
                            child: _SkeletonLine(widthFactor: .42),
                          ),
                        ],
                      ),
                      const _SkeletonLine(widthFactor: .88, strong: true),
                      const _SkeletonLine(widthFactor: .64),
                      const _SkeletonLine(widthFactor: .38),
                    ],
                  ),
          ),
        );
      },
    );
  }
}

class _InterfaceIdentifiers extends StatelessWidget {
  const _InterfaceIdentifiers({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (final color in const [_green, _blue, _coral]) ...[
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: color.withValues(alpha: .18),
                borderRadius: BorderRadius.circular(99),
                border: Border.all(color: color.withValues(alpha: .28)),
              ),
            ),
          ),
          const SizedBox(width: 4),
        ],
      ],
    );
  }
}

class _Identifier extends StatelessWidget {
  const _Identifier({required this.color, this.size = 7});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(2.5),
      ),
    );
  }
}

class _SkeletonLine extends StatelessWidget {
  const _SkeletonLine({required this.widthFactor, this.strong = false});

  final double widthFactor;
  final bool strong;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: FractionallySizedBox(
        widthFactor: widthFactor,
        child: Container(
          height: strong ? 5 : 3,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: strong ? .34 : .16),
            borderRadius: BorderRadius.circular(99),
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
