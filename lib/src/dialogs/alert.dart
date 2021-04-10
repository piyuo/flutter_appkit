import 'dart:ui';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:libcli/src/i18n/i18n.dart';
import 'package:libcli/src/eventbus/eventbus.dart' as eventbus;
import 'package:libcli/widgets.dart';

final keyAlertButtonYes = Key('alertBtnYes');

final keyAlertButtonNo = Key('alertBtnNo');

final keyAlertButtonCancel = Key('alertBtnCancel');

Widget showIcon(IconData? icon, Color iconColor, bool warning, Widget? iconWidget) {
  if (iconWidget != null) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20),
      child: iconWidget,
    );
  }

  if (warning) {
    icon = Icons.warning_amber_rounded;
  }

  if (icon != null) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20),
      child: Icon(
        icon,
        color: iconColor,
        size: 58,
      ),
    );
  }
  return SizedBox();
}

Widget showButton(
  BuildContext context,
  Key key,
  String? text,
  Color color,
  Color textColor,
  bool? value,
) {
  return text != null
      ? Container(
          margin: EdgeInsets.only(bottom: 10),
          width: double.infinity,
          height: 28,
          child: RaisedButton(
            elevation: 1,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
            color: color,
            textColor: textColor,
            key: key,
            child: Text(text),
            onPressed: () => Navigator.of(context).pop(value),
          ),
        )
      : SizedBox();
}

Widget showTitle(String? title) {
  return title != null
      ? Container(
          padding: EdgeInsets.only(bottom: 10),
          alignment: Alignment.center,
          child:
              Text(title, textAlign: TextAlign.center, style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600)),
        )
      : SizedBox();
}

Widget showMessage(String message) {
  return Container(
    alignment: Alignment.center,
    padding: EdgeInsets.only(bottom: 10),
    child: Text(message, textAlign: TextAlign.center, style: TextStyle(fontSize: 13.0)),
  );
}

Widget showFooter(String? footer) {
  return footer != null
      ? Container(
          alignment: Alignment.center,
          padding: EdgeInsets.only(bottom: 10),
          child: Text(footer, textAlign: TextAlign.center, style: TextStyle(fontSize: 13.0, color: Colors.grey[600])),
        )
      : SizedBox();
}

Widget showEmailUs(BuildContext context, bool emailUs) {
  var onTap = () => eventbus.broadcast(context, eventbus.EmailSupportEvent());
  return emailUs
      ? Container(
          padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: onTap,
                child: Icon(
                  Icons.mail_outline,
                  color: Colors.blueAccent,
                  size: 18,
                ),
              ),
              SizedBox(width: 10),
              InkWell(
                  child: GestureDetector(
                      onTap: onTap,
                      child: Text(
                        'emailUs'.i18n_,
                        style: TextStyle(fontSize: 13, color: Colors.blueAccent),
                      ))),
            ],
          ))
      : SizedBox();
}

/// alert show alert dialog, return true if it's ok or yes
///
Future<bool?> alert(
  BuildContext context,
  String message, {
  bool warning = false,
  IconData? icon,
  Color iconColor = Colors.redAccent,
  Widget? iconWidget,
  String? title,
  String? footer,
  bool emailUs = false,
  String? yes,
  String? no,
  String? cancel,
  Color? assentButtonColor,
  Color? buttonColor,
  bool buttonOK = false,
  bool buttonCancel = false,
  bool buttonYes = false,
  bool buttonNo = false,
  bool buttonRetry = false,
  bool buttonSave = false,
  bool buttonClose = false,
}) async {
  bool isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
  assentButtonColor = assentButtonColor ?? Color(0xee2091eb);
  buttonColor = buttonColor ?? (isDark ? Color(0xcc6a7073) : Color(0xeebbbcbb));
  if (buttonOK) {
    yes = 'ok'.i18n_;
  }
  if (buttonCancel) {
    cancel = 'cancel'.i18n_;
  }
  if (buttonYes) {
    yes = 'yes'.i18n_;
  }
  if (buttonNo) {
    no = 'no'.i18n_;
  }
  if (buttonRetry) {
    yes = 'retry'.i18n_;
  }
  if (buttonSave) {
    yes = 'save'.i18n_;
  }
  if (buttonClose) {
    cancel = 'close'.i18n_;
  }
  if (yes == null && no == null && cancel == null) {
    cancel = 'close'.i18n_;
  }
  return await showDialog<bool?>(
      context: context,
      barrierColor: isDark ? Color.fromRGBO(25, 25, 28, 0.6) : Color.fromRGBO(230, 230, 238, 0.6),
      barrierDismissible: false,
      builder: (BuildContext ctx) {
        return Dialog(
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: BlurryContainer(
            shadow: isDark
                ? BoxShadow(
                    color: Color(0x66000011),
                    blurRadius: 15,
                    spreadRadius: 8,
                    offset: Offset(0, 15),
                  )
                : BoxShadow(
                    color: Color(0x66bbbbcc),
                    blurRadius: 15,
                    spreadRadius: 8,
                    offset: Offset(0, 10),
                  ),
            padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: isDark ? Colors.white24 : Colors.black26),
            backgroundColor: isDark ? Color.fromRGBO(75, 75, 78, 0.5) : Color.fromRGBO(252, 252, 255, 0.4),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: 240,
                maxWidth: 260,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  showIcon(icon, iconColor, warning, iconWidget),
                  Container(
                    height: 90,
                    child: SingleChildScrollView(
                      child: ListBody(
                        children: <Widget>[
                          showTitle(title),
                          showMessage(message),
                          showFooter(footer),
                        ],
                      ),
                    ),
                  ),
                  showButton(
                    context,
                    keyAlertButtonYes,
                    yes,
                    assentButtonColor!,
                    Colors.white,
                    true,
                  ),
                  showButton(
                    context,
                    keyAlertButtonNo,
                    no,
                    buttonColor!,
                    isDark ? Colors.blue[50]! : Colors.black54,
                    false,
                  ),
                  SizedBox(height: 10),
                  showButton(
                    context,
                    keyAlertButtonCancel,
                    cancel,
                    yes != null ? buttonColor : assentButtonColor,
                    yes != null
                        ? isDark
                            ? Colors.blue[50]!
                            : Colors.black54
                        : Colors.white,
                    null,
                  ),
                  showEmailUs(context, emailUs),
                ],
              ),
            ),
          ),
        );
      });
}
