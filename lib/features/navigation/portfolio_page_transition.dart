import 'package:material_ui/material_ui.dart';

import '../../brand/leone_brand.dart';

/// A full-width horizontal route that makes adjacent pages feel like one plane.
///
/// The primary animation brings the new page from the trailing edge. The
/// secondary animation moves the previous page through the leading edge at the
/// same time. Reversing the route reverses both movements, and the regular
/// Navigator/Overlay relationship remains intact for Hero flights.
class PortfolioPlanePageRoute<T> extends PageRouteBuilder<T> {
  PortfolioPlanePageRoute({
    required super.settings,
    required super.pageBuilder,
    required bool reduceMotion,
    super.maintainState,
  }) : super(
         transitionDuration: reduceMotion
             ? Duration.zero
             : LeoneBrandMotion.pageTransitionForward,
         reverseTransitionDuration: reduceMotion
             ? Duration.zero
             : LeoneBrandMotion.pageTransitionReverse,
         transitionsBuilder: _buildPlaneTransition,
       );

  static final Animatable<Offset> _incoming = Tween<Offset>(
    begin: const Offset(1, 0),
    end: Offset.zero,
  ).chain(CurveTween(curve: LeoneBrandMotion.pageTransitionCurve));

  static final Animatable<Offset> _outgoing = Tween<Offset>(
    begin: Offset.zero,
    end: const Offset(-1, 0),
  ).chain(CurveTween(curve: LeoneBrandMotion.pageTransitionCurve));

  static Widget _buildPlaneTransition(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) => ClipRect(
    child: SlideTransition(
      key: const Key('portfolio-plane-secondary-transition'),
      position: _outgoing.animate(secondaryAnimation),
      textDirection: Directionality.of(context),
      child: SlideTransition(
        key: const Key('portfolio-plane-primary-transition'),
        position: _incoming.animate(animation),
        textDirection: Directionality.of(context),
        child: child,
      ),
    ),
  );
}
