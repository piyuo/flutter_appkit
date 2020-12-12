import 'dart:core';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:libcli/src/dialogs/triangle-painter.dart';

const arrowHeight = 10.0;

class Popup {
  final BuildContext context;

  final Widget? child;

  /// backgroundColor
  ///
  final Color backgroundColor;

  double itemWidth;

  double itemHeight;

  OverlayEntry? _entry;

  /// The left top point of this menu.
  ///
  Offset _offset = Offset(0, 0);

  /// Menu will show at above or under this rect
  ///
  Rect _showRect = Rect.fromLTWH(0, 0, 0, 0);

  /// if false menu is show above of the widget, otherwise menu is show under the widget
  ///
  bool _isDown = true;

  /// callback
  final VoidCallback? onDismiss;

  Size _screenSize = Size(0, 0);

  /// It's showing or not.
  bool _isShow = false;

  Popup({
    required this.context,
    this.child,
    this.onDismiss,
    this.backgroundColor = Colors.black,
    this.itemWidth = 72.0,
    this.itemHeight = 65.0,
  });

  void show({Rect? rect, GlobalKey? widgetKey}) {
    assert(rect != null || widgetKey != null, "need 'rect' or 'widgetKey'");
    this._showRect = rect ?? Popup.getWidgetGlobalRect(widgetKey!);
    this._screenSize = window.physicalSize / window.devicePixelRatio;
    calculatePosition(context);
    _entry = OverlayEntry(builder: (context) {
      return buildPopupLayout(_offset);
    });
    Overlay.of(context)!.insert(_entry!);
    _isShow = true;
  }

  static Rect getWidgetGlobalRect(GlobalKey key) {
    RenderBox renderBox = key.currentContext!.findRenderObject() as RenderBox;
    var offset = renderBox.localToGlobal(Offset.zero);
    return Rect.fromLTWH(offset.dx, offset.dy, renderBox.size.width, renderBox.size.height);
  }

  void calculatePosition(BuildContext context) {
    _offset = _calculateOffset(context);
  }

  Offset _calculateOffset(BuildContext context) {
    double dx = _showRect.left + _showRect.width / 2.0 - menuWidth() / 2.0;
    if (dx < 10.0) {
      dx = 10.0;
    }

    if (dx + menuWidth() > _screenSize.width && dx > 10.0) {
      double tempDx = _screenSize.width - menuWidth() - 10;
      if (tempDx > 10) dx = tempDx;
    }

    double dy = _showRect.top - menuHeight();
    if (dy <= MediaQuery.of(context).padding.top + 10) {
      // The have not enough space above, show menu under the widget.
      dy = arrowHeight + _showRect.height + _showRect.top;
      _isDown = false;
    } else {
      dy -= arrowHeight;
      _isDown = true;
    }

    return Offset(dx, dy);
  }

  double menuWidth() {
    return itemWidth;
  }

  // This height exclude the arrow
  double menuHeight() {
    return itemHeight;
  }

  LayoutBuilder buildPopupLayout(Offset offset) {
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
        child: Container(
          child: Stack(
            children: <Widget>[
              // triangle arrow
              Positioned(
                left: _showRect.left + _showRect.width / 2.0 - 7.5,
                top: _isDown ? offset.dy + menuHeight() : offset.dy - arrowHeight,
                child: CustomPaint(
                  size: Size(15.0, arrowHeight),
                  painter: TrianglePainter(isDown: _isDown, color: backgroundColor),
                ),
              ),
              // menu content
              Positioned(
                left: offset.dx,
                top: offset.dy,
                child: Container(
                  width: menuWidth(),
                  height: menuHeight(),
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black87,
                        blurRadius: 5.0,
                      )
                    ],
                  ),
                  child: popupContent(),
                ),
              )
            ],
          ),
        ),
      );
    });
  }

  @protected
  Widget popupContent() => child!;

  double get screenWidth {
    double width = window.physicalSize.width;
    double ratio = window.devicePixelRatio;
    return width / ratio;
  }

  void dismiss() {
    if (!_isShow) {
      // Remove method should only be called once
      return;
    }

    _entry?.remove();
    _isShow = false;
    if (onDismiss != null) {
      onDismiss!();
    }
  }
}
