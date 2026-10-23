import 'package:flutter/material.dart';

part 'mark.g.dart';

enum LeoneSignatureVariant { footer, menu, compact }

/// Local, dependency-free brand signature. The host owns navigation and errors.
class LeoneSignature extends StatelessWidget {
  const LeoneSignature({
    super.key,
    required this.onPressed,
    this.locale = const Locale('en'),
    this.variant = LeoneSignatureVariant.footer,
    this.brightness,
  });

  final VoidCallback onPressed;
  final Locale locale;
  final LeoneSignatureVariant variant;
  final Brightness? brightness;

  static Uri portfolioUri(Locale locale) => Uri.parse(
    locale.languageCode == 'pt'
        ? 'https://leo-daher.github.io/pt/'
        : 'https://leo-daher.github.io/',
  );

  @override
  Widget build(BuildContext context) {
    final dark =
        (brightness ?? Theme.of(context).brightness) == Brightness.dark;
    final ink = dark ? const Color(0xFFF3F6F5) : const Color(0xFF171721);
    final muted = dark ? const Color(0xFFB7B2C8) : const Color(0xFF5D5D6B);
    final label = switch (locale.languageCode) {
      'pt' => 'Desenvolvido por',
      'es' => 'Desarrollado por',
      _ => 'Developed by',
    };
    final accessibleLabel = switch (locale.languageCode) {
      'pt' => 'Conheça o portfólio de Leone Daher',
      'es' => 'Visita el portafolio de Leone Daher',
      _ => 'Visit Leone Daher’s portfolio',
    };
    final compact = variant == LeoneSignatureVariant.compact;
    final radius = BorderRadius.circular(14);
    return Semantics(
      link: true,
      label: accessibleLabel,
      child: Tooltip(
        message: accessibleLabel,
        excludeFromSemantics: true,
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: onPressed,
            borderRadius: radius,
            child: Container(
              constraints: const BoxConstraints(minHeight: 60),
              padding: EdgeInsets.fromLTRB(10, 8, compact ? 10 : 14, 8),
              decoration: BoxDecoration(
                borderRadius: radius,
                border: Border.all(color: ink.withValues(alpha: .13)),
              ),
              child: ExcludeSemantics(
                child: Row(
                  mainAxisSize:
                      variant == LeoneSignatureVariant.menu
                          ? MainAxisSize.max
                          : MainAxisSize.min,
                  children: [
                    CustomPaint(
                      size: const Size.square(40),
                      painter: _Mark(dark),
                    ),
                    if (!compact) ...[
                      const SizedBox(width: 12),
                      Flexible(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              label,
                              style: TextStyle(
                                color: muted,
                                fontSize: 10,
                                height: 1.5,
                              ),
                            ),
                            Text(
                              'Leone Daher',
                              style: TextStyle(
                                color: ink,
                                fontSize: 13,
                                height: 1.4,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (variant == LeoneSignatureVariant.menu) const Spacer(),
                      const SizedBox(width: 24),
                      Icon(Icons.north_east_rounded, size: 16, color: muted),
                    ],
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

// Geometry and colors follow assets/brand/ld-mark*.svg in the portfolio.
class _Mark extends CustomPainter {
  const _Mark(this.dark);
  final bool dark;

  @override
  void paint(Canvas canvas, Size size) =>
      _paintSignatureMark(canvas, size, dark);

  @override
  bool shouldRepaint(covariant _Mark oldDelegate) => dark != oldDelegate.dark;
}
