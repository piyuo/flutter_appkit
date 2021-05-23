import 'dart:async';
import 'package:flutter/material.dart';
import 'package:libcli/dialog.dart' as dialog;
import 'package:libcli/eventbus.dart' as eventbus;
import 'package:libcli/command.dart' as command;
import 'package:libcli/log.dart' as log;
import 'package:libcli/i18n.dart' as i18n;
import 'package:libcli/src/error/error-email.dart';

var subscribed = null;

var showCatchedAlert = false;

dynamic showEventAlert = null;

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

  if (subscribed == null) {
    subscribed = eventbus.listen(listened);
  }
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
      dialog.RootContext,
      'diskErrorDesc'.i18n_,
      title: 'diskError'.i18n_,
      icon: Icons.sync_problem_rounded,
    );
    showCatchedAlert = false;
    return;
  }

  await dialog.alert(
    dialog.RootContext,
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
  debugPrint('error-service listened ${e.runtimeType}');
  if (e is command.FirewallBlockEvent) {
    dialog.alert(
      context,
      'firewallBlock'.i18n_,
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
        widget: Icon(
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
      icon: Icons.timer,
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
          icon: Icons.block_outlined,
          emailUs: true,
        );
      }
      e.complete(false);
    } else {
      var result = await dialog.alert(
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
  } else if (e is eventbus.EmailSupportEvent) {
    ErrorEmail()..launchMailTo();
  }
}
