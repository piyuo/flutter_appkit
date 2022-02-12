import 'dart:async';
import 'package:flutter/material.dart';
import 'package:libcli/delta/delta.dart' as delta;

/// showSheet show popup sheet from the bottom
/// ```dart
/// final result = await showSide(
///      context,
///      child: Column(children: const [
///        SizedBox(height: 30),
///        SizedBox(height: 80, child: Placeholder()),
///        SizedBox(height: 120),
///      ]),
///    )
/// ```
Future<T?> showSide<T>(
  BuildContext context, {
  required Widget child,
  Color? color,
  Color barrierColor = Colors.black,
  Color closeButtonColor = Colors.grey,
  BoxConstraints constraints = const BoxConstraints(maxWidth: 275),
}) {
  return showGeneralDialog(
    barrierLabel: "side",
    barrierDismissible: true,
    barrierColor: barrierColor.withOpacity(0.4),
    transitionDuration: const Duration(milliseconds: 220),
    context: context,
    pageBuilder: (context, anim1, anim2) {
      return Align(
          alignment: Alignment.centerLeft,
          child: ConstrainedBox(
              constraints: constraints,
              child: Container(
                decoration: BoxDecoration(
                  color: color ??
                      context.themeColor(
                        light: Colors.white,
                        dark: Colors.grey.shade800,
                      ),
                  borderRadius: const BorderRadius.horizontal(right: Radius.circular(16)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      spreadRadius: 1,
                      blurRadius: 2,
                      offset: const Offset(0, 2), // changes position of shadow
                    ),
                  ],
                ),
                child: SafeArea(child: child),
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
