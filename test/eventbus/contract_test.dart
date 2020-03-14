import 'package:libcli/eventbus/eventbus.dart' as eventbus;
import 'package:libcli/eventbus/contract.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/mock/mock.dart';

main() {
  setUp(() async {
    eventbus.removeAllListeners();
  });
  group('[eventbus_contract]', () {
    test('should handle error', () async {
      eventbus.listen<MockContract>((_, event) {
        throw 'unhandle exception';
      });
      eventbus.contract(null, MockContract('c')).then((value) {
        expect(value, false);
      });
    });
  });

  test('should contract', () async {
    var text = '';
    eventbus.listen<MockContract>((ctx, event) {
      text = event.text;
      event.complete(true);
    });
    eventbus.contract(null, MockContract('c')).then((value) {
      expect(value, true);
    });
    expect(text, 'c');
  });
}

class MockContract extends Contract {
  String text;

  MockContract(this.text);
}
