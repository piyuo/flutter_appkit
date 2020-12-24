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
  deleteCancel,
  saveCancel,
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

String _trueButtonText(ButtonType buttonType, String? label) {
  if (label != null) {
    return label;
  }
  switch (buttonType) {
    case ButtonType.okCancel:
      return 'ok'.i18n_;
    case ButtonType.retryCancel:
      return 'retry'.i18n_;
    case ButtonType.deleteCancel:
      return 'delete'.i18n_;
    case ButtonType.saveCancel:
      return 'save'.i18n_;
    case ButtonType.yesNo:
      return 'yes'.i18n_;
    default:
  }
  assert(false, 'need implement $buttonType text');
  return '';
}

String _falseButtonText(ButtonType buttonType, String? label) {
  if (label != null) {
    return label;
  }
  switch (buttonType) {
    case ButtonType.close:
      return 'close'.i18n_;
    case ButtonType.okCancel:
    case ButtonType.retryCancel:
    case ButtonType.deleteCancel:
    case ButtonType.saveCancel:
      return 'cancel'.i18n_;
    case ButtonType.yesNo:
      return 'no'.i18n_;
    default:
  }
  assert(false, 'need implement $buttonType text');
  return '';
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
  Color? colorTrue,
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
              textTheme: ButtonTextTheme.accent,
              child: Text(_falseButtonText(buttonType, labelFalse)),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            buttonType == ButtonType.close
                ? SizedBox()
                : FlatButton(
                    key: keyAlertButtonTrue,
                    textColor: colorTrue,
                    textTheme: ButtonTextTheme.accent,
                    child: Text(_trueButtonText(buttonType, labelTrue)),
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
    {double width = 160,
    double height = 40,
    Color? backgroundColor,
    Color? color,
    GlobalKey? widgetKey,
    Rect? widgetRect,
    Offset? widgetPosition}) {
  backgroundColor = backgroundColor ?? Color.fromRGBO(11, 129, 255, 1);
  color = color ?? Color.fromRGBO(242, 248, 255, 1);
  var popup = Popup(
    child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(12),
        child: Text(message,
            style: TextStyle(
              fontSize: 12,
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
