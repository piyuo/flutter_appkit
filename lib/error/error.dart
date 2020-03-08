import 'dart:async';
import 'package:libcli/event_bus/event_bus.dart' as eventBus;
import 'package:libcli/constant/events.dart';
import 'package:libcli/log/log.dart';
import 'package:flutter/material.dart';

const _here = 'error';

/// catch unhandle exception
///
///      error.catchAndBroadcast(suspect, null);
catchAndBroadcast({Function suspect, Function callback}) {
  FlutterError.onError = (FlutterErrorDetails details) {
    var errId = _here.error(details.exception, details.stack);
    eventBus.brodcast(EError(errId));
    if (callback != null) {
      callback();
    }
  };

  runZoned<Future<void>>(
    () async {
      suspect();
    },
    onError: (dynamic e, StackTrace s) {
      var errId = _here.error(e, s);
      eventBus.brodcast(EError(errId));
      if (callback != null) {
        callback();
      }
    },
  );
}
