import 'dart:async';
import 'package:flutter/material.dart';
import 'package:libcli/dialog.dart' as dialog;
import 'package:libcli/eventbus.dart' as eventbus;
import 'package:libcli/command.dart' as command;
import 'package:libcli/log.dart' as log;
import 'package:libcli/pattern.dart' as pattern;
import 'package:libcli/utils.dart' as utils;
import 'package:libcli/i18n.dart';
import 'package:libcli/src/client/error_email.dart';

const _here = 'error_client';

/// watchError is global exception handler
///
///      errorClient.watchError(suspect);
void watchError(Function suspect, {Function callback}) {
  log.globalExceptionHandler = catched;

  FlutterError.onError = (FlutterErrorDetails details) => logAndThrow(
        dialog.rootContext,
        details.exception,
        details.stack,
      );

  runZonedGuarded<Future<void>>(() async {
    suspect();
  },
      (Object e, StackTrace stack) => logAndThrow(
            dialog.rootContext,
            e,
            stack,
          ));

  eventbus.listen(_here, listened);
}

@visibleForTesting
void logAndThrow(BuildContext context, dynamic e, StackTrace s,
    {String errorCode}) {
  log.error(_here, e, s);
  catched(context, e, s);
}

@visibleForTesting
void catched(BuildContext context, dynamic e, StackTrace s,
    {String errorCode}) {
  if (e is AssertionError) {
    //don't do anything, assertion only happen in development
    return;
  } else if (e is log.DiskErrorException) {
    diskErrorException(context, e, s);
    return;
  }

  try {
    dialog.show(
        context,
        dialog.DialogError(
            errorCode: errorCode ?? e.toString(),
            onEmailLinkPressed: () {
              ErrorEmailBuilder()
                ..addException(null, e, log.beautyStack(s))
                ..launchMailTo();
            }));
  } catch (e, stacktrace) {
    log.error(_here, e, stacktrace);
  }
}

void diskErrorException(BuildContext context, dynamic e, StackTrace s) {
  dialog.show(context, dialog.DialogDiskError());
}

@visibleForTesting
void listened(BuildContext context, dynamic e) {
  debugPrint('$_here~alert user error(${e.runtimeType})');
  if (e is command.InternalServerErrorEvent) {
    dialog.alert(context, '500 internal server error');
  } else if (e is command.ServerNotReadyEvent) {
    dialog.alert(context, '501 server not ready');
  } else if (e is command.BadRequestEvent) {
    dialog.alert(context, '400 bad request');
  } else if (e is command.SlowNetworkEvent) {
    toastSlowNetwork(context);
  } else if (e is command.RequestTimeoutContract) {
    alertTimeout(context, e);
  } else if (e is command.InternetRequiredContract) {
    e.isInternetConnected = utils.isInternetConnected;
    e.isGoogleCloudFunctionAvailable = utils.isGoogleCloudFunctionAvailable;
    internetRequired(context, e);
  } else if (e is pattern.EmailSupportContract) {
    e.complete(true);
    ErrorEmailBuilder()
      ..addReports(e.reports)
      ..launchMailTo();
  }
}

///alertTimeout show error dialog with error code
///
void alertTimeout(
    BuildContext context, command.RequestTimeoutContract contract) {
  String errorCode =
      contract.isServer ? '504 deadline exceeded' : '408 request timeout';
  dialog.show(
      context,
      dialog.DialogTimeout(dialog.DialogTimeoutOptions(
        errorCode: errorCode,
        onPressed: (bool retry) => contract.complete(retry),
        onEmailLinkPressed: () {
          ErrorEmailBuilder()
            ..addException(null, contract.exception ?? errorCode, contract.url)
            ..launchMailTo();
        },
      )));
}

///internetRequired happen when socket exception
///
void internetRequired(
    BuildContext context, command.InternetRequiredContract contract) async {
  if (await contract.isInternetConnected()) {
    if (await contract.isGoogleCloudFunctionAvailable()) {
      dialog.error(context, 'service not available');
    } else {
      dialog.show(context, dialog.DialogBlockedInternet());
    }
    contract.complete(false);
  } else {
    dialog.show(
        context,
        dialog.DialogNoInternet(dialog.DialogNoInternetOptions(
            errorCode: contract.exception.toString(),
            onPressed: (bool retry) => contract.complete(retry))));
  }
}

void toastSlowNetwork(BuildContext context) async {
  dialog.hint(context, 'slow'.i18n_, icon: Icons.wifi);
}
