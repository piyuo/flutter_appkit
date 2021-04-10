import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/src/eventbus/types.dart';
import 'package:libcli/src/eventbus/main.dart';
import 'package:libcli/src/mocking/mocking.dart' as mocking;

main() {
  setUp(() async {
    clearListeners();
  });
  group('[eventbus/contract]', () {
    test('should handle error', () async {
      listen<MockContract>((_, event) {
        throw 'fail';
      });
      var value = await broadcast(mocking.Context(), MockContract('c'));
      expect(value, false);
    });
  });

  test('should contract', () async {
    var text = '';
    listen<MockContract>((ctx, event) async {
      text = event.text;
      event.complete(true);
    });
    var value = await broadcast(mocking.Context(), MockContract('c'));
    expect(value, true);
    expect(text, 'c');
  });

  test('should have no error if no listener', () async {
    var ex = null;
    try {
      await broadcast(mocking.Context(), MockContract('c'));
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
