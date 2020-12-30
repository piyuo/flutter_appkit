import 'package:flutter/widgets.dart';
import 'package:mockito/mockito.dart';

/// MockNavigatorObserver used for mock NavigatorObserver
///
class MockNavigator extends Mock implements NavigatorObserver {
  @override
  void didPush(Route<dynamic>? route, Route<dynamic>? previousRoute) =>
      super.noSuchMethod(Invocation.method(#didPush, [route, previousRoute]));

  @override
  void didPop(Route<dynamic>? route, Route<dynamic>? previousRoute) =>
      super.noSuchMethod(Invocation.method(#didPop, [route, previousRoute]));
}
