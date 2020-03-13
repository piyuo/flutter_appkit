import 'package:flutter/material.dart';
import 'package:libcli/eventbus/eventbus.dart' as eventbus;
import 'package:flutter_test/flutter_test.dart';

main() {
  group('[eventbus]', () {
    testWidgets('should broadcst & listen', (WidgetTester tester) async {
/*
  await tester.pumpWidget(
    Builder(
      builder: (BuildContext context) {
        var actual = sut.myMethodName(context, ...);
        expect(actual, something);

        // The builder function must return a widget.
        return Placeholder();
      },
    ),
  );*/
    });

    test('should broadcst & listen on type', () async {
      eventbus.listen<String>((BuildContext ctx, event) {
        expect(event, 'hi');
      });
      eventbus.broadcast(null, 'hi');
    });

    test('should dispatch', () async {
      eventbus.listen<String>((BuildContext ctx, event) {
        expect(event, 'hi');
      });
      eventbus.dispatch(null, 'hi');
    });

    test('should broadcst & listen all', () async {
      eventbus.listen((BuildContext ctx, event) {
        expect(event, 'hi');
      });
      eventbus.broadcast(null, 'hi');
    });

    test('should isolate error', () async {
      var text;
      eventbus.listen<String>((_, event) {
        throw 'unhandle exception';
      });
      eventbus.listen<String>((_, event) {
        text = event;
      });
      eventbus.broadcast(null, 'hi');
      expect(text, 'hi');
    });

    test('should unsubscribe', () async {
      var text = '';
      var sub = eventbus.listen<String>((_, event) {
        text = event.text;
      });
      sub.cancel();
      eventbus.broadcast(null, 'hi');
      expect(text, '');
    });
  });
}
