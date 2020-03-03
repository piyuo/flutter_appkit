import 'package:libcli/event_bus/event_bus.dart' as eventBus;
import 'package:flutter_test/flutter_test.dart';

main() {
  group('[EventBus_Contract]', () {
    test('should contract', () async {
      var ok = false;
      var text = '';

      eventBus.listen<MockContract>((event) {
        text = event.text;
        event.complete(true);
      });

      eventBus.contract(MockContract('c')).then((value) {
        ok = value;
      });

      await eventBus.doneForTest();
      expect(text, 'c');
      expect(ok, true);
    });

    test('should handle error', () async {
      var ok = false;
      var text = '';

      eventBus.listen<MockContract>((event) {
        throw 'unhandle exception';
      });

      eventBus.contract(MockContract('c')).then((value) {
        ok = value;
      });

      await eventBus.doneForTest();
      expect(text, '');
      expect(ok, false);
    });
  });
}

class MockContract extends eventBus.Contract {
  String text;

  MockContract(this.text);
}
