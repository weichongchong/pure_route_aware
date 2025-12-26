import 'package:flutter/widgets.dart';
import 'pure_route_registry.dart';

/// Route-aware mixin for State classes.
///
/// Provides route visibility callbacks without triggering widget rebuilds.
/// Unlike Flutter's [RouteAware] which uses `ModalRoute.of(context)`,
/// this mixin uses `ModalRoute.settingsOf(context)` to avoid rebuild side-effects.
///
/// ## Callbacks
/// - [onRouteVisibilityChanged] - Called when visibility changes (recommended)
/// - [didPushNext] - Called when a new route is pushed on top (page hidden)
/// - [didPopNext] - Called when the route above is popped (page visible)
///
/// ## Usage
///
/// Simple way (recommended):
/// ```dart
/// class _MyPageState extends State<MyPage> with PureRouteAwareMixin<MyPage> {
///   @override
///   void onRouteVisibilityChanged(bool visible) {
///     if (visible) {
///       videoController.play();
///     } else {
///       videoController.pause();
///     }
///   }
/// }
/// ```
///
/// Or use separate callbacks:
/// ```dart
/// class _MyPageState extends State<MyPage> with PureRouteAwareMixin<MyPage> {
///   @override
///   void didPushNext() {
///     super.didPushNext();
///     videoController.pause();
///   }
///
///   @override
///   void didPopNext() {
///     super.didPopNext();
///     videoController.play();
///   }
/// }
/// ```
mixin PureRouteAwareMixin<T extends StatefulWidget> on State<T> {
  bool _visible = true;
  RouteSettings? _routeSettings;

  /// Whether the current route is visible (not covered by another route).
  bool get isRouteVisible => _visible;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _routeSettings = ModalRoute.settingsOf(context);
        if (_routeSettings != null) {
          PureRouteRegistry.register(_routeSettings!, this);
        }
      }
    });
  }

  @override
  void dispose() {
    if (_routeSettings != null) {
      PureRouteRegistry.unregister(_routeSettings!, this);
    }
    super.dispose();
  }

  /// Called when a new route is pushed on top of this one (current page hidden).
  void didPushNext() {
    _visible = false;
    onRouteVisibilityChanged(false);
  }

  /// Called when the route above is popped (current page visible again).
  void didPopNext() {
    _visible = true;
    onRouteVisibilityChanged(true);
  }

  /// Called when route visibility changes.
  ///
  /// [visible] is `true` when the page becomes visible (didPopNext),
  /// `false` when the page becomes hidden (didPushNext).
  ///
  /// Note: This only monitors visibility changes caused by route navigation.
  /// It does NOT detect other visibility changes like app going to background,
  /// widget being obscured by overlays, etc.
  ///
  /// Override this method for a simpler API instead of overriding
  /// both [didPushNext] and [didPopNext].
  void onRouteVisibilityChanged(bool visible) {}
}
