# pure_route_aware

[![pub package](https://img.shields.io/pub/v/pure_route_aware.svg)](https://pub.dev/packages/pure_route_aware)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)

A **pure** alternative to Flutter's `RouteAware` for route visibility callbacks **without triggering widget rebuilds**.

## The Problem

When using Flutter's built-in `RouteAware` with `RouteObserver`, you typically need to call `ModalRoute.of(context)` to get the current route. However, `ModalRoute.of(context)` creates a dependency on `InheritedWidget`, which causes your widget to **rebuild** whenever the route's state changes.

## The Solution

`pure_route_aware` uses `ModalRoute.settingsOf(context)` instead, which only reads the route's settings without creating a rebuild dependency. This gives you the same callbacks as `RouteAware` without the performance overhead.

## Features

- ✅ **No rebuild side-effects** - Uses `ModalRoute.settingsOf()` instead of `ModalRoute.of()`
- ✅ **Same API as RouteAware** - All 4 callbacks: `didPush`, `didPop`, `didPushNext`, `didPopNext`
- ✅ **Popup filtering** - Dialogs and bottom sheets don't trigger visibility callbacks
- ✅ **Multiple listeners** - Multiple widgets on the same route can listen independently
- ✅ **Easy to use** - Just a mixin and an observer

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  pure_route_aware: ^1.0.0
```

## Usage

### 1. Register the Observer

Add `PureRouteObserver` to your `MaterialApp`:

```dart
import 'package:pure_route_aware/pure_route_aware.dart';

MaterialApp(
  navigatorObservers: [PureRouteObserver()],
  // ...
)
```

### 2. Use the Mixin in Your Pages

```dart
import 'package:pure_route_aware/pure_route_aware.dart';

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> with PureRouteAwareMixin<MyPage> {
  @override
  void didPush() {
    // Called when this route is pushed onto the navigator
    debugPrint('Page pushed');
  }

  @override
  void didPop() {
    // Called when this route is popped off the navigator
    debugPrint('Page popped');
  }

  @override
  void didPushNext() {
    // Called when a new route is pushed on top of this one
    debugPrint('Page is now hidden');
    // Pause video, stop animations, etc.
  }

  @override
  void didPopNext() {
    // Called when the route above this one is popped
    debugPrint('Page is now visible');
    // Resume video, refresh data, etc.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Page')),
      body: const Center(child: Text('Hello')),
    );
  }
}
```

### 3. Check Visibility Status

You can also check if the current route is visible:

```dart
class _MyPageState extends State<MyPage> with PureRouteAwareMixin<MyPage> {
  void someMethod() {
    if (isRouteVisible) {
      // Do something only when visible
    }
  }
}
```

## API Reference

### PureRouteObserver

A `NavigatorObserver` that tracks route changes and notifies registered pages.

### PureRouteAwareMixin

A mixin for `State` classes that provides route visibility callbacks:

| Property/Method | Description |
|-----------------|-------------|
| `isRouteVisible` | Returns `true` if the current route is visible |
| `didPush()` | Called when this route is pushed onto the navigator |
| `didPop()` | Called when this route is popped off the navigator |
| `didPushNext()` | Called when a new route is pushed on top |
| `didPopNext()` | Called when the route above is popped |

### PureRouteRegistry

Internal registry for managing route-to-widget mappings. Typically not used directly.

## Comparison with RouteAware

| Feature | RouteAware | PureRouteAwareMixin |
|---------|------------|---------------------|
| Requires `ModalRoute.of()` | Yes | No |
| Causes rebuilds | Yes | No |
| Popup filtering | Manual | Automatic |
| Multiple listeners per route | Complex | Built-in |
| Callbacks | 4 | 4 (same) |

## License

MIT License - see [LICENSE](LICENSE) for details.
