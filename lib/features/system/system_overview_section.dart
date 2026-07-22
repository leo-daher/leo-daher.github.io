import 'package:flutter/material.dart';

import '../../brand/leone_brand.dart';
import '../../l10n/l10n.dart';

const _green = LeoneBrandColors.interactive;
const _blue = LeoneBrandColors.intelligence;
const _amber = LeoneBrandColors.editorialWarm;

class SystemOverviewSection extends StatelessWidget {
  const SystemOverviewSection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final palette = context.leonePalette;
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
            color: palette.surface.withValues(alpha: .78),
            borderRadius: BorderRadius.circular(compact ? 24 : 30),
            border: Border.all(color: palette.outline),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.systemEyebrow,
                          style: const TextStyle(
                            color: _green,
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.3,
                          ),
                        ),
                        const SizedBox(height: 7),
                        Text(
                          l10n.systemTitle,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (!compact)
                    Text(
                      l10n.systemFlow,
                      style: TextStyle(
                        color: palette.mutedInk,
                        fontSize: 10,
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

class _SystemDiagram extends StatelessWidget {
  const _SystemDiagram({required this.focus, required this.compact});

  final int focus;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final mobile = _SystemNode(
      eyebrow: l10n.productLabel,
      title: 'Mobile',
      detail: 'Flutter · Android · iOS',
      icon: Icons.phone_iphone_rounded,
      accent: _green,
      highlighted: focus == 0,
      compact: compact,
    );
    final backend = _SystemNode(
      eyebrow: l10n.servicesLabel,
      title: 'Python Backend',
      detail: l10n.backendDetail,
      icon: Icons.dns_rounded,
      accent: _amber,
      compact: compact,
    );
    final ai = _SystemNode(
      eyebrow: l10n.intelligenceLabel,
      title: l10n.aiSystems,
      detail: l10n.aiDetail,
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
                _SystemConnector(label: l10n.requests, vertical: true),
                backend,
                _SystemConnector(label: l10n.contextTools, vertical: true),
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
                      SizedBox(
                        width: 116,
                        child: _SystemConnector(label: l10n.contextTools),
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
  Widget build(BuildContext context) {
    final palette = context.leonePalette;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 360),
      height: compact ? 58 : 126,
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 12 : 16,
        vertical: compact ? 8 : 14,
      ),
      decoration: BoxDecoration(
        color: highlighted
            ? accent.withValues(alpha: .12)
            : palette.surface.withValues(alpha: .84),
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
                      fontSize: 10,
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
                  style: TextStyle(
                    color: palette.mutedInk,
                    fontSize: compact ? 10 : 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SystemConnector extends StatelessWidget {
  const _SystemConnector({required this.label, this.vertical = false});

  final String label;
  final bool vertical;

  @override
  Widget build(BuildContext context) {
    final palette = context.leonePalette;
    return SizedBox(
      height: vertical ? 22 : 126,
      child: vertical
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.arrow_downward_rounded,
                  size: 12,
                  color: palette.mutedInk,
                ),
                const SizedBox(width: 5),
                Text(
                  label,
                  style: TextStyle(
                    color: palette.mutedInk,
                    fontSize: 10,
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
                  style: TextStyle(
                    color: palette.mutedInk,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: .7,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(child: Divider(color: palette.outline, height: 1)),
                    Icon(
                      Icons.arrow_forward_rounded,
                      size: 14,
                      color: palette.mutedInk,
                    ),
                  ],
                ),
              ],
            ),
    );
  }
}

class _SystemReturnLabel extends StatelessWidget {
  const _SystemReturnLabel({required this.compact});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    final palette = context.leonePalette;
    return Row(
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
              ? context.l10n.resultsReturnMobile
              : context.l10n.decisionsReturnProduct,
          style: TextStyle(
            color: palette.mutedInk,
            fontSize: compact ? 10 : 11,
            fontWeight: FontWeight.w800,
            letterSpacing: compact ? .55 : .9,
          ),
        ),
      ],
    );
  }
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
