import 'package:flutter/material.dart';

import '../../brand/leone_brand.dart';
import '../../l10n/l10n.dart';
import '../shared/portfolio_section_heading.dart';

const _panelSoft = LeoneBrandColors.surfaceRaised;
const _muted = LeoneBrandColors.mutedInk;
const _green = LeoneBrandColors.interactive;
const _blue = LeoneBrandColors.intelligence;
const _coral = LeoneBrandColors.editorialHighlight;
const _amber = LeoneBrandColors.editorialWarm;

class PortfolioProjectsSection extends StatelessWidget {
  const PortfolioProjectsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PortfolioSectionHeading(
          title: context.l10n.projectsTitle,
          copy: context.l10n.projectsCopy,
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
                  label: '01  •  ${context.l10n.dealRadar}',
                  title: 'Mobile Systems',
                  copy: context.l10n.mobileProjectCopy,
                  accent: _green,
                  visual: _ProjectVisualType.mobile,
                ),
                _ProjectCard(
                  width: width,
                  label: '02  •  CAREER COPILOT',
                  title: 'Agentic Workflows',
                  copy: context.l10n.agentsProjectCopy,
                  accent: _blue,
                  visual: _ProjectVisualType.agents,
                ),
                _ProjectCard(
                  width: width,
                  label: '03  •  LOCAL LLM LAB',
                  title: 'Automation Lab',
                  copy: context.l10n.automationProjectCopy,
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
