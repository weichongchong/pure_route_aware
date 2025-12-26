/// A pure route visibility management library.
///
/// Provides route visibility callbacks without triggering widget rebuilds,
/// as a pure alternative to Flutter's `RouteAware` with `ModalRoute.of(context)`.
///
/// ## Usage
///
/// ### 1. Register the Observer
/// ```dart
/// MaterialApp(
///   navigatorObservers: [PureRouteObserver()],
/// )
/// ```
///
/// ### 2. Use in your pages
/// ```dart
/// class _MyPageState extends State<MyPage> with PureRouteAwareMixin<MyPage> {
///   @override
///   void onRouteVisibilityChanged(bool visible) {
///     debugPrint('Page visible: $visible');
///   }
/// }
/// ```
library;

export 'pure_route_registry.dart';
export 'pure_route_aware_mixin.dart';
export 'pure_route_observer.dart';
