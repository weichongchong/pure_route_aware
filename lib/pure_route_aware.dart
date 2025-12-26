/// A pure route lifecycle management module.
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
///   void didPush() => debugPrint('Page pushed');
///
///   @override
///   void didPop() => debugPrint('Page popped');
///
///   @override
///   void didPushNext() => debugPrint('Page is now hidden');
///
///   @override
///   void didPopNext() => debugPrint('Page is now visible');
/// }
/// ```
library;

export 'pure_route_registry.dart';
export 'pure_route_aware_mixin.dart';
export 'pure_route_observer.dart';
