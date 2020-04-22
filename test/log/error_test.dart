import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/log.dart';
import 'package:libcli/eventbus.dart' as eventbus;
import 'dart:async';

const _here = 'error_test';
/*
void main() {
  group('[error]', () {
    testWidgets('should catch exception', (WidgetTester tester) async {
      var event;
      eventbus.listen<ErrorEvent>(_here, (_, e) {
        event = e;
      });
      catchAndBroadcast(suspect, callback: () async {
        expect(event is ErrorEvent, true);
      });
    });

    testWidgets('should catch async exception', (WidgetTester tester) async {
      var event;
      eventbus.listen<ErrorEvent>(_here, (_, e) {
        event = e;
      });
      catchAndBroadcast(suspectAsync, callback: () async {
        expect(event is ErrorEvent, true);
      });
    });

    testWidgets('should catch timer exception', (WidgetTester tester) async {
      await tester.runAsync(() async {
        var event;
        eventbus.listen<ErrorEvent>(_here, (_, e) {
          event = e;
        });
        catchAndBroadcast(suspectTimer, callback: () async {
          expect(event is ErrorEvent, true);
        });
        await Future.delayed(const Duration(milliseconds: 100));
      });
    });
  });
}
*/
suspect() {
  throw Exception('unhandle error');
}

suspectAsync() {
  Completer<bool> completer = new Completer<bool>();
  completer.future.then((flag) {
    throw Exception('async error');
  });
  completer.complete(true);
}

suspectTimer() {
  Timer(Duration(milliseconds: 1), () {
    throw Exception('timer error');
  });
}
