import 'dart:core';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:libcli/src/dialogs/popup.dart';

class MenuItem {
  final String id;

  final String text;

  final Widget? widget;

  double width = 0;

  double height = 0;

  TextStyle? textStyle;

  TextAlign textAlign;

  MenuItem({
    required this.id,
    required this.text,
    this.widget,
    this.textStyle,
    this.textAlign = TextAlign.center,
  }) {
    textStyle = textStyle ?? TextStyle(color: Color(0xffc5c5c5), fontSize: 10.0);
  }
}

enum MenuType { big, oneLine }

typedef MenuClickCallback = Function(MenuItem item);

class PopupMenu extends Popup {
  final List<MenuItem> items;

  /// row count
  int _row = 0;

  /// col count
  int _col = 0;

  /// The max column count, default is 4.
  int _maxColumn = 4;

  final MenuClickCallback onClickItem;

  /// style
  Color _highlightColor = CupertinoColors.black;

  Color _lineColor = CupertinoColors.black;

  PopupMenu({
    required BuildContext context,
    required this.items,
    required this.onClickItem,
    VoidCallback? onDismiss,
    Color backgroundColor = CupertinoColors.black,
    Color? highlightColor,
    Color? lineColor,
    double itemWidth = 72.0,
    double itemHeight = 65.0,
    int? maxColumn,
  }) : super(
          context: context,
          onDismiss: onDismiss,
          backgroundColor: backgroundColor,
          itemWidth: itemWidth,
          itemHeight: itemHeight,
        ) {
    this._maxColumn = maxColumn ?? 4;
    this._lineColor = lineColor ?? Color(0xff353535);
    this._highlightColor = highlightColor ?? Color(0x55000000);
    for (var item in items) {
      item.width = itemWidth;
      item.height = itemHeight;
    }
  }

  static Rect getWidgetGlobalRect(GlobalKey key) {
    assert(key.currentContext != null);
    RenderBox renderBox = key.currentContext!.findRenderObject() as RenderBox;
    var offset = renderBox.localToGlobal(Offset.zero);
    return Rect.fromLTWH(offset.dx, offset.dy, renderBox.size.width, renderBox.size.height);
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
      Color color = (i < _row - 1 && _row != 1) ? _lineColor : Color.fromRGBO(0, 0, 0, 0);
      Widget rowWidget = Container(
        decoration: BoxDecoration(border: Border(bottom: BorderSide(color: color))),
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
    List<MenuItem> subItems = items.sublist(row * _col, min(row * _col + _col, items.length));
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
    int itemCount = items.length;

    if (_calculateColCount() == 1) {
      return itemCount;
    }

    int row = (itemCount - 1) ~/ _calculateColCount() + 1;

    return row;
  }

  // calculate col count
  int _calculateColCount() {
    int itemCount = items.length;
    if (_maxColumn != 4 && _maxColumn > 0) {
      return _maxColumn;
    }

    if (itemCount == 4) {
      // 4个显示成两行
      return 2;
    }

    if (itemCount <= _maxColumn) {
      return itemCount;
    }

    if (itemCount == 5) {
      return 3;
    }

    if (itemCount == 6) {
      return 3;
    }

    return _maxColumn;
  }

  double get screenWidth {
    double width = window.physicalSize.width;
    double ratio = window.devicePixelRatio;
    return width / ratio;
  }

  Widget _createMenuItem(MenuItem item, bool showLine) {
    return MenuItemWidget(
      item: item,
      showLine: showLine,
      clickCallback: (MenuItem item) {
        onClickItem(item);
        dismiss();
      },
      lineColor: _lineColor,
      backgroundColor: backgroundColor,
      highlightColor: _highlightColor,
    );
  }
}

class MenuItemWidget extends StatefulWidget {
  final MenuItem item;
  final bool showLine;
  final Color lineColor;
  final Color backgroundColor;
  final Color highlightColor;

  final Function(MenuItem item) clickCallback;

  MenuItemWidget({
    required this.item,
    this.showLine = false,
    required this.clickCallback,
    required this.lineColor,
    required this.backgroundColor,
    required this.highlightColor,
  });

  @override
  State<StatefulWidget> createState() {
    return MenuItemWidgetState();
  }
}

class MenuItemWidgetState extends State<MenuItemWidget> {
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
        widget.clickCallback(widget.item);
      },
      child: Container(
          width: widget.item.width,
          height: widget.item.height,
          decoration: BoxDecoration(
              color: color,
              border:
                  Border(right: BorderSide(color: widget.showLine ? widget.lineColor : Color.fromRGBO(0, 0, 0, 0)))),
          child: _createContent()),
    );
  }

  Widget _createContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        widget.item.widget != null
            ? Expanded(
                child: widget.item.widget!,
              )
            : Container(),
        Container(
          height: 22.0,
          child: Text(
            widget.item.text,
            style: widget.item.textStyle,
          ),
        )
      ],
    );
  }
}
