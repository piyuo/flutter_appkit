import 'dart:async';
import 'package:flutter/material.dart';
import 'package:libcli/dialogs.dart';
import 'package:libcli/eventbus.dart';
import 'package:libcli/command.dart';
import 'package:libcli/log.dart';
import 'package:libcli/src/i18n/i18n.dart';
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
  if (e is GuardDeniedEvent) {
    alert(
      context,
      'guard'.i18n_,
      warning: true,
      emailUs: true,
    );
  }
  if (e is InternalServerErrorEvent) {
    alert(
      context,
      '500 internal server error',
      warning: true,
      emailUs: true,
    );
  }
  if (e is ServerNotReadyEvent) {
    alert(
      context,
      '501 server not ready',
      warning: true,
      emailUs: true,
    );
  }
  if (e is BadRequestEvent) {
    alert(
      context,
      '400 bad request',
      warning: true,
      emailUs: true,
    );
  }
  if (e is SlowNetworkEvent) {
    toast(context, 'slow'.i18n_,
        icon: Icon(
          Icons.wifi,
          size: 36,
          color: Colors.white,
        ));
  }
  if (e is RequestTimeoutContract) {
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
  if (e is InternetRequiredContract) {
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
  if (e is EmailSupportEvent) {
    ErrorEmail()..launchMailTo();
  }
}
