import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:libcli/src/dialog/dialog_error.dart';
import 'package:libcli/src/dialog/dialog_alert.dart';
import 'package:libcli/src/dialog/dialog_choice.dart';
import 'package:libcli/src/dialog/message_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:libcli/i18n.dart';
import 'package:libcli/src/dialog/popup.dart';
import 'package:libcli/src/dialog/popup_menu.dart';

final navigatorKey = new GlobalKey<NavigatorState>();

BuildContext get rootContext {
  assert(navigatorKey.currentState != null,
      'you need set navigatorKey: dialog.navigatorKey in MaterialApp');
  return navigatorKey.currentState.overlay.context;
}

/// show widget dialog
///
Future show(BuildContext context, Widget child) {
  return showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return Dialog(
          insetPadding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(2.0)), //this right here
          child: child,
        );
      });
}

/// toast widget
///
void toast(BuildContext context, Widget child) {
  showToastWidget(
    child,
    dismissOtherToast: true,
    context: context,
    duration: Duration(seconds: 4),
  );
}

Future alert(BuildContext context, String message,
    {String title, Color color, IconData icon}) {
  var alert = DialogAlert(
    title: title,
    message: message,
    color: color,
    icon: icon,
  );
  return show(context, alert);
}

void hint(BuildContext context, String message, {Color color, IconData icon}) {
  toast(context, MessageToast(icon: icon, message: message));
}

Future choice(BuildContext context, String message,
    {String ok, String cancel, String title, Color color, IconData icon}) {
  var alert = DialogChoice(
      title: title,
      message: message,
      color: color,
      icon: icon,
      ok: ok,
      cancel: cancel);
  return show(context, alert);
}

Future confirm(BuildContext context, String message,
    {String ok, String cancel, String title}) {
  return showDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
            title: title != null ? Text(title) : null,
            content: Text(message),
            actions: <Widget>[
              CupertinoDialogAction(
                isDefaultAction: true,
                child: Text(ok ?? 'ok'.i18n_),
                onPressed: () => Navigator.of(context).pop(true),
              ),
              CupertinoDialogAction(
                child: Text(cancel ?? 'cancel'.i18n_),
                onPressed: () => Navigator.of(context).pop(false),
              )
            ],
          ));
}

///error show error dialog with error code
///
Future error(BuildContext context, String errorCode) {
  return show(
      context,
      DialogError(
        errorCode: errorCode,
      ));
}

tip(
  BuildContext context,
  String text, {
  Function(MenuItem) onPressed,
  GlobalKey targetKey,
  Rect rect,
}) {
  double width = 130;
  double height = 160;
  var len = text.length;
  if (len > 50) {
    width = 160;
    height = 200;
  }
  if (len > 160) {
    width = 180;
    height = 240;
  }

  var popup = Popup(
    context,
    child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(12),
        child: Text(text, style: TextStyle(color: Colors.white))),
    itemWidth: width,
    itemHeight: height,
    backgroundColor: Colors.blue,
  );

  popup.show(widgetKey: targetKey, rect: rect);
}

void menu(
  BuildContext context, {
  List<MenuItem> items,
  Function(MenuItem) onPressed,
  GlobalKey targetKey,
}) {
  var menu = PopupMenu(
    context,
    items: items,
    onClickMenu: onPressed,
  );
  menu.show(widgetKey: targetKey);
}
