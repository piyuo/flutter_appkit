// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/testing/testing.dart' as testing;
import 'eventbus.dart';
import 'types.dart';

class MyEvent extends Event {
  String value = '';
}

class MyEvent2 extends Event {
  String value = '';
}

main() {
  setUp(() async {
    clearListeners();
  });

  group('[eventbus]', () {
    test('should remove all listeners', () async {
      listen<String>((event) async {
        expect(event, 'hi');
      });
      expect(getListenerCount(), 1);
      clearListeners();
      expect(getListenerCount(), 0);
    });

    test('should safe cancel subscription', () async {
      var sub = listen<String>((event) async {
        expect(event, 'hi');
      });
      expect(getListenerCount(), 1);
      sub.cancel();
      expect(getListenerCount(), 0);
      sub.cancel();
      expect(getListenerCount(), 0);
    });

    test('should broadcast', () async {
      String listened = '';
      listen<MyEvent>((event) async {
        expect(event is MyEvent, true);
        var my = event as MyEvent;
        listened = my.value;
      });
      await broadcast(MyEvent()..value = 'hi');
      expect(listened, 'hi');
    });

    test('should listen on type', () async {
      dynamic eventType;
      listen<MyEvent>((event) async {
        eventType = event.runtimeType;
      });
      await broadcast(MyEvent());
      expect(eventType, MyEvent);
    });

    test('should not listened', () async {
      dynamic eventType;
      listen<MyEvent>((event) async {
        eventType = event.runtimeType;
      });
      await broadcast(MyEvent2());
      expect(eventType, null);
    });

    test('should listen all', () async {
      dynamic eventType;
      listen((event) async {
        eventType = event.runtimeType;
      });
      await broadcast(MyEvent());
      expect(eventType, MyEvent);
      await broadcast(MyEvent2());
      expect(eventType, MyEvent2);
    });

    test('should isolate error', () async {
      dynamic eventType;
      listen<MyEvent>((event) async {
        throw 'fail';
      });
      listen<MyEvent>((event) async {
        eventType = event.runtimeType;
      });
      await broadcast(MyEvent());
      expect(eventType, MyEvent);
    });

    test('should unsubscribe', () async {
      dynamic eventType;
      var sub = listen<MyEvent>((event) async {
        eventType = event.runtimeType;
      });
      sub.cancel();
      await broadcast(MyEvent());
      expect(eventType, null);
    });
  });
}
