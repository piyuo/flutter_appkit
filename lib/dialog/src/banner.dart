import 'dart:async';
import 'package:flutter/material.dart';
import 'package:libcli/i18n/i18n.dart' as i18n;

/// banner show a simple text banner
///
///     banner(
///       context,
///       const Text(
///         'this record has been deleted',
///         style: TextStyle(fontSize: 18, color: Colors.black),
///       ),
///       leading: const Icon(Icons.warning, color: Colors.black),
///     );
///
Future<void> banner(
  BuildContext context,
  Widget child, {
  Widget? leading,
}) {
  final completer = Completer();
  Timer timer = Timer(const Duration(seconds: 15), () {
    ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
    completer.complete();
  });

  ScaffoldMessenger.of(context).showMaterialBanner(
    MaterialBanner(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      content: child,
      leading: leading,
      backgroundColor: Colors.yellow[700]!.withOpacity(0.9),
      actions: <Widget>[
        TextButton(
          child: Text(
            context.i18n.closeButtonText,
            style: const TextStyle(color: Colors.brown, fontWeight: FontWeight.bold),
          ),
          onPressed: () {
            timer.cancel();
            ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
            completer.complete();
          },
        ),
      ],
    ),
  );
  return completer.future;
}
