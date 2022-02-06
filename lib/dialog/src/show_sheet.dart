import 'dart:async';
import 'package:flutter/material.dart';
import 'package:libcli/delta/delta.dart' as delta;

/// showSheet show popup sheet from the bottom
///
/// ```dart
/// showSheet(
///      context,
///      color: Colors.red,
///      closeButtonColor: Colors.blue,
///      child: Column(children: const [
///        SizedBox(height: 30),
///        SizedBox(height: 80, child: Placeholder()),
///        SizedBox(height: 120),
///      ]),
///    )
/// ```
Future<void> showSheet(
  BuildContext context, {
  required Widget child,
  Color? color,
  Color closeButtonColor = Colors.grey,
  BoxConstraints constraints = const BoxConstraints(maxWidth: 600),
}) {
  return showGeneralDialog(
    barrierLabel: "sheet",
    barrierDismissible: true,
    barrierColor: Colors.grey.withOpacity(0.2),
    transitionDuration: const Duration(milliseconds: 220),
    context: context,
    pageBuilder: (context, anim1, anim2) {
      return Align(
        alignment: Alignment.bottomCenter,
        child: ConstrainedBox(
          constraints: constraints,
          child: Container(
            decoration: BoxDecoration(
              color: color ??
                  context.themeColor(
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
                      iconSize: 32,
                      color: closeButtonColor,
                      icon: const Icon(Icons.cancel_rounded),
                      onPressed: () => Navigator.pop(context),
                    )),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: IntrinsicHeight(
                    child: SizedBox(
                      width: double.infinity,
                      child: child,
                    ),
                  ),
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
