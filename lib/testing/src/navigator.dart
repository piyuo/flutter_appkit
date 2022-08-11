// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/widgets.dart';
import 'package:mockito/mockito.dart';

/// Navigator used for mock NavigatorObserver
///
class NavigatorMock extends Mock implements NavigatorObserver {
  @override
  void didPush(Route<dynamic>? route, Route<dynamic>? previousRoute) =>
      // ignore: invalid_use_of_visible_for_testing_member
      super.noSuchMethod(Invocation.method(#didPush, [route, previousRoute]));

  @override
  void didPop(Route<dynamic>? route, Route<dynamic>? previousRoute) =>
      // ignore: invalid_use_of_visible_for_testing_member
      super.noSuchMethod(Invocation.method(#didPop, [route, previousRoute]));
}
