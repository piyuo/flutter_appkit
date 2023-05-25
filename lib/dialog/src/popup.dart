import 'dart:core';
import 'package:flutter/material.dart';
import 'package:libcli/delta/delta.dart' as delta;

/// getWidgetGlobalRect return widget global rect
/// ```dart
/// var rect = getWidgetGlobalRect(globalKey);
/// ```
Rect getWidgetGlobalRect(GlobalKey key) {
  RenderBox renderBox = key.currentContext!.findRenderObject() as RenderBox;
  var offset = renderBox.localToGlobal(Offset.zero);
  return Rect.fromLTWH(offset.dx, offset.dy, renderBox.size.width, renderBox.size.height);
}

/// popup a child in popup window
/// ```dart
/// popup(
///   context,
///   child:Container(),
/// );
///```
Popup popup(
  BuildContext context, {
  required Widget child,
  VoidCallback? onDismiss,
  Rect? rect,
}) {
  return Popup(
    onDismiss: onDismiss,
  )..show(
      context,
      child: child,
      rect: rect,
    );
}

class Popup {
  /// Popup container for child
  /// ```dart
  ///     Popup(
  ///       onDismiss: onDismiss,
  ///     )..show(context, rect);
  ///````
  Popup({
    this.onDismiss,
  });

  /// onDismiss callback when popup dismiss
  final VoidCallback? onDismiss;

  /// _overlay contain child
  OverlayEntry? _overlay;

  /// show child in rect
  void show(
    BuildContext context, {
    required Widget child,
    Rect? rect,
  }) {
    rect = rect ?? const Rect.fromLTWH(0, 0, 100, 100);
    double left = rect.left;
    double top = rect.top;
    double width = rect.width;
    double height = rect.height;

    int padding = 10;
    if (left + width > delta.screenSize.width - padding) {
      width = delta.screenSize.width - left - padding;
    }
    if (top + height > delta.screenSize.height - padding) {
      height = delta.screenSize.height - top - padding;
    }
    if (left < 0) {
      left = 0;
    }
    if (top < 0) {
      top = 0;
    }

    /// show widget in overlay
    showWidget(
      context,
      child: Stack(
        children: <Widget>[
          // menu content
          Positioned(
            left: left,
            top: top,
            width: width,
            height: height,
            child: child,
          )
        ],
      ),
    );
  }

  /// show popup
  void showWidget(
    BuildContext context, {
    required Widget child,
  }) {
    _overlay = OverlayEntry(builder: (context) {
      return LayoutBuilder(builder: (context, constraints) {
        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            dismiss();
          },
          onVerticalDragStart: (DragStartDetails details) {
            dismiss();
          },
          onHorizontalDragStart: (DragStartDetails details) {
            dismiss();
          },
          child: child,
        );
      });
    });
    Overlay.of(context).insert(_overlay!);
  }

  /// dismiss popup popup
  void dismiss() {
    if (_overlay == null) {
      return;
    }

    _overlay?.remove();
    if (onDismiss != null) {
      onDismiss!();
    }
  }
}
