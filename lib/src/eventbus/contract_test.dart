import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:libcli/src/eventbus/contract.dart';
import 'package:libcli/src/eventbus/eventbus.dart';
import 'package:mockito/mockito.dart';

class MockBuildContext extends Mock implements BuildContext {}

main() {
  setUp(() async {
    clearListeners();
  });
  group('[eventbus/contract]', () {
    test('should handle error', () async {
      listen<MockContract>((_, event) {
        throw 'unhandle exception';
      });
      var value = await contract(MockBuildContext(), MockContract('c'));
      expect(value, false);
    });
  });

  test('should contract', () async {
    var text = '';
    listen<MockContract>((ctx, event) async {
      text = event.text;
      event.complete(true);
    });
    var value = await contract(MockBuildContext(), MockContract('c'));
    expect(value, true);
    expect(text, 'c');
  });

  test('should have AssertionError if no listener', () async {
    expect(() async => await contract(MockBuildContext(), MockContract('c')), throwsA(AssertionError));
  });
}

class MockContract extends Contract {
  String text;

  MockContract(this.text);
}
