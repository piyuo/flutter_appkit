import 'dart:async';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:libcli/src/dialogs/toast.dart';
import 'package:libcli/src/dialogs/popup.dart';
import 'package:libcli/src/dialogs/popup-menu.dart';

/// ToastHideDuration set when toast will hide
///
var ToastHideDuration = Duration(seconds: 3);

/// dialogsNavigatorKey used in rootContext
///
final dialogsNavigatorKey = new GlobalKey<NavigatorState>();

/// dialogsRootContext return context from navigatorKey
///
BuildContext get dialogsRootContext {
  assert(dialogsNavigatorKey.currentState != null && dialogsNavigatorKey.currentState!.overlay != null,
      'you need set navigatorKey: dialogsNavigatorKey in MaterialApp');
  return dialogsNavigatorKey.currentState!.overlay!.context;
}

/// DialogOverlay provide overlay for dialog
///
class DialogOverlay extends StatelessWidget {
  final Widget child;

  DialogOverlay({
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return OKToast(child: child);
  }
}

/// toast show toast
///
void toast(
  BuildContext context,
  String message, {
  Icon? icon,
}) {
  showToastWidget(
    Toast(
      icon: icon,
      message: message,
      backgroundColor: Colors.black87,
    ),
    context: context,
    dismissOtherToast: true,
    duration: ToastHideDuration,
  );
}

/// popMenu show menu
///
Future<MenuItem> popMenu(
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

/// tooltip show tooltip
///
void tooltip(BuildContext context, String message,
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
        padding: EdgeInsets.all(16),
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
