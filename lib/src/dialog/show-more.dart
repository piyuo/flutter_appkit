import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:libcli/delta.dart' as delta;
import 'triangle-painter.dart';

const arrowHeight = 12.0;
const arrowWidth = 24.0;

/// targetShowMore show small popup below or above target
///
delta.Popup targetShowMore(
  BuildContext context, {
  required Widget child,
  required Size size, // size is child size
  required GlobalKey targetKey,
  Color? backgroundColor,
}) {
  Rect targetRect = delta.getWidgetGlobalRect(targetKey);
  return showMore(
    context,
    child: child,
    size: size,
    targetRect: targetRect,
    backgroundColor: backgroundColor,
  );
}

/// showMore show small popup below or above rect
///
delta.Popup showMore(
  BuildContext context, {
  required Widget child,
  required Size size, // size is child size
  required Rect targetRect,
  Color? backgroundColor,
}) {
  backgroundColor = backgroundColor ??
      context.themeColor(
        light: Colors.grey[100]!,
        dark: Colors.grey[850]!,
      );
  final screenSize = window.physicalSize / window.devicePixelRatio;
  bool triangleInBottom = false;

  double dx = targetRect.left + targetRect.width / 2.0 - size.width / 2.0;
  if (dx < 10.0) {
    dx = 10.0;
  }

  if (dx + size.width > screenSize.width && dx > 10.0) {
    double tempDx = screenSize.width - size.width - 10;
    if (tempDx > 10) dx = tempDx;
  }

  double dy = targetRect.top - size.height;
  if (dy <= MediaQuery.of(context).padding.top + 10) {
    // The have not enough space above, show menu under the widget.
    dy = arrowHeight + targetRect.height + targetRect.top;
    triangleInBottom = false;
  } else {
    dy -= arrowHeight;
    triangleInBottom = true;
  }

  return delta.Popup()
    ..showWidget(
      context,
      child: Stack(
        children: <Widget>[
          // menu content
          Positioned(
              left: dx,
              top: dy,
              child: SizedBox(
                width: size.width,
                height: size.height,
                child: Material(
                  color: backgroundColor,
                  elevation: 10,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  child: child,
                ),
              )),
          // triangle arrow
          Positioned(
            left: targetRect.left + targetRect.width / 2.0 - arrowWidth / 2,
            top: triangleInBottom ? dy + size.height : dy - arrowHeight,
            child: CustomPaint(
              size: const Size(arrowWidth, arrowHeight),
              painter: TrianglePainter(isDown: triangleInBottom, color: backgroundColor),
            ),
          ),
        ],
      ),
    );
}

/// showMoreText show more text popup
///
void showMoreText(
  BuildContext context, {
  required String text,
  required Size size,
  required Rect targetRect,
}) {
  showMore(
    context,
    targetRect: targetRect,
    size: size,
    child: Center(
        child: Text(text,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.normal,
              decoration: TextDecoration.none,
            ))),
  );
}
