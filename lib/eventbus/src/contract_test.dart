// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:flutter_test/flutter_test.dart';
import 'types.dart';
import 'eventbus.dart';

main() {
  setUp(() async {
    clearListeners();
  });
  group('[eventbus/contract]', () {
    test('should handle error', () async {
      listen<MockContract>((event) {
        throw 'fail';
      });
      var value = await broadcast(MockContract('c'));
      expect(value, false);
    });
  });

  test('should contract', () async {
    var text = '';
    listen<MockContract>((event) async {
      text = event.text;
      event.complete(true);
    });
    var value = await broadcast(MockContract('c'));
    expect(value, true);
    expect(text, 'c');
  });

  test('should have no error if no listener', () async {
    dynamic ex;
    try {
      await broadcast(MockContract('c'));
    } catch (e) {
      ex = e;
    }
    expect(ex, null);
  });
}

class MockContract extends Contract {
  String text;

  MockContract(this.text);
}
