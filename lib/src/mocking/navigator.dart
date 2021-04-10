import 'package:flutter/widgets.dart';
import 'package:mockito/mockito.dart';

/// Navigator used for mock NavigatorObserver
///
class NavigatorMock extends Mock implements NavigatorObserver {
  @override
  void didPush(Route<dynamic>? route, Route<dynamic>? previousRoute) =>
      super.noSuchMethod(Invocation.method(#didPush, [route, previousRoute]));

  @override
  void didPop(Route<dynamic>? route, Route<dynamic>? previousRoute) =>
      super.noSuchMethod(Invocation.method(#didPop, [route, previousRoute]));
}
