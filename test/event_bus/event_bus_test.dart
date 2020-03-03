import 'package:libcli/event_bus/event_bus.dart' as eventBus;
import 'package:flutter_test/flutter_test.dart';
import 'dart:async';

main() {
  group('[EventBus]', () {
    test('should broadcst & listen', () async {
      var text;
      eventBus.listen<MockEvent>((event) {
        text = event.text;
      });
      eventBus.brodcast(MockEvent('a'));

      await eventBus.doneForTest();
      expect(text, 'a');
    });

    test('should isolate error', () async {
      var text = '';
      eventBus.listen<MockEvent>((event) {
        throw 'unhandle exception';
      });
      eventBus.listen<MockEvent>((event) {
        text = event.text;
      });
      eventBus.brodcast(MockEvent('c'));

      await eventBus.doneForTest();
      expect(text, 'c');
    });

    test('should unsubscribe', () async {
      var text = '';
      StreamSubscription sub = eventBus.listen<MockEvent>((event) {
        text = event.text;
      });
      sub.cancel();
      eventBus.brodcast(MockEvent('a'));
      await eventBus.doneForTest();
      expect(text, '');
    });
  });
}

class MockEvent {
  String text;

  MockEvent(this.text);
}
