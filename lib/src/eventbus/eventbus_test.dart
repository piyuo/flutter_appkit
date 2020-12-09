import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../mock/mock.dart';
import 'package:libcli/src/eventbus/eventbus.dart';

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

    testWidgets('should broadcst on type', (WidgetTester tester) async {
      await tester.inWidget((ctx) {
        listen<String>((BuildContext ctx, event) async {
          expect(event, 'hi');
        });
        broadcast(ctx, 'hi');
      });
    });

    testWidgets('should dispatch', (WidgetTester tester) async {
      listen<String>((BuildContext? ctx, event) async {
        expect(event, 'hi');
        expect(ctx, isNotNull);
      });
      await tester.inWidget((ctx) {
        // ignore: invalid_use_of_visible_for_testing_member
        dispatch(ctx, 'hi');
      });
    });

    testWidgets('should broadcst & listen all', (WidgetTester tester) async {
      listen((BuildContext? ctx, event) async {
        expect(event, 'hi');
      });
      await tester.inWidget((ctx) {
        // ignore: invalid_use_of_visible_for_testing_member
        dispatch(ctx, 'hi');
      });
    });

    testWidgets('should isolate error', (WidgetTester tester) async {
      var text;
      listen<String>((_, event) async {
        throw 'unhandle exception';
      });
      listen<String>((_, event) async {
        text = event;
      });

      await tester.inWidget((ctx) async {
        await broadcast(ctx, 'hi');
        expect(text, 'hi');
      });
    });

    testWidgets('should unsubscribe', (WidgetTester tester) async {
      var text = '';
      var sub = listen<String>((_, event) async {
        text = event.text;
      });

      await tester.inWidget((ctx) async {
        sub.cancel();
        await broadcast(ctx, 'hi');
        expect(text, '');
      });
    });
  });
}
