import 'dart:async';
import 'package:flutter/material.dart';
import 'package:libcli/log/log.dart';
import 'package:libcli/hook/events.dart';
import 'package:libcli/eventbus/eventbus.dart' as eventbus;
import 'package:flutter_test/flutter_test.dart';

const _here = 'catch';

/// catch unhandle exception
///
///      error.catchAndBroadcast(suspect, null);
catchAndBroadcast({Function suspect, Function callback}) {
  FlutterError.onError = (FlutterErrorDetails details) {
    var errId = _here.error(details.exception, details.stack);
    eventbus.broadcast(null, EError(errId));
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
      eventbus.broadcast(null, EError(errId));
      if (callback != null) {
        callback();
      }
    },
  );
}
