import 'dart:async';
import 'package:libcli/contract/contract.dart' as contract;
import 'package:libcli/log/log.dart' as log;
import 'package:flutter/material.dart';

const _here = 'catch';

/// catchError catch all unhandle exception
///
///      errors.catchAll(suspect, null);
catchError(Function main, Function error) {
  FlutterError.onError = (FlutterErrorDetails details) {
    var errId = log.error(_here, details.exception, details.stack);
    contract.brodcast(contract.EError(errId));
  };

  runZoned<Future<void>>(
    () async {
      main();
    },
    onError: (dynamic e, StackTrace s) {
      var errId = log.error(_here, e, s);
      contract.brodcast(contract.EError(errId));
      if (error != null) {
        error();
      }
    },
  );
}
