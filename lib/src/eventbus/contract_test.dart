import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:libcli/src/eventbus/contract.dart';
import 'package:libcli/src/eventbus/eventbus.dart';
import 'package:mockito/mockito.dart';

const _here = 'eventbus-contract-test';

class MockBuildContext extends Mock implements BuildContext {}

main() {
  setUp(() async {
    clearListeners();
  });
  group('[eventbus/contract]', () {
    test('should handle error', () async {
      listen<MockContract>(_here, (_, event) {
        throw 'unhandle exception';
      });
      contract(MockBuildContext(), MockContract('c')).then((value) {
        expect(value, false);
      });
    });
  });

  test('should contract', () async {
    var text = '';
    listen<MockContract>(_here, (ctx, event) {
      text = event.text;
      event.complete(true);
    });
    contract(MockBuildContext(), MockContract('c')).then((value) {
      expect(value, true);
    });
    expect(text, 'c');
  });
}

class MockContract extends Contract {
  String text;

  MockContract(this.text);
}
