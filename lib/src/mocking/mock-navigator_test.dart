import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:libcli/src/mocking/mock-navigator.dart';

void main() {
  setUp(() async {});

  test('should able test didPush', () async {
    var navi = MockNavigator(); // Interact with the mock object.
    var route = MaterialPageRoute(builder: (context) => Container());
    verifyNever(navi.didPush(any, any));
    navi.didPush(route, null);
    verify(navi.didPush(any, any));
  });

  test('should able test didPop', () async {
    var navi = MockNavigator(); // Interact with the mock object.
    var route = MaterialPageRoute(builder: (context) => Container());
    verifyNever(navi.didPop(any, any));
    navi.didPop(route, null);
    verify(navi.didPop(any, any));
  });
}
