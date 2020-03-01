import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/app/app.dart' as app;
import 'package:libcli/contract/contract.dart' as contract;
import '../contract/mock_listener.dart';
import 'dart:async';

void main() {
  MockListener listener = MockListener(true);
  contract.removeAllListener();
  contract.addListener(listener);
  group('errors', () {
    test('should catch exception', () {
      listener.clear();
      app.catchError(suspect, () {
        expect(listener.latestEvent.runtimeType, contract.EError);
      });
    });

    test('should catch async exception', () {
      listener.clear();
      app.catchError(suspectAsync, () {
        expect(listener.latestEvent.runtimeType, contract.EError);
      });
    });

    test('should catch timer exception', () async {
      listener.clear();
      app.catchError(suspectTimer, () {
        expect(listener.latestEvent.runtimeType, contract.EError);
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
