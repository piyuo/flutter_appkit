import 'dart:async';
import 'package:flutter/material.dart';
import 'package:libcli/dialogs.dart';
import 'package:libcli/src/eventbus/eventbus.dart' as eventbus;
import 'package:libcli/src/command/command.dart' as command;
import 'package:libcli/src/log/log.dart' as log;
import 'package:libcli/src/i18n/i18n.dart' as i18n;
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
    subscribed = eventbus.listen(listened);
  }
}

@visibleForTesting
void catched(dynamic e, StackTrace? stack) {
  log.error(e, stack);
  if (e is AssertionError) {
    //don't do anything, assertion only happen in development
    return;
  } else if (e is log.DiskErrorException) {
    alert(
      dialogsRootContext,
      'diskErrorDesc'.i18n_,
      title: 'diskError'.i18n_,
      icon: Icons.sync_problem_rounded,
    );
    return;
  }

  //try {
  alert(
    dialogsRootContext,
    'notified'.i18n_,
    warning: true,
    title: 'errTitle'.i18n_,
    footer: e.toString(),
    emailUs: true,
  );
//  } catch (_) {}
}

@visibleForTesting
Future<void> listened(BuildContext context, dynamic e) async {
  debugPrint('error-service listened ${e.runtimeType}');
  if (e is command.GuardDeniedEvent) {
    alert(
      context,
      'guard'.i18n_,
      warning: true,
      emailUs: true,
    );
  }
  if (e is command.InternalServerErrorEvent) {
    alert(
      context,
      '500 internal server error',
      warning: true,
      emailUs: true,
    );
  }
  if (e is command.ServerNotReadyEvent) {
    alert(
      context,
      '501 server not ready',
      warning: true,
      emailUs: true,
    );
  }
  if (e is command.BadRequestEvent) {
    alert(
      context,
      '400 bad request',
      warning: true,
      emailUs: true,
    );
  }
  if (e is command.SlowNetworkEvent) {
    toast(context, 'slow'.i18n_,
        icon: Icon(
          Icons.wifi,
          size: 36,
          color: Colors.white,
        ));
  }
  if (e is command.RequestTimeoutContract) {
    String errorCode = e.isServer ? '504 deadline exceeded ${e.errorID}' : '408 request timeout';
    var result = await alert(
      context,
      'timeoutDesc'.i18n_,
      title: 'timeout'.i18n_,
      yes: 'retry'.i18n_,
      cancel: 'cancel'.i18n_,
      icon: Icons.timer,
      footer: errorCode,
      emailUs: true,
    );
    e.complete(result == true);
  }
  if (e is command.InternetRequiredContract) {
    if (await e.isInternetConnected()) {
      if (await e.isGoogleCloudFunctionAvailable()) {
        alert(
          context,
          'noServiceDesc'.i18n_,
          icon: Icons.cloud_off,
          title: 'noService'.i18n_,
          footer: e.exception?.toString(),
          emailUs: true,
        ); //service not available
      } else {
        alert(
          context,
          'blockedDesc'.i18n_,
          title: 'blocked'.i18n_,
          footer: e.exception?.toString(),
          icon: Icons.block_outlined,
          emailUs: true,
        );
      }
      e.complete(false);
    } else {
      var result = await alert(
        context,
        'noInternetDesc'.i18n_,
        title: 'noInternet'.i18n_,
        icon: Icons.wifi_off_outlined,
        footer: e.exception?.toString(),
        yes: 'retry'.i18n_,
        cancel: 'cancel'.i18n_,
      );
      e.complete(result == true);
    }
  }
  if (e is eventbus.EmailSupportEvent) {
    ErrorEmail()..launchMailTo();
  }
}
