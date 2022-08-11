// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'navigator.dart';

void main() {
  group('[testing.navigator]', () {
    test('should able test didPush', () async {
      var n = NavigatorMock(); // Interact with the mock object.
      var route = MaterialPageRoute(builder: (context) => Container());
      verifyNever(n.didPush(any, any));
      n.didPush(route, null);
      verify(n.didPush(any, any));
    });

    test('should able test didPop', () async {
      var n = NavigatorMock(); // Interact with the mock object.
      var route = MaterialPageRoute(builder: (context) => Container());
      verifyNever(n.didPop(any, any));
      n.didPop(route, null);
      verify(n.didPop(any, any));
    });
  });
}
