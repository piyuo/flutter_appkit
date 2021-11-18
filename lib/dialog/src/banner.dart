import 'dart:async';
import 'package:flutter/material.dart';
import 'package:libcli/i18n/i18n.dart' as i18n;

/// banner show a simple text banner
///
Future<void> banner(
  BuildContext context,
  String text, {
  IconData? icon,
}) {
  final completer = Completer();
  Timer timer = Timer(const Duration(seconds: 15), () {
    ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
    completer.complete();
  });

  ScaffoldMessenger.of(context).showMaterialBanner(
    MaterialBanner(
      padding: const EdgeInsets.all(10),
      content: Text(text),
      leading: icon != null ? Icon(icon) : null,
      backgroundColor: Colors.yellow[700],
      actions: <Widget>[
        TextButton(
          child: Text(
            context.i18n.closeButtonText,
            style: const TextStyle(color: Colors.black),
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
