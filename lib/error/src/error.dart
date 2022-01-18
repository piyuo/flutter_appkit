import 'dart:async';
import 'package:flutter/material.dart';
import 'package:libcli/dialog/dialog.dart' as dialog;
import 'package:libcli/eventbus/eventbus.dart' as eventbus;
import 'package:libcli/command/command.dart' as command;
import 'package:libcli/log/log.dart' as log;
import 'package:libcli/i18n/i18n.dart' as i18n;
import 'error_email.dart';

eventbus.Subscription? subscribed;

var showCatchedAlert = false;

/// watch global exception
///
///      errorHandler.watch(suspect);
///
void watch(Function suspect) {
  final originalOnError = FlutterError.onError;
  FlutterError.onError = (FlutterErrorDetails details) async {
    await catched(
      details.exception,
      details.stack,
    );
    originalOnError?.call(details);
  };

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
  try {
    if (e is log.DiskErrorException) {
      await dialog.alert(
        dialog.rootContext,
        dialog.rootContext.i18n.errorDiskErrorMessage,
        icon: Icons.priority_high,
      );
      return;
    }

    await dialog.alert(
      dialog.rootContext,
      dialog.rootContext.i18n.errorNotified,
      warning: true,
      footer: e.toString(),
      emailUs: true,
    );
  } catch (ex) {
    debugPrint(ex.toString()); //don't show error if something wrong in alert
  } finally {
    showCatchedAlert = false;
  }
}

String firewallBlockMessage(BuildContext context, String reason) {
  switch (reason) {
    case command.blockShort:
      return context.i18n.errorFirewallBlockShort;
    case command.blockLong:
      return context.i18n.errorFirewallBlockLong;
    case command.inFlight:
      return context.i18n.errorFirewallInFlight;
  }
  return context.i18n.errorFirewallOverflow;
}

@visibleForTesting
Future<void> listened(BuildContext context, dynamic e) async {
//  debugPrint('error-service listened ${e.runtimeType}');
  if (e is command.FirewallBlockEvent) {
    dialog.alert(
      context,
      firewallBlockMessage(context, e.reason),
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
    dialog.toastInfo(context,
        text: context.i18n.errorNetworkSlowMessage,
        widget: const Icon(
          Icons.wifi,
          size: 68,
          color: Colors.white,
        ));
  } else if (e is command.RequestTimeoutContract) {
    String errorCode = e.isServer ? '504 deadline exceeded ${e.errorID}' : '408 request timeout';
    var result = await dialog.alert(
      context,
      context.i18n.errorNetworkTimeoutMessage,
      yes: context.i18n.retryButtonText,
      cancel: context.i18n.cancelButtonText,
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
          context.i18n.errorNetworkNoServiceMessage,
          icon: Icons.cloud_off,
          footer: e.exception?.toString(),
          emailUs: true,
        ); //service not available
      } else {
        dialog.alert(
          context,
          context.i18n.errorNetworkBlockedMessage,
          footer: e.exception?.toString(),
          icon: Icons.cloud_off,
          emailUs: true,
        );
      }
      e.complete(false);
    } else {
      var result = await dialog.alert(
        context,
        context.i18n.errorNetworkNoInternetMessage,
        icon: Icons.wifi_off,
        footer: e.exception?.toString(),
        yes: context.i18n.retryButtonText,
        cancel: context.i18n.cancelButtonText,
      );
      e.complete(result == true);
    }
  } else if (e is eventbus.EmailSupportEvent) {
    final em = ErrorEmail();
    em.launchMailTo();
  }
}
