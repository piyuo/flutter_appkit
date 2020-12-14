import 'dart:async';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:libcli/i18n.dart';
import 'package:libcli/src/dialogs/toast.dart';
import 'package:libcli/src/dialogs/popup.dart';
import 'package:libcli/src/dialogs/popup-menu.dart';
import 'package:libcli/eventbus.dart';

final keyAlertButtonTrue = UniqueKey();

final keyAlertButtonFalse = UniqueKey();

/// ButtonType for alert dialog
///
enum ButtonType {
  close,
  okCancel,
  retryCancel,
  yesNo,
}

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

/// alert show alert dialog, return true if it's ok or yes
///
Future<bool> alert(
  BuildContext context,
  String message, {
  String? title,
  Icon? icon,
  String? description,
  bool emailUs = false,
  ButtonType buttonType = ButtonType.close,
  String? labelFalse,
  String? labelTrue,
}) async {
  var result = await showDialog<bool>(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: title != null ? Text(title) : null,
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                icon ?? SizedBox(),
                SizedBox(height: 10),
                Text(message, style: TextStyle(fontSize: 16.0)),
                SizedBox(height: 20),
                description != null
                    ? Text(description, style: TextStyle(fontSize: 13.0, color: Colors.grey))
                    : SizedBox(),
                SizedBox(height: 10),
                emailUs == true ? _emailUs(() => broadcast(context, EmailSupportEvent())) : SizedBox(),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              key: keyAlertButtonFalse,
              child: Text(labelFalse != null
                  ? labelFalse
                  : buttonType == ButtonType.close
                      ? 'close'.i18n_
                      : buttonType == ButtonType.okCancel || buttonType == ButtonType.retryCancel
                          ? 'cancel'.i18n_
                          : 'no'.i18n_),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            buttonType == ButtonType.close
                ? SizedBox()
                : FlatButton(
                    key: keyAlertButtonTrue,
                    child: Text(labelTrue != null
                        ? labelTrue
                        : buttonType == ButtonType.okCancel
                            ? 'ok'.i18n_
                            : buttonType == ButtonType.retryCancel
                                ? 'retry'.i18n_
                                : 'yes'.i18n_),
                    onPressed: () => Navigator.of(context).pop(true),
                  ),
          ],
        );
      });
  if (result == true) {
    return true;
  }
  return false;
}

Widget _emailUs(void Function()? onPressed) {
  return Container(
      child: Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      InkWell(
        onTap: onPressed,
        child: Icon(
          Icons.mail_outline,
          color: Colors.blueAccent,
          size: 18,
        ),
      ),
      SizedBox(width: 10),
      InkWell(
          child: GestureDetector(
              onTap: onPressed,
              child: Text(
                'emailUs'.i18n_,
                style: TextStyle(fontSize: 14, color: Colors.blueAccent),
              ))),
    ],
  ));
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
    context: context,
    items: items,
    onClickItem: (item) {
      completer.complete(item);
    },
  )..show(widgetKey: widgetKey);
  return completer.future;
}

/// tooltip show tooltip
///
void tooltip(
  BuildContext context,
  String message, {
  double width = 160,
  double height = 40,
  Color? backgroundColor,
  Color? color,
  GlobalKey? widgetKey,
  Rect? widgetRect,
}) {
  backgroundColor = backgroundColor ?? Color.fromRGBO(11, 129, 255, 1);
  color = color ?? Color.fromRGBO(242, 248, 255, 1);
  var popup = Popup(
    context: context,
    child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(12),
        child: Text(message,
            style: TextStyle(
              fontSize: 12,
              color: Colors.white,
              decoration: TextDecoration.none,
            ))),
    itemWidth: width,
    itemHeight: height,
    backgroundColor: backgroundColor,
  );

  popup.show(widgetKey: widgetKey, rect: widgetRect);
}
