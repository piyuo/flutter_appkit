import 'dart:async';
import 'package:flutter/material.dart';
import 'package:libcli/delta/delta.dart' as delta;

/// showBanner show a simple text banner
/// ```dart
/// showBanner(
///   context,
///   const Text(
///     'this record has been deleted',
///   ),
///   leading: const Icon(Icons.warning, color: Colors.black),
/// );
/// ```
Future<void> showBanner(
  Widget child, {
  Color? color,
  Color? backgroundColor,
  Widget? leading,
}) {
  dismissBanner(delta.globalContext);
  final completer = Completer();
  Timer timer = Timer(const Duration(seconds: 15), () {
    dismissBanner(delta.globalContext);
    completer.complete();
  });
  final colorScheme = Theme.of(delta.globalContext).colorScheme;
  ScaffoldMessenger.of(delta.globalContext).showMaterialBanner(
    MaterialBanner(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      content: child,
      leading: leading,
      backgroundColor: backgroundColor ?? colorScheme.surfaceVariant,
      actions: <Widget>[
        TextButton(
          child: Text(
            delta.i18n.closeButtonText,
            style: TextStyle(color: color ?? colorScheme.onSurface),
          ),
          onPressed: () {
            timer.cancel();
            dismissBanner(delta.globalContext);
            completer.complete();
          },
        ),
      ],
    ),
  );
  return completer.future;
}

/// dismissBanner dismiss banner
void dismissBanner(BuildContext context) {
  ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
}

/// showErrorBanner show a simple text banner when error
Future<void> showErrorBanner(
  String message,
) {
  final colorScheme = Theme.of(delta.globalContext).colorScheme;
  return showBanner(
    Text(message, style: TextStyle(color: colorScheme.onError)),
    leading: Icon(Icons.info_outline, color: colorScheme.onError),
    color: colorScheme.onError,
    backgroundColor: colorScheme.error,
  );
}

/// showTextBanner show a simple text banner
Future<void> showTextBanner(String message) {
  final colorScheme = Theme.of(delta.globalContext).colorScheme;
  return showBanner(
    Text(message, style: TextStyle(color: colorScheme.onSurface)),
  );
}
