import 'package:flutter/material.dart';

import '../../brand/leone_brand.dart';

/// Horizontal page motion applied below the persistent portfolio header.
///
/// The opaque page surface moves edge to edge, while the header remains
/// outside this widget so its geometry never shifts.
class PortfolioPageTransition extends StatelessWidget {
  const PortfolioPageTransition({
    super.key,
    required this.animation,
    required this.child,
  });

  final Animation<double> animation;
  final Widget child;

  static final Animatable<Offset> _translation = Tween<Offset>(
    begin: const Offset(1, 0),
    end: Offset.zero,
  ).chain(CurveTween(curve: LeoneBrandMotion.pageTransitionCurve));

  @override
  Widget build(BuildContext context) {
    final accessibilityFeatures = View.of(
      context,
    ).platformDispatcher.accessibilityFeatures;
    final reduceMotion =
        MediaQuery.disableAnimationsOf(context) ||
        accessibilityFeatures.disableAnimations ||
        accessibilityFeatures.reduceMotion;

    if (reduceMotion) return child;

    return SlideTransition(
      position: _translation.animate(animation),
      textDirection: Directionality.of(context),
      child: child,
    );
  }
}
