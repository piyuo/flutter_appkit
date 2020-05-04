import 'dart:core';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:libcli/src/dialog/popup.dart';

class MenuItem {
  String id;

  double width;

  double height;

  Widget widget;

  String title;

  TextStyle textStyle;

  TextAlign textAlign;

  MenuItem({
    this.id,
    this.title,
    this.widget,
    this.textStyle,
    this.textAlign = TextAlign.center,
  }) {
    textStyle =
        textStyle ?? TextStyle(color: Color(0xffc5c5c5), fontSize: 10.0);
  }
}

enum MenuType { big, oneLine }

typedef MenuClickCallback = Function(MenuItem item);

class PopupMenu extends Popup {
  List<MenuItem> items;

  /// row count
  int _row;

  /// col count
  int _col;

  /// The max column count, default is 4.
  int maxColumn;

  MenuClickCallback onClickMenu;

  /// style
  Color _highlightColor;

  Color _lineColor;

  PopupMenu(
    BuildContext context, {
    VoidCallback onDismiss,
    Color backgroundColor,
    Color highlightColor,
    Color lineColor,
    double itemWidth = 72.0,
    double itemHeight = 65.0,
    this.onClickMenu,
    this.maxColumn,
    this.items,
  }) : super(
          context,
          onDismiss: onDismiss,
          backgroundColor: backgroundColor,
          itemWidth: itemWidth,
          itemHeight: itemHeight,
        ) {
    this.maxColumn = maxColumn ?? 4;
    this._lineColor = lineColor ?? Color(0xff353535);
    this._highlightColor = highlightColor ?? Color(0x55000000);
    for (var item in items) {
      item.width = itemWidth;
      item.height = itemHeight;
    }
  }

  static Rect getWidgetGlobalRect(GlobalKey key) {
    RenderBox renderBox = key.currentContext.findRenderObject();
    var offset = renderBox.localToGlobal(Offset.zero);
    return Rect.fromLTWH(
        offset.dx, offset.dy, renderBox.size.width, renderBox.size.height);
  }

  @override
  void calculatePosition(BuildContext context) {
    _col = _calculateColCount();
    _row = _calculateRowCount();
    super.calculatePosition(context);
  }

  @override
  double menuWidth() {
    return itemWidth * _col;
  }

  // This height exclude the arrow
  @override
  double menuHeight() {
    return itemHeight * _row;
  }

  @override
  Widget popupContent() => Column(
        children: _createRows(),
      );

  List<Widget> _createRows() {
    List<Widget> rows = [];
    for (int i = 0; i < _row; i++) {
      Color color =
          (i < _row - 1 && _row != 1) ? _lineColor : Colors.transparent;
      Widget rowWidget = Container(
        decoration:
            BoxDecoration(border: Border(bottom: BorderSide(color: color))),
        height: itemHeight,
        child: Row(
          children: _createRowItems(i),
        ),
      );

      rows.add(rowWidget);
    }

    return rows;
  }

  List<Widget> _createRowItems(int row) {
    List<MenuItem> subItems =
        items.sublist(row * _col, min(row * _col + _col, items.length));
    List<Widget> itemWidgets = [];
    int i = 0;
    for (var item in subItems) {
      itemWidgets.add(_createMenuItem(
        item,
        i < (_col - 1),
      ));
      i++;
    }

    return itemWidgets;
  }

  // calculate row count
  int _calculateRowCount() {
    if (items == null || items.length == 0) {
      debugPrint('error menu items can not be null');
      return 0;
    }

    int itemCount = items.length;

    if (_calculateColCount() == 1) {
      return itemCount;
    }

    int row = (itemCount - 1) ~/ _calculateColCount() + 1;

    return row;
  }

  // calculate col count
  int _calculateColCount() {
    if (items == null || items.length == 0) {
      debugPrint('error menu items can not be null');
      return 0;
    }

    int itemCount = items.length;
    if (maxColumn != 4 && maxColumn > 0) {
      return maxColumn;
    }

    if (itemCount == 4) {
      // 4个显示成两行
      return 2;
    }

    if (itemCount <= maxColumn) {
      return itemCount;
    }

    if (itemCount == 5) {
      return 3;
    }

    if (itemCount == 6) {
      return 3;
    }

    return maxColumn;
  }

  double get screenWidth {
    double width = window.physicalSize.width;
    double ratio = window.devicePixelRatio;
    return width / ratio;
  }

  Widget _createMenuItem(MenuItem item, bool showLine) {
    return _MenuItemWidget(
      item: item,
      showLine: showLine,
      clickCallback: itemClicked,
      lineColor: _lineColor,
      backgroundColor: backgroundColor,
      highlightColor: _highlightColor,
    );
  }

  void itemClicked(MenuItem item) {
    if (onClickMenu != null) {
      onClickMenu(item);
    }

    dismiss();
  }
}

class _MenuItemWidget extends StatefulWidget {
  final MenuItem item;
  final bool showLine;
  final Color lineColor;
  final Color backgroundColor;
  final Color highlightColor;

  final Function(MenuItem item) clickCallback;

  _MenuItemWidget(
      {this.item,
      this.showLine = false,
      this.clickCallback,
      this.lineColor,
      this.backgroundColor,
      this.highlightColor});

  @override
  State<StatefulWidget> createState() {
    return _MenuItemWidgetState();
  }
}

class _MenuItemWidgetState extends State<_MenuItemWidget> {
  var highlightColor = Color(0x55000000);
  var color = Color(0xff232323);

  @override
  void initState() {
    color = widget.backgroundColor;
    highlightColor = widget.highlightColor;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) {
        color = highlightColor;
        setState(() {});
      },
      onTapUp: (details) {
        color = widget.backgroundColor;
        setState(() {});
      },
      onLongPressEnd: (details) {
        color = widget.backgroundColor;
        setState(() {});
      },
      onTap: () {
        if (widget.clickCallback != null) {
          widget.clickCallback(widget.item);
        }
      },
      child: Container(
          width: widget.item.width,
          height: widget.item.height,
          decoration: BoxDecoration(
              color: color,
              border: Border(
                  right: BorderSide(
                      color: widget.showLine
                          ? widget.lineColor
                          : Colors.transparent))),
          child: _createContent()),
    );
  }

  Widget _createContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        widget.item.widget != null
            ? Expanded(
                child: widget.item.widget,
              )
            : Container(),
        widget.item.title != null
            ? Container(
                height: 22.0,
                child: Material(
                  color: Colors.transparent,
                  child: Text(
                    widget.item.title,
                    style: widget.item.textStyle,
                  ),
                ),
              )
            : Container()
      ],
    );
  }
}
