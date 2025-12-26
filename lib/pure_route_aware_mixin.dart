import 'package:flutter/widgets.dart';
import 'pure_route_registry.dart';

/// Route-aware mixin for State classes.
///
/// Provides the same API as Flutter's [RouteAware], but without rebuild side-effects:
/// - [didPush] - Called when this route is pushed onto the navigator
/// - [didPop] - Called when this route is popped off the navigator
/// - [didPushNext] - Called when a new route is pushed on top (current page hidden)
/// - [didPopNext] - Called when the route above is popped (current page visible)
///
/// ## Usage
///
/// ```dart
/// class _MyPageState extends State<MyPage> with PureRouteAwareMixin<MyPage> {
///   @override
///   void didPush() => debugPrint('Page pushed');
///   @override
///   void didPop() => debugPrint('Page popped');
///   @override
///   void didPushNext() => debugPrint('Page is now hidden');
///   @override
///   void didPopNext() => debugPrint('Page is now visible');
/// }
/// ```
mixin PureRouteAwareMixin<T extends StatefulWidget> on State<T> {
  bool _visible = true;
  RouteSettings? _routeSettings;

  /// Whether the current route is visible.
  bool get isRouteVisible => _visible;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _routeSettings = ModalRoute.settingsOf(context);
        if (_routeSettings != null) {
          PureRouteRegistry.register(_routeSettings!, this);
          // Notify that this route has been pushed
          didPush();
        }
      }
    });
  }

  @override
  void dispose() {
    if (_routeSettings != null) {
      // Notify that this route is being popped before unregistering
      didPop();
      PureRouteRegistry.unregister(_routeSettings!, this);
    }
    super.dispose();
  }

  /// Called when this route is pushed onto the navigator.
  void didPush() {
    _visible = true;
  }

  /// Called when this route is popped off the navigator.
  void didPop() {
    _visible = false;
  }

  /// Called when a new route is pushed on top of this one (current page hidden).
  void didPushNext() {
    _visible = false;
  }

  /// Called when the route above is popped (current page visible again).
  void didPopNext() {
    _visible = true;
  }
}
