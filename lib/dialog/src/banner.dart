import 'dart:async';
import 'package:flutter/material.dart';
import 'package:libcli/i18n/i18n.dart' as i18n;

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
  BuildContext context,
  Widget child, {
  Color? color,
  Color? backgroundColor,
  Widget? leading,
}) {
  dismissBanner(context);
  final completer = Completer();
  Timer timer = Timer(const Duration(seconds: 15), () {
    dismissBanner(context);
    completer.complete();
  });

  ScaffoldMessenger.of(context).showMaterialBanner(
    MaterialBanner(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      content: child,
      leading: leading,
      backgroundColor: backgroundColor ?? Colors.yellow[700]!.withOpacity(0.9),
      actions: <Widget>[
        TextButton(
          child: Text(
            context.i18n.closeButtonText,
            style: TextStyle(color: color ?? Colors.brown, fontWeight: FontWeight.bold),
          ),
          onPressed: () {
            timer.cancel();
            dismissBanner(context);
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

/// showErrorBanner show a simple text banner when form has error
Future<void> showErrorBanner(BuildContext context, String message) {
  return showBanner(
    context,
    Text(message,
        style: const TextStyle(
          fontSize: 16,
          color: Colors.white,
        )),
    backgroundColor: Colors.red.shade400,
    color: Colors.white,
    leading: const Icon(Icons.warning, color: Colors.white),
  );
}
