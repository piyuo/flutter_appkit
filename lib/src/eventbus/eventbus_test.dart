import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../mock/mock.dart';
import 'package:libcli/src/eventbus/eventbus.dart';
import 'package:libcli/src/eventbus/types.dart';
import 'package:mockito/mockito.dart';

class MockBuildContext extends Mock implements BuildContext {}

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

  group('[eventbus/eventbus]', () {
    testWidgets('should remove all listeners', (WidgetTester tester) async {
      await tester.inWidget((ctx) {
        listen<String>((BuildContext ctx, event) async {
          expect(event, 'hi');
        });
        // ignore: invalid_use_of_visible_for_testing_member
        expect(getListenerCount(), 1);
        clearListeners();
        // ignore: invalid_use_of_visible_for_testing_member
        expect(getListenerCount(), 0);
      });
    });

    testWidgets('should safe cancel subscription', (WidgetTester tester) async {
      await tester.inWidget((ctx) {
        var sub = listen<String>((BuildContext ctx, event) async {
          expect(event, 'hi');
        });
        // ignore: invalid_use_of_visible_for_testing_member
        expect(getListenerCount(), 1);
        sub.cancel();
        // ignore: invalid_use_of_visible_for_testing_member
        expect(getListenerCount(), 0);
        sub.cancel();
        // ignore: invalid_use_of_visible_for_testing_member
        expect(getListenerCount(), 0);
      });
    });

    test('should broadcast', () async {
      String listened = '';
      listen<MyEvent>((BuildContext ctx, event) async {
        expect(event is MyEvent, true);
        var my = event as MyEvent;
        listened = my.value;
      });
      await broadcast(MockBuildContext(), MyEvent()..value = 'hi');
      expect(listened, 'hi');
    });

    test('should listen on type', () async {
      var eventType = null;
      listen<MyEvent>((BuildContext ctx, event) async {
        eventType = event.runtimeType;
      });
      await broadcast(MockBuildContext(), MyEvent());
      expect(eventType, MyEvent);
    });

    test('should not listened', () async {
      var eventType = null;
      listen<MyEvent>((BuildContext ctx, event) async {
        eventType = event.runtimeType;
      });
      await broadcast(MockBuildContext(), MyEvent2());
      expect(eventType, null);
    });

    test('should listen all', () async {
      var eventType = null;
      listen((BuildContext ctx, event) async {
        eventType = event.runtimeType;
      });
      await broadcast(MockBuildContext(), MyEvent());
      expect(eventType, MyEvent);
      await broadcast(MockBuildContext(), MyEvent2());
      expect(eventType, MyEvent2);
    });

    testWidgets('should isolate error', (WidgetTester tester) async {
      var eventType;
      listen<MyEvent>((_, event) async {
        throw 'unhandle exception';
      });
      listen<MyEvent>((_, event) async {
        eventType = event.runtimeType;
      });

      await tester.inWidget((ctx) async {
        await broadcast(ctx, MyEvent());
        expect(eventType, MyEvent);
      });
    });

    testWidgets('should unsubscribe', (WidgetTester tester) async {
      var eventType;
      var sub = listen<MyEvent>((_, event) async {
        eventType = event.runtimeType;
      });

      await tester.inWidget((ctx) async {
        sub.cancel();
        await broadcast(ctx, MyEvent());
        expect(eventType, null);
      });
    });
  });
}
