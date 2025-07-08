import 'dart:async';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:libcli/log/log.dart' as log;

import 'global_context_support.dart';
import 'show_error.dart';

var showCatchedAlert = false;

/// watch global exception
/// ```dart
/// errorHandler.watch(suspect);
/// ```
void run(Function suspect, {bool Function(dynamic)? alertUser}) {
  final originalOnError = FlutterError.onError;
  FlutterError.onError = (FlutterErrorDetails details) async {
    await catched(
      details.exception,
      details.stack,
      alertUser,
    );
    originalOnError?.call(details);
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    catched(error, stack, alertUser);
    return true;
  };

  runZonedGuarded<Future<void>>(
    () async => runApp(GlobalContextSupport(child: suspect())),
    (Object e, StackTrace stack) async => await catched(
      e,
      stack,
      alertUser,
    ),
  );
}

@visibleForTesting
Future<void> catched(dynamic e, StackTrace? stack, bool Function(dynamic)? alertUser) async {
  log.error(e, stack);
  if (e is AssertionError) {
    //don't do anything, assertion only happen in development
    return;
  }

  if (alertUser != null && !alertUser(e)) {
    //don't show alert
    return;
  }

  if (showCatchedAlert) {
    // error already show
    return;
  }
  showCatchedAlert = true;
  try {
    showError(e, stack);
  } catch (ex) {
    debugPrint(ex.toString()); //don't show error if something wrong in alert
  } finally {
    showCatchedAlert = false;
  }
}
