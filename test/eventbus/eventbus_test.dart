import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/eventbus.dart' as eventbus;
import 'package:libcli/log.dart' as log;
import '../mock.dart';

const _here = 'eventbus_test';

main() {
  setUp(() async {
    eventbus.reset();
  });

  group('[eventbus]', () {
    testWidgets('should remove all listeners', (WidgetTester tester) async {
      await tester.inWidget((ctx) {
        eventbus.listen<String>(_here, (BuildContext ctx, event) {
          expect(event, 'hi');
        });
        expect(eventbus.getListenerCount(), 1);
        eventbus.reset();
        expect(eventbus.getListenerCount(), 0);
      });
    });

    testWidgets('should safe cancel subscription', (WidgetTester tester) async {
      await tester.inWidget((ctx) {
        var sub = eventbus.listen<String>(_here, (BuildContext ctx, event) {
          expect(event, 'hi');
        });
        expect(eventbus.getListenerCount(), 1);
        sub.cancel();
        expect(eventbus.getListenerCount(), 0);
        sub.cancel();
        expect(eventbus.getListenerCount(), 0);
      });
    });

    testWidgets('should broadcst on type', (WidgetTester tester) async {
      await tester.inWidget((ctx) {
        eventbus.listen<String>(_here, (BuildContext ctx, event) {
          expect(event, 'hi');
        });
        eventbus.broadcast(ctx, 'hi');
      });
    });

    testWidgets('should dispatch', (WidgetTester tester) async {
      eventbus.listen<String>(_here, (BuildContext ctx, event) {
        expect(event, 'hi');
        expect(ctx, isNotNull);
      });
      await tester.inWidget((ctx) {
        eventbus.dispatch(ctx, 'hi');
      });
    });

    testWidgets('should broadcst & listen all', (WidgetTester tester) async {
      eventbus.listen(_here, (BuildContext ctx, event) {
        expect(event, 'hi');
      });
      await tester.inWidget((ctx) {
        eventbus.dispatch(ctx, 'hi');
      });
    });

    testWidgets('should isolate error', (WidgetTester tester) async {
      var text;
      eventbus.listen<String>(_here, (_, event) {
        throw 'unhandle exception';
      });
      eventbus.listen<String>(_here, (_, event) {
        text = event;
      });

      await tester.inWidget((ctx) {
        eventbus.broadcast(ctx, 'hi');
        expect(text, 'hi');
      });
    });

    testWidgets('should unsubscribe', (WidgetTester tester) async {
      var text = '';
      var sub = eventbus.listen<String>(_here, (_, event) {
        text = event.text;
      });

      await tester.inWidget((ctx) {
        sub.cancel();
        eventbus.broadcast(ctx, 'hi');
        expect(text, '');
      });
    });
  });
}
