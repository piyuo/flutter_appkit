import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/error/error.dart' as error;
import 'package:libcli/event_bus/event_bus.dart' as eventBus;
import 'package:libcli/events/events.dart';
import 'dart:async';

void main() {
  group('[error]', () {
    test('should catch exception', () async {
      var event;
      eventBus.listen<EError>((e) {
        event = e;
      });
      error.catchAndBroadcast(
          suspect: suspect,
          callback: () async {
            await eventBus.doneForTest();
            expect(event is EError, true);
          });
    });

    test('should catch async exception', () async {
      var event;
      eventBus.listen<EError>((e) {
        event = e;
      });
      error.catchAndBroadcast(
          suspect: suspectAsync,
          callback: () async {
            await eventBus.doneForTest();
            expect(event is EError, true);
          });
    });

    test('should catch timer exception', () async {
      var event;
      eventBus.listen<EError>((e) {
        event = e;
      });
      error.catchAndBroadcast(
          suspect: suspectTimer,
          callback: () async {
            await eventBus.doneForTest();
            expect(event is EError, true);
          });
      await Future.delayed(const Duration(milliseconds: 100));
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
