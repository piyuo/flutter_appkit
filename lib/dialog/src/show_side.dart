import 'dart:async';
import 'package:flutter/material.dart';

/// showSheet show popup sheet from the bottom
/// ```dart
/// final result = await showSide(
///   context,
///   child: Column(children: const [
///     SizedBox(height: 30),
///     SizedBox(height: 80, child: Placeholder()),
///     SizedBox(height: 120),
///   ]),
/// )
/// ```
Future<T?> showSide<T>(
  BuildContext context, {
  required Widget child,
  BoxConstraints constraints = const BoxConstraints(maxWidth: 275),
}) {
  return showGeneralDialog(
    barrierLabel: "side",
    barrierDismissible: true,
    transitionDuration: const Duration(milliseconds: 220),
    context: context,
    pageBuilder: (context, anim1, anim2) {
      return Align(
          alignment: Alignment.centerLeft,
          child: ConstrainedBox(
              constraints: constraints,
              child: Material(
                child: child,
              )));
    },
    transitionBuilder: (context, anim1, anim2, child) {
      return SlideTransition(
        position: Tween(begin: const Offset(-1, 0), end: const Offset(0, 0)).animate(anim1),
        child: child,
      );
    },
  );
}
