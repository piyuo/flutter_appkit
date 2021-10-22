import 'dart:async';
import 'package:flutter/material.dart';
import 'package:libcli/dialog/dialog.dart' as dialog;
import 'package:libcli/eventbus/eventbus.dart' as eventbus;
import 'package:libcli/command/command.dart' as command;
import 'package:libcli/log.dart' as log;
import 'package:libcli/i18n/i18n.dart' as i18n;
import 'error_email.dart';

eventbus.Subscription? subscribed;

var showCatchedAlert = false;

/// watch global exception
///
///      errorHandler.watch(suspect);
///
void watch(Function suspect) {
  FlutterError.onError = (FlutterErrorDetails details) async => await catched(
        details.exception,
        details.stack,
      );

  runZonedGuarded<Future<void>>(() async {
    suspect();
  },
      (Object e, StackTrace stack) async => await catched(
            e,
            stack,
          ));

  subscribed ??= eventbus.listen(listened);
}

@visibleForTesting
Future<void> catched(dynamic e, StackTrace? stack) async {
  log.error(e, stack);
  if (e is AssertionError) {
    //don't do anything, assertion only happen in development
    return;
  }

  if (showCatchedAlert) {
    // error already show
    return;
  }
  showCatchedAlert = true;

  if (e is log.DiskErrorException) {
    await dialog.alert(
      dialog.rootContext,
      'diskErrorDesc'.i18n_,
      title: 'diskError'.i18n_,
      icon: Icons.priority_high,
    );
    showCatchedAlert = false;
    return;
  }

  await dialog.alert(
    dialog.rootContext,
    'notified'.i18n_,
    warning: true,
    title: 'errTitle'.i18n_,
    footer: e.toString(),
    emailUs: true,
  );
  showCatchedAlert = false;
}

@visibleForTesting
Future<void> listened(BuildContext context, dynamic e) async {
//  debugPrint('error-service listened ${e.runtimeType}');
  if (e is command.FirewallBlockEvent) {
    dialog.alert(
      context,
      e.reason.i18n_, // reason need predefine in i18n
      warning: true,
      emailUs: true,
    );
  } else if (e is command.InternalServerErrorEvent) {
    dialog.alert(
      context,
      '500 internal server error',
      warning: true,
      emailUs: true,
    );
  } else if (e is command.ServerNotReadyEvent) {
    dialog.alert(
      context,
      '501 server not ready',
      warning: true,
      emailUs: true,
    );
  } else if (e is command.BadRequestEvent) {
    dialog.alert(
      context,
      '400 bad request',
      warning: true,
      emailUs: true,
    );
  } else if (e is command.SlowNetworkEvent) {
    dialog.info(context,
        text: 'slow'.i18n_,
        widget: const Icon(
          Icons.wifi,
          size: 68,
          color: Colors.white,
        ));
  } else if (e is command.RequestTimeoutContract) {
    String errorCode = e.isServer ? '504 deadline exceeded ${e.errorID}' : '408 request timeout';
    var result = await dialog.alert(
      context,
      'timeoutDesc'.i18n_,
      title: 'timeout'.i18n_,
      yes: 'retry'.i18n_,
      cancel: 'cancel'.i18n_,
      icon: Icons.alarm,
      footer: errorCode,
      emailUs: true,
    );
    e.complete(result == true);
  } else if (e is command.InternetRequiredContract) {
    if (await e.isInternetConnected()) {
      if (await e.isGoogleCloudFunctionAvailable()) {
        dialog.alert(
          context,
          'noServiceDesc'.i18n_,
          icon: Icons.cloud_off,
          title: 'noService'.i18n_,
          footer: e.exception?.toString(),
          emailUs: true,
        ); //service not available
      } else {
        dialog.alert(
          context,
          'blockedDesc'.i18n_,
          title: 'blocked'.i18n_,
          footer: e.exception?.toString(),
          icon: Icons.cloud_off,
          emailUs: true,
        );
      }
      e.complete(false);
    } else {
      var result = await dialog.alert(
        context,
        'noInternetDesc'.i18n_,
        title: 'noInternet'.i18n_,
        icon: Icons.wifi_off,
        footer: e.exception?.toString(),
        yes: 'retry'.i18n_,
        cancel: 'cancel'.i18n_,
      );
      e.complete(result == true);
    }
  } else if (e is eventbus.EmailSupportEvent) {
    final em = ErrorEmail();
    em.launchMailTo();
  }
}
