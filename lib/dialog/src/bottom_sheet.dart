import 'dart:async';
import 'package:flutter/material.dart';
import 'package:libcli/delta/delta.dart' as delta;

/// bottomSheet show popup sheet from bottom
///
/// ```dart
/// bottomSheet(
///      context,
///      child: Column(children: const [
///        SizedBox(height: 30),
///        SizedBox(height: 80, child: Placeholder()),
///        SizedBox(height: 120),
///      ]),
///    )
/// ```
Future<void> bottomSheet(
  BuildContext context, {
  required Widget child,
}) {
  return showGeneralDialog(
    barrierLabel: "bottom",
    barrierDismissible: true,
    barrierColor: Colors.black.withOpacity(0.1),
    transitionDuration: const Duration(milliseconds: 220),
    context: context,
    pageBuilder: (context, anim1, anim2) {
      return Align(
        alignment: Alignment.bottomCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600), //SET max width
          child: Container(
            decoration: BoxDecoration(
              color: context.themeColor(
                light: Colors.white,
                dark: Colors.grey.shade800,
              ),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Stack(
              children: [
                Positioned(
                    right: 0,
                    top: 0,
                    child: IconButton(
                      iconSize: 30,
                      color: Colors.grey,
                      icon: const Icon(Icons.cancel_rounded),
                      onPressed: () => Navigator.pop(context),
                    )),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: IntrinsicHeight(child: child),
                ),
              ],
            ),
          ),
        ),
      );
    },
    transitionBuilder: (context, anim1, anim2, child) {
      return SlideTransition(
        position: Tween(begin: const Offset(0, 1), end: const Offset(0, 0)).animate(anim1),
        child: child,
      );
    },
  );
}
