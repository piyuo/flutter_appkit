import 'dart:async';
import 'package:flutter/material.dart';
import 'package:libcli/i18n.dart';
import 'package:libcli/eventbus.dart';

const double _DIALOG_WIDTH = 180;
const double _DIALOG_HEIGHT = 360;

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

Widget? showIcon(IconData? icon, Color iconColor, bool warning, Widget? iconWidget) {
  if (iconWidget != null) {
    return iconWidget;
  }

  if (warning) {
    icon = Icons.warning_amber_rounded;
  }

  if (icon != null) {
    return Icon(
      icon,
      color: iconColor,
      size: 38,
    );
  }
  return null;
}

/// alert show alert dialog, return true if it's ok or yes
///
Future<bool> alert(
  BuildContext context,
  String message, {
  bool warning = true,
  IconData? icon,
  Color iconColor = Colors.redAccent,
  Widget? iconWidget,
  String? title,
  String? footer,
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
          //title: title != null ? Text(title) : null,
          title: showIcon(icon, iconColor, warning, iconWidget),
          content: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: _DIALOG_WIDTH,
              maxHeight: _DIALOG_HEIGHT,
            ),
            child: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  title != null
                      ? Text(title, style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600, color: Colors.grey))
                      : SizedBox(),
                  SizedBox(height: 10),
                  Text(message, style: TextStyle(fontSize: 14.0)),
                  SizedBox(height: 20),
                  footer != null ? Text(footer, style: TextStyle(fontSize: 13.0, color: Colors.grey)) : SizedBox(),
                  SizedBox(height: 10),
                  emailUs == true ? _emailUs(() => broadcast(context, EmailSupportEvent())) : SizedBox(),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            RaisedButton(
              key: keyAlertButtonFalse,
              textTheme: ButtonTextTheme.accent,
              child: Text(_falseButtonText(buttonType, labelFalse)),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            buttonType == ButtonType.close
                ? SizedBox()
                : RaisedButton(
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
