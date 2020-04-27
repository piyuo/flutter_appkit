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

  FlutterError.onError = (FlutterErrorDetails details) => catched(
        dialog.rootContext,
        details.exception,
        details.stack,
      );

  runZonedGuarded<Future<void>>(() async {
    suspect();
  },
      (Object e, StackTrace stack) => catched(
            dialog.rootContext,
            e,
            stack,
          ));

  eventbus.listen(_here, listened);
}

@visibleForTesting
void catched(BuildContext context, dynamic e, StackTrace s,
    {String errorCode}) {
  if (e is log.DiskErrorException) {
    diskErrorException(context, e, s);
    return;
  }

  dialog.show(
      context,
      dialog.DialogError(
          errorCode: errorCode ?? e.toString(),
          onEmailLinkPressed: () {
            ErrorEmailBuilder()
              ..addException(null, e, log.beautyStack(s))
              ..launchMailTo();
          }));
}

void diskErrorException(BuildContext context, dynamic e, StackTrace s) {
  dialog.show(context, dialog.DialogDiskError());
}

@visibleForTesting
void listened(BuildContext context, dynamic e) {
  if (e is command.InternalServerErrorEvent) {
    alertError(context, '500 Internal Server Error');
  } else if (e is command.ServerNotReadyEvent) {
    alertError(context, '501 Server Not Ready');
  } else if (e is command.BadRequestEvent) {
    alertError(context, '400 Bad Request');
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
      contract.isServer ? '504 Deadline Exceeded' : '408 Request Timeout';
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

///alertError show error dialog with error code
///
void alertError(BuildContext context, String errorCode) {
  dialog.show(
      context,
      dialog.DialogError(
        errorCode: errorCode,
      ));
}

///internetRequired happen when socket exception
///
void internetRequired(
    BuildContext context, command.InternetRequiredContract contract) async {
  if (await contract.isInternetConnected()) {
    if (await contract.isGoogleCloudFunctionAvailable()) {
      alertError(context, 'Service Not Available');
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
