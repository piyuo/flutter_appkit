import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:libcli/log.dart' as log;
import 'package:libcli/eventbus.dart' as eventbus;
import 'package:libcli/src/log/error_event.dart';

const _here = 'error';

/// catch unhandle exception
///
///      error.catchAndBroadcast(suspect, null);
catchAndBroadcast({Function suspect, Function callback}) {
  FlutterError.onError = (FlutterErrorDetails details) =>
      dispatchException(details.exception, details.stack, callback: callback);

  runZonedGuarded<Future<void>>(() async {
    suspect();
  },
      (Object e, StackTrace stack) =>
          dispatchException(e, stack, callback: callback));
}

dispatchException(dynamic e, StackTrace stack, {Function callback}) async {
  var event;

  if (e is DiskErrorException) {
    event = DiskErrorEvent();
  } else {
    event = ErrorEvent(
      exception: e,
      stackTrace: stack,
      errorCode: log.ERROR_UNHANDLE_EXCEPTION,
    );
    log.error(_here, e, stack);
  }

  eventbus.broadcast(null, event);
  if (callback != null) {
    callback(event);
  }
}
