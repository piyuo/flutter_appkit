import 'dart:ui';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:libcli/i18n.dart' as i18n;
import 'package:libcli/eventbus.dart' as eventbus;
import 'package:libcli/delta.dart' as delta;

const keyAlertButtonYes = Key('alertBtnYes');

const keyAlertButtonNo = Key('alertBtnNo');

const keyAlertButtonCancel = Key('alertBtnCancel');

Widget showIcon(IconData? icon, Color iconColor) {
  if (icon != null) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Icon(
        icon,
        color: iconColor,
        size: 64,
      ),
    );
  }
  return const SizedBox();
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
          margin: const EdgeInsets.only(bottom: 10),
          width: double.infinity,
          height: 42,
          child: ElevatedButton(
            style: ButtonStyle(
              elevation: MaterialStateProperty.all(1),
              shape: MaterialStateProperty.all(
                  const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0)))),
              backgroundColor: MaterialStateProperty.all(color),
              textStyle: MaterialStateProperty.all(TextStyle(color: color)),
            ),
            key: key,
            child: Text(text),
            onPressed: () => Navigator.of(context).pop(value),
          ),
        )
      : const SizedBox();
}

Widget showTitle(String? title) {
  return title != null
      ? Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.only(bottom: 20),
          child: Text(title,
              textAlign: TextAlign.center, style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600)),
        )
      : const SizedBox();
}

Widget showMessage(String message, bool titleExists) {
  return Container(
    alignment: Alignment.center,
    padding: titleExists ? const EdgeInsets.only(bottom: 30) : const EdgeInsets.symmetric(vertical: 30),
    child: Text(message, textAlign: TextAlign.center, style: const TextStyle(fontSize: 17.0)),
  );
}

Widget showFooter(String? footer) {
  return footer != null
      ? Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.only(bottom: 10),
          child: Text(footer, textAlign: TextAlign.center, style: TextStyle(fontSize: 16.0, color: Colors.grey[600])),
        )
      : const SizedBox();
}

Widget showEmailUs(BuildContext context, bool emailUs) {
  var onTap = () => eventbus.broadcast(context, eventbus.EmailSupportEvent());
  return emailUs
      ? Container(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: onTap,
                child: const Icon(
                  delta.CustomIcons.email,
                  color: Colors.blueAccent,
                  size: 18,
                ),
              ),
              const SizedBox(width: 10),
              InkWell(
                  child: GestureDetector(
                      onTap: onTap,
                      child: Text(
                        'emailUs'.i18n_,
                        style: const TextStyle(fontSize: 16, color: Colors.blueAccent),
                      ))),
            ],
          ))
      : const SizedBox();
}

/// alert show alert dialog, return true if it's ok or yes
///
Future<bool?> alert(
  BuildContext context,
  String message, {
  bool warning = false,
  IconData? icon,
  Color iconColor = const Color.fromRGBO(239, 91, 93, 1),
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
  bool scrollContent = false,
}) async {
  assentButtonColor = assentButtonColor ?? const Color(0xee2091eb);
  buttonColor = buttonColor ?? context.themeColor(dark: const Color(0xcc6a7073), light: const Color(0xeebbbcbb));
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
      barrierColor: context.themeColor(
          dark: const Color.fromRGBO(25, 25, 28, 0.6), light: const Color.fromRGBO(230, 230, 238, 0.6)),
      barrierDismissible: false,
      builder: (BuildContext ctx) {
        if (warning) {
          icon = delta.CustomIcons.errorOutline;
        }
        return Dialog(
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: delta.BlurryContainer(
            shadow: BoxShadow(
              color: context.themeColor(dark: const Color(0x66000011), light: const Color(0x66bbbbcc)),
              blurRadius: 15,
              spreadRadius: 8,
              offset: const Offset(0, 10),
            ),
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: context.themeColor(dark: Colors.white24, light: Colors.black26),
            ),
            backgroundColor: context.themeColor(
                dark: const Color.fromRGBO(75, 75, 78, 0.5), light: const Color.fromRGBO(252, 252, 255, 0.4)),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                minWidth: 240,
                maxWidth: 320,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  showIcon(icon, iconColor),
                  scrollContent
                      ? SizedBox(
                          height: 200,
                          child: SingleChildScrollView(
                            child: ListBody(
                              children: <Widget>[
                                showTitle(title),
                                showMessage(message, title != null || icon != null || warning),
                                showFooter(footer),
                              ],
                            ),
                          ),
                        )
                      : Column(children: [
                          showTitle(title),
                          showMessage(message, title != null || icon != null || warning),
                          showFooter(footer),
                        ]),
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
                    context.themeColor(dark: Colors.blue[50]!, light: Colors.black54),
                    false,
                  ),
                  const SizedBox(height: 10),
                  showButton(
                    context,
                    keyAlertButtonCancel,
                    cancel,
                    yes != null ? buttonColor : assentButtonColor,
                    yes != null ? context.themeColor(dark: Colors.blue[50]!, light: Colors.black54) : Colors.white,
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
