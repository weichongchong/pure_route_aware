import 'package:flutter/widgets.dart';
import 'pure_route_aware_mixin.dart';

/// Route page registry.
///
/// Supports registering multiple [PureRouteAwareMixin] instances for the same
/// [RouteSettings] (e.g., multiple child widgets on one page).
class PureRouteRegistry {
  static final Map<RouteSettings, List<PureRouteAwareMixin>> _map = {};

  /// Register a page with the given route settings.
  static void register(RouteSettings settings, PureRouteAwareMixin page) {
    _map.putIfAbsent(settings, () => []);
    if (!_map[settings]!.contains(page)) {
      _map[settings]!.add(page);
    }
  }

  /// Unregister a page from the given route settings.
  static void unregister(RouteSettings settings, PureRouteAwareMixin page) {
    _map[settings]?.remove(page);
    if (_map[settings]?.isEmpty ?? false) {
      _map.remove(settings);
    }
  }

  /// Find all registered pages for the given route settings.
  static List<PureRouteAwareMixin> findAll(RouteSettings? settings) {
    if (settings == null) return [];
    return _map[settings] ?? [];
  }

  /// Clear all registrations (used for testing).
  static void clear() {
    _map.clear();
  }
}

