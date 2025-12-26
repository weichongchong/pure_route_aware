import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pure_route_aware/pure_route_aware.dart';

void main() {
  setUp(() {
    PureRouteRegistry.clear();
  });

  group('PureRouteRegistry', () {
    test('register and findAll should work correctly', () {
      final settings = const RouteSettings(name: '/test');
      final mockPage = _MockPureRouteAware();

      PureRouteRegistry.register(settings, mockPage);

      final found = PureRouteRegistry.findAll(settings);
      expect(found, contains(mockPage));
      expect(found.length, 1);
    });

    test('should not register duplicate pages', () {
      final settings = const RouteSettings(name: '/test');
      final mockPage = _MockPureRouteAware();

      PureRouteRegistry.register(settings, mockPage);
      PureRouteRegistry.register(settings, mockPage);

      final found = PureRouteRegistry.findAll(settings);
      expect(found.length, 1);
    });

    test('unregister should remove page', () {
      final settings = const RouteSettings(name: '/test');
      final mockPage = _MockPureRouteAware();

      PureRouteRegistry.register(settings, mockPage);
      PureRouteRegistry.unregister(settings, mockPage);

      final found = PureRouteRegistry.findAll(settings);
      expect(found, isEmpty);
    });

    test('findAll returns empty list for null settings', () {
      final found = PureRouteRegistry.findAll(null);
      expect(found, isEmpty);
    });

    test('findAll returns empty list for unregistered settings', () {
      final settings = const RouteSettings(name: '/unknown');
      final found = PureRouteRegistry.findAll(settings);
      expect(found, isEmpty);
    });

    test('clear should remove all registrations', () {
      final settings1 = const RouteSettings(name: '/test1');
      final settings2 = const RouteSettings(name: '/test2');
      final mockPage1 = _MockPureRouteAware();
      final mockPage2 = _MockPureRouteAware();

      PureRouteRegistry.register(settings1, mockPage1);
      PureRouteRegistry.register(settings2, mockPage2);
      PureRouteRegistry.clear();

      expect(PureRouteRegistry.findAll(settings1), isEmpty);
      expect(PureRouteRegistry.findAll(settings2), isEmpty);
    });
  });

  group('PureRouteObserver', () {
    test('should be a NavigatorObserver', () {
      final observer = PureRouteObserver();
      expect(observer, isA<NavigatorObserver>());
    });
  });
}

/// Mock implementation of PureRouteAwareMixin for testing
class _MockPureRouteAware extends State<StatefulWidget>
    with PureRouteAwareMixin<StatefulWidget> {
  int pushNextCount = 0;
  int popNextCount = 0;

  @override
  void didPushNext() {
    super.didPushNext();
    pushNextCount++;
  }

  @override
  void didPopNext() {
    super.didPopNext();
    popNextCount++;
  }

  @override
  Widget build(BuildContext context) => const SizedBox();
}

