import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:libcli/dialogs.dart';
import 'package:libcli/eventbus.dart';
import 'package:libcli/command.dart';
import 'package:libcli/log.dart';
import 'package:libcli/i18n.dart';
import 'package:libcli/src/errors/error-email.dart';

var subscribed = null;

/// watch global exception
///
///      errorHandler.watch(suspect);
///
void watch(Function suspect) {
  FlutterError.onError = (FlutterErrorDetails details) => catched(
        details.exception,
        details.stack,
      );

  runZonedGuarded<Future<void>>(() async {
    suspect();
  },
      (Object e, StackTrace stack) => catched(
            e,
            stack,
          ));

  if (subscribed == null) {
    subscribed = listen(listened);
  }
}

@visibleForTesting
void catched(dynamic e, StackTrace? stack) {
  error(e, stack);
  if (e is AssertionError) {
    //don't do anything, assertion only happen in development
    return;
  } else if (e is DiskErrorException) {
    Dialogs.of(dialogsRootContext).alert(
      dialogsRootContext,
      'diskErrorDesc'.i18n_,
      title: 'diskError'.i18n_,
      icon: Icon(CupertinoIcons.floppy_disk, color: CupertinoColors.systemRed, size: 38),
    );
    return;
  }

  //try {
  Dialogs d = Dialogs.of(dialogsRootContext);
  Dialogs.of(dialogsRootContext).alert(
    dialogsRootContext,
    'notified'.i18n_,
    icon: Icon(CupertinoIcons.exclamationmark_triangle, color: CupertinoColors.systemRed, size: 38),
    title: 'errTitle'.i18n_,
    emailUs: true,
    description: e.toString(),
  );
//  } catch (_) {}
}

@visibleForTesting
Future<void> listened(BuildContext context, dynamic e) async {
  debugPrint('error-service listened ${e.runtimeType}');
  var dialog = Dialogs.of(context);
  if (e is InternalServerErrorEvent) {
    dialog.alert(
      context,
      '500 internal server error',
      title: 'error'.i18n_,
      icon: Icon(CupertinoIcons.exclamationmark_triangle, color: CupertinoColors.systemRed, size: 38),
      emailUs: true,
    );
  }
  if (e is ServerNotReadyEvent) {
    dialog.alert(
      context,
      '501 server not ready',
      title: 'error'.i18n_,
      icon: Icon(CupertinoIcons.exclamationmark_triangle, color: CupertinoColors.systemRed, size: 38),
      emailUs: true,
    );
  }
  if (e is BadRequestEvent) {
    dialog.alert(
      context,
      '400 bad request',
      title: 'error'.i18n_,
      icon: Icon(CupertinoIcons.exclamationmark_triangle, color: CupertinoColors.systemRed, size: 38),
      emailUs: true,
    );
  }
  if (e is SlowNetworkEvent) {
    dialog.toast(context, 'slow'.i18n_,
        icon: Icon(
          CupertinoIcons.wifi,
          size: 36,
          color: CupertinoColors.white,
        ));
  }
  if (e is RequestTimeoutContract) {
    String errorCode = e.isServer ? '504 deadline exceeded ${e.errorID}' : '408 request timeout';
    var result = await dialog.confirm(
      context,
      'timeoutDesc'.i18n_,
      title: 'timeout'.i18n_,
      labelOK: 'retry'.i18n_,
      icon: Icon(CupertinoIcons.timer, color: CupertinoColors.systemRed, size: 38),
      description: errorCode,
      emailUs: true,
    );
    e.complete(result);
  }
  if (e is InternetRequiredContract) {
    if (await e.isInternetConnected()) {
      if (await e.isGoogleCloudFunctionAvailable()) {
        dialog.alert(
          context,
          'noServiceDesc'.i18n_,
          icon: Icon(CupertinoIcons.lightbulb_slash, color: CupertinoColors.systemRed, size: 38),
          title: 'noService'.i18n_,
          description: e.exception?.toString(),
          emailUs: true,
        ); //service not available
      } else {
        dialog.alert(
          context,
          'blockedDesc'.i18n_,
          title: 'blocked'.i18n_,
          description: e.exception?.toString(),
          icon: Icon(CupertinoIcons.exclamationmark_shield, color: CupertinoColors.systemRed, size: 38),
          emailUs: true,
        );
      }
      e.complete(false);
    } else {
      var result = await dialog.confirm(
        context,
        'noInternetDesc'.i18n_,
        title: 'noInternet'.i18n_,
        icon: Icon(CupertinoIcons.wifi_slash, color: CupertinoColors.systemRed, size: 38),
        description: e.exception?.toString(),
        labelOK: 'retry'.i18n_,
      );
      e.complete(result);
    }
  }
  if (e is EmailSupportEvent) {
    ErrorEmail()..launchMailTo();
  }
}
