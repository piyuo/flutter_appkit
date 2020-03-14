import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/error/error.dart' as error;
import 'package:libcli/eventbus/eventbus.dart' as eventbus;
import 'package:libcli/hook/events.dart';
import 'dart:async';

void main() {
  group('[error]', () {
    testWidgets('should catch exception', (WidgetTester tester) async {
      await error.mockInit(tester);
      var event;
      eventbus.listen<EError>((_, e) {
        event = e;
      });
      error.catchAndBroadcast(
          suspect: suspect,
          callback: () async {
            expect(event is EError, true);
          });
    });

    testWidgets('should catch async exception', (WidgetTester tester) async {
      await error.mockInit(tester);
      var event;
      eventbus.listen<EError>((_, e) {
        event = e;
      });
      error.catchAndBroadcast(
          suspect: suspectAsync,
          callback: () async {
            expect(event is EError, true);
          });
    });

    testWidgets('should catch timer exception', (WidgetTester tester) async {
      await tester.runAsync(() async {
        await error.mockInit(tester);
        var event;
        eventbus.listen<EError>((_, e) {
          event = e;
        });
        error.catchAndBroadcast(
            suspect: suspectTimer,
            callback: () async {
              expect(event is EError, true);
            });
        await Future.delayed(const Duration(milliseconds: 100));
      });
    });
  });
}

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
