import 'dart:async';
import 'package:flutter/material.dart';
import 'package:libcli/dialog/dialog.dart' as dialog;
import 'package:libcli/delta/delta.dart' as delta;
import 'package:libcli/eventbus/eventbus.dart' as eventbus;
import 'package:libcli/command/command.dart' as command;
import 'package:libcli/log/log.dart' as log;
import 'package:libcli/i18n/i18n.dart' as i18n;
import 'package:libcli/preferences/preferences.dart' as preferences;
import 'error_email.dart';

///EmailSupportEvent happen when user click 'Email Us' link
class EmailSupportEvent {
  EmailSupportEvent();
}

eventbus.Subscription? subscribed;

var showCatchedAlert = false;

/// watch global exception
/// ```dart
/// errorHandler.watch(suspect);
/// ```
void watch(Function suspect) {
  final originalOnError = FlutterError.onError;
  FlutterError.onError = (FlutterErrorDetails details) async {
    await catched(
      details.exception,
      details.stack,
    );
    originalOnError?.call(details);
  };

  runZonedGuarded<Future<void>>(
    () async => suspect(),
    (Object e, StackTrace stack) async => await catched(
      e,
      stack,
    ),
  );

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
    if (e is preferences.DiskErrorException) {
      await dialog.show(
        textContent: delta.i18n.errorDiskErrorMessage,
        isError: true,
        title: e.toString(),
        footer: emailUs(),
      );
      return;
    }

    await dialog.show(
      textContent: delta.i18n.errorNotified,
      isError: true,
      title: e.toString(),
      footer: emailUs(),
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

Widget emailUs() {
  return Padding(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
      child: TextButton(
        child: Text(delta.i18n.errorEmailUsLink),
        onPressed: () => eventbus.broadcast(EmailSupportEvent()),
      ));
}

@visibleForTesting
Future<void> listened(dynamic e) async {
  debugPrint('[app] listened ${e.runtimeType}');

  if (e is command.FirewallBlockEvent) {
    dialog.show(
      textContent: firewallBlockMessage(delta.globalContext, e.reason),
      isError: true,
      footer: emailUs(),
    );
    return;
  }
  if (e is command.InternalServerErrorEvent) {
    dialog.show(
      textContent: '500 internal server error',
      isError: true,
      footer: emailUs(),
    );
    return;
  }

  if (e is command.ServerNotReadyEvent) {
    dialog.show(
      textContent: '501 server not ready',
      isError: true,
      footer: emailUs(),
    );
    return;
  }

  if (e is command.BadRequestEvent) {
    dialog.show(
      textContent: '400 bad request',
      isError: true,
      footer: emailUs(),
    );
    return;
  }

  if (e is command.SlowNetworkEvent) {
    dialog.toastInfo(
      delta.i18n.errorNetworkSlowMessage,
      widget: const Icon(
        Icons.wifi,
        size: 68,
        color: Colors.white,
      ),
    );
    return;
  }

  if (e is command.RequestTimeoutEvent) {
    String errorCode = e.isServer ? '504 deadline exceeded ${e.errorID}' : '408 request timeout';
    await dialog.show(
      textContent: delta.i18n.errorNetworkTimeoutMessage,
      icon: const Icon(Icons.alarm, size: 64),
      title: errorCode,
      footer: emailUs(),
    );
    return;
  }

  if (e is command.InternetRequiredEvent) {
    if (await e.isInternetConnected()) {
      if (await e.isGoogleCloudFunctionAvailable()) {
        dialog.show(
          textContent: delta.i18n.errorNetworkNoServiceMessage,
          icon: const Icon(Icons.cloud_off, size: 64),
          title: e.exception?.toString(),
          footer: emailUs(),
        ); //service not available
      } else {
        dialog.show(
          textContent: delta.i18n.errorNetworkBlockedMessage,
          title: e.exception?.toString(),
          icon: const Icon(Icons.cloud_off, size: 64),
          footer: emailUs(),
        );
      }
      return;
    }
    await dialog.show(
      textContent: delta.i18n.errorNetworkNoInternetMessage,
      icon: const Icon(Icons.wifi_off, size: 64),
      title: e.exception?.toString(),
    );
    return;
  }
  if (e is EmailSupportEvent) {
    final em = ErrorEmail();
    em.launchMailTo();
    return;
  }
}
