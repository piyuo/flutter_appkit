import 'dart:async';
import 'package:flutter/material.dart';
import 'popup.dart';
import 'popup-menu.dart';

/// tool show tool menu
///
Future<MenuItem> tool(
  BuildContext context, {
  required List<MenuItem> items,
  required GlobalKey widgetKey,
}) {
  Completer<MenuItem> completer = new Completer<MenuItem>();
  PopupMenu(
    items: items,
    onClickItem: (item) {
      completer.complete(item);
    },
  )..show(context, widgetKey: widgetKey);
  return completer.future;
}

/// tip show tip
///
void tip(BuildContext context, String message,
    {double width = 180,
    double height = 60,
    Color? backgroundColor,
    Color? color,
    GlobalKey? widgetKey,
    Rect? widgetRect,
    Offset? widgetPosition}) {
  backgroundColor = backgroundColor ?? Colors.lightBlue[800]!;
  color = color ?? Color.fromRGBO(242, 248, 255, 1);
  var popup = Popup(
    child: Container(
        alignment: Alignment.center,
        child: Text(message,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.normal,
              color: color,
              decoration: TextDecoration.none,
            ))),
    itemWidth: width,
    itemHeight: height,
    backgroundColor: backgroundColor,
  );

  popup.show(
    context,
    widgetKey: widgetKey,
    widgetRect: widgetRect,
    widgetPosition: widgetPosition,
  );
}
