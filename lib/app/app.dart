library app;

import 'dart:async';
import 'package:libcli/contract/contract.dart' as contract;
import 'package:libcli/log/log.dart' as log;
import 'package:flutter/material.dart';

const _here = 'app';

/// master: customer production use
/// beta: customer test on
/// alpha: QA test on
/// test: for unit test
/// debug: can debug local service
enum Branch { debug, test, alpha, beta, master }

/// service deploy location,
enum Region { us, cn, tw }

/// application identity
///
///     application='piyuo-web-index'
String piyuoid = '';

/// user identity
///
///     piyuoId='user-store'
String identity = '';

/// current service branch
///
///     branch=Branch.debug
Branch branch = Branch.debug;

/// current service region
///
///     region=Region.us
Region region = Region.us;

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
