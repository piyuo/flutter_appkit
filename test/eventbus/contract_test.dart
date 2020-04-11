import 'package:libcli/eventbus.dart' as eventbus;
import 'package:flutter_test/flutter_test.dart';

main() {
  setUp(() async {
    eventbus.reset();
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

class MockContract extends eventbus.Contract {
  String text;

  MockContract(this.text);
}
