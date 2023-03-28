import 'dart:ui';
import 'package:flutter/material.dart';
import 'popup.dart';

const arrowHeight = 12.0;
const arrowWidth = 24.0;

/// showTooltipOnTarget show small popup below or above target
/// it use colorScheme.secondary as background color
Popup showTooltipOnTarget(
  BuildContext context, {
  required Widget child,
  required Size size, // size is child size
  required GlobalKey targetKey,
  Color? backgroundColor,
}) {
  Rect targetRect = getWidgetGlobalRect(targetKey);
  return showTooltip(
    context,
    child: child,
    size: size,
    targetRect: targetRect,
  );
}

/// showTooltip show small popup below or above rect
/// it use colorScheme.secondary as background color
Popup showTooltip(
  BuildContext context, {
  required Widget child,
  required Size size, // size is child size
  required Rect targetRect,
}) {
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

  final colorScheme = Theme.of(context).colorScheme;
  return Popup()
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
                  color: colorScheme.secondary,
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
              painter: _TrianglePainter(isDown: triangleInBottom, color: colorScheme.secondary),
            ),
          ),
        ],
      ),
    );
}

/// showHint show hint text tooltip
/// it use colorScheme.secondary as background color
void showHint(
  BuildContext context, {
  required String text,
  required Size size,
  required Rect targetRect,
  TextStyle? textStyle,
}) {
  final colorScheme = Theme.of(context).colorScheme;
  showTooltip(
    context,
    targetRect: targetRect,
    size: size,
    child: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(
          text,
          style: textStyle ?? TextStyle(color: colorScheme.onSecondary),
        )),
  );
}

class _TrianglePainter extends CustomPainter {
  final Color color;

  bool isDown;

  _TrianglePainter({this.isDown = true, this.color = Colors.black});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();
    paint.strokeWidth = 2.0;
    paint.color = color;
    paint.style = PaintingStyle.fill;

    Path path = Path();
    if (isDown) {
      path.moveTo(0.0, -1.0);
      path.lineTo(size.width, -1.0);
      path.lineTo(size.width / 2.0, size.height);
    } else {
      path.moveTo(size.width / 2.0, 0.0);
      path.lineTo(0.0, size.height + 1);
      path.lineTo(size.width, size.height + 1);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
