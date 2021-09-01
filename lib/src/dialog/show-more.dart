import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:libcli/delta.dart' as delta;
import 'popup.dart';
import 'triangle-painter.dart';

const arrowHeight = 12.0;
const arrowWidth = 24.0;

/// showMore show small popup widget
///
Popup showMore(
  BuildContext context, {
  required Widget child,
  GlobalKey? targetKey,
  Offset? targetOffset,
  double width = 160,
  double height = 90,
  Color? backgroundColor,
}) {
  assert(targetKey != null || targetOffset != null, 'must have target key or offset');
  backgroundColor = backgroundColor ??
      context.themeColor(
        light: Colors.grey[100]!,
        dark: Colors.grey[850]!,
      );
  final screenSize = window.physicalSize / window.devicePixelRatio;
  bool isDown = false;

  Rect widgetRect = Rect.zero;
  if (targetKey != null) {
    widgetRect = getWidgetGlobalRect(targetKey);
  }
  if (targetOffset != null) {
    widgetRect = Rect.fromLTWH(targetOffset.dx, targetOffset.dy, width, height);
  }
  double triangleX = widgetRect.left + widgetRect.width / 2.0 - width / 2.0;
  if (triangleX < 10.0) {
    triangleX = 10.0;
  }

  if (triangleX + width > screenSize.width && triangleX > 10.0) {
    double tempDx = screenSize.width - width - 10;
    if (tempDx > 10) triangleX = tempDx;
  }

  double triangleY = widgetRect.top - height;
  if (triangleY <= MediaQuery.of(context).padding.top + 10) {
    // The have not enough space above, show menu under the widget.
    triangleY = arrowHeight + widgetRect.height + widgetRect.top;
    isDown = false;
  } else {
    triangleY -= arrowHeight;
    isDown = true;
  }

  return Popup()
    ..showWidget(
      context,
      child: Stack(
        children: <Widget>[
          // menu content
          Positioned(
              left: triangleX,
              top: triangleY,
              child: SizedBox(
                width: width,
                height: height,
                child: Material(
                  color: backgroundColor,
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  child: child,
                ),
              )),
          // triangle arrow
          Positioned(
            left: widgetRect.left + widgetRect.width / 2.0 - arrowWidth / 2,
            top: isDown ? triangleY + height : triangleY - arrowHeight,
            child: CustomPaint(
              size: Size(arrowWidth, arrowHeight),
              painter: TrianglePainter(isDown: isDown, color: backgroundColor),
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
  GlobalKey? targetKey,
  Offset? targetOffset,
  double width = 160,
  double height = 200,
}) {
  showMore(
    context,
    targetKey: targetKey,
    targetOffset: targetOffset,
    width: width,
    height: height,
    child: Center(
        child: Text(text,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.normal,
              decoration: TextDecoration.none,
            ))),
  );
}
