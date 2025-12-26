import 'package:flutter/material.dart';
import 'pure_route_registry.dart';

/// Route observer that tracks Navigator push/pop events.
///
/// Notifies registered pages about route visibility changes.
///
/// ## Usage
/// ```dart
/// MaterialApp(
///   navigatorObservers: [PureRouteObserver()],
/// )
/// ```
class PureRouteObserver extends NavigatorObserver {
  /// Whether this route should be handled (filters out popup routes).
  bool _shouldHandle(Route? route) {
    if (route == null) return false;
    // PopupRoute includes DialogRoute, ModalBottomSheetRoute, etc.
    if (route is PopupRoute) return false;
    return true;
  }

  /// Notify pages that they are now hidden (didPushNext).
  void _notifyPushNext(Route? route) {
    if (route == null) return;
    for (final page in PureRouteRegistry.findAll(route.settings)) {
      page.didPushNext();
    }
  }

  /// Notify pages that they are now visible (didPopNext).
  void _notifyPopNext(Route? route) {
    if (route == null) return;
    for (final page in PureRouteRegistry.findAll(route.settings)) {
      page.didPopNext();
    }
  }

  @override
  void didPush(Route route, Route? previousRoute) {
    // Popups don't trigger page hidden notifications
    if (!_shouldHandle(route)) return;
    _notifyPushNext(previousRoute);
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    // Popup dismissals don't trigger page visible notifications
    if (!_shouldHandle(route)) return;
    _notifyPopNext(previousRoute);
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    // Replace scenario: no notification needed
  }

  @override
  void didRemove(Route route, Route? previousRoute) {
    // Page removed: no notification needed
  }
}

