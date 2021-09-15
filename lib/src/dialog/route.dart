import 'dart:ui';
import 'dart:async';
import 'package:flutter/material.dart';

/// routeOrDialog will push route if screen size small than min, otherwise it will show widget in dialog
///
Future<T?> routeOrDialog<T>(
  BuildContext ctx,
  Widget widget, {
  Size min = const Size(600, 800),
}) async {
  final screenSize = MediaQuery.of(ctx).size;
  final isDark = MediaQuery.of(ctx).platformBrightness == Brightness.dark;

  if (screenSize.width > min.width && screenSize.height > min.height) {
    // show dialog
    return await showDialog<T>(
        context: ctx,
        barrierColor: isDark ? const Color.fromRGBO(25, 25, 28, 0.6) : const Color.fromRGBO(230, 230, 238, 0.6),
        barrierDismissible: true,
        builder: (BuildContext ctx) {
          return Dialog(
            elevation: 0,
            backgroundColor: Colors.white,
            child: SizedBox(
              width: min.width,
              height: min.height,
              child: widget,
            ),
          );
        });
  }

  // show route
  return await Navigator.push<T>(
    ctx,
    MaterialPageRoute(builder: (context) => widget),
  );
}
