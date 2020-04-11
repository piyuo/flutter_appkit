import 'dart:async';
import 'package:flutter/material.dart';
import 'package:libcli/src/log/log.dart';
import 'package:libcli/common.dart';
import 'package:libcli/eventbus.dart' as eventbus;
import 'package:flutter_test/flutter_test.dart';

const _here = 'error';

class DiskFullException implements Exception {}

/// catch unhandle exception
///
///      error.catchAndBroadcast(suspect, null);
catchAndBroadcast({Function suspect, Function callback}) {
  FlutterError.onError = (FlutterErrorDetails details) {
    var errId = error(_here, details.exception, details.stack);
    eventbus.broadcast(null, EError(errId));
    if (callback != null) {
      callback();
    }
  };

  runZonedGuarded<Future<void>>(
    () async {
      suspect();
    },
    (Object e, StackTrace stack) {
      var errId = error(_here, e, stack);
      eventbus.broadcast(null, EError(errId));
      if (callback != null) {
        callback();
      }
    },
  );
}
