import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../mock/mock.dart';
import 'package:libcli/src/eventbus/eventbus.dart';

const _here = 'eventbus-test';

main() {
  setUp(() async {
    reset();
  });

  group('[eventbus/eventbus]', () {
    testWidgets('should remove all listeners', (WidgetTester tester) async {
      await tester.inWidget((ctx) {
        listen<String>(_here, (BuildContext ctx, event) {
          expect(event, 'hi');
        });
        // ignore: invalid_use_of_visible_for_testing_member
        expect(getListenerCount(), 1);
        reset();
        // ignore: invalid_use_of_visible_for_testing_member
        expect(getListenerCount(), 0);
      });
    });

    testWidgets('should safe cancel subscription', (WidgetTester tester) async {
      await tester.inWidget((ctx) {
        var sub = listen<String>(_here, (BuildContext ctx, event) {
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

    testWidgets('should broadcst on type', (WidgetTester tester) async {
      await tester.inWidget((ctx) {
        listen<String>(_here, (BuildContext ctx, event) {
          expect(event, 'hi');
        });
        broadcast(ctx, 'hi');
      });
    });

    testWidgets('should dispatch', (WidgetTester tester) async {
      listen<String>(_here, (BuildContext ctx, event) {
        expect(event, 'hi');
        expect(ctx, isNotNull);
      });
      await tester.inWidget((ctx) {
        // ignore: invalid_use_of_visible_for_testing_member
        dispatch(ctx, 'hi');
      });
    });

    testWidgets('should broadcst & listen all', (WidgetTester tester) async {
      listen(_here, (BuildContext ctx, event) {
        expect(event, 'hi');
      });
      await tester.inWidget((ctx) {
        // ignore: invalid_use_of_visible_for_testing_member
        dispatch(ctx, 'hi');
      });
    });

    testWidgets('should isolate error', (WidgetTester tester) async {
      var text;
      listen<String>(_here, (_, event) {
        throw 'unhandle exception';
      });
      listen<String>(_here, (_, event) {
        text = event;
      });

      await tester.inWidget((ctx) {
        broadcast(ctx, 'hi');
        expect(text, 'hi');
      });
    });

    testWidgets('should unsubscribe', (WidgetTester tester) async {
      var text = '';
      var sub = listen<String>(_here, (_, event) {
        text = event.text;
      });

      await tester.inWidget((ctx) {
        sub.cancel();
        broadcast(ctx, 'hi');
        expect(text, '');
      });
    });
  });
}
