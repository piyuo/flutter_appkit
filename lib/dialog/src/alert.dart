import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:libcli/i18n/i18n.dart' as i18n;
import 'package:libcli/eventbus/eventbus.dart' as eventbus;
import 'package:libcli/delta/delta.dart' as delta;
import 'blurry_container.dart';

const keyAlertButtonYes = Key('alertBtnYes');

const keyAlertButtonNo = Key('alertBtnNo');

const keyAlertButtonCancel = Key('alertBtnCancel');

bool _disableAlert = false;

/// disable alert when testing
@visibleForTesting
void disableAlert() {
  _disableAlert = true;
}

/// alert show alert dialog, return true if it's ok or yes
///
Future<bool?> alert(
  BuildContext context,
  String message, {
  bool warning = false,
  IconData? icon,
  Color? iconColor,
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
  if (!kReleaseMode && _disableAlert) {
    return null;
  }

  Widget _showButton(
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
              onPressed: () {
                Navigator.of(context).pop(value);
              },
            ),
          )
        : const SizedBox();
  }

  Widget _showTitle() {
    return title != null
        ? Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.only(bottom: 20),
            child: Text(title,
                textAlign: TextAlign.center, style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600)),
          )
        : const SizedBox();
  }

  Widget _showMessage(bool titleExists) {
    return Container(
      alignment: Alignment.center,
      padding: titleExists ? const EdgeInsets.only(bottom: 30) : const EdgeInsets.symmetric(vertical: 30),
      child: Text(message, textAlign: TextAlign.center, style: const TextStyle(fontSize: 17.0)),
    );
  }

  Widget _showFooter() {
    return footer != null
        ? Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.only(bottom: 10),
            child: Text(footer, textAlign: TextAlign.center, style: TextStyle(fontSize: 16.0, color: Colors.grey[600])),
          )
        : const SizedBox();
  }

  assentButtonColor = assentButtonColor ?? (warning ? Colors.red.shade400 : const Color(0xee2091eb));
  buttonColor = buttonColor ??
      context.themeColor(
        dark: const Color(0xcc6a7073),
        light: Colors.grey,
      );
  if (buttonOK) {
    yes = context.i18n.okButtonText;
  }
  if (buttonCancel) {
    cancel = context.i18n.cancelButtonText;
  }
  if (buttonYes) {
    yes = context.i18n.yesButtonText;
  }
  if (buttonNo) {
    no = context.i18n.noButtonText;
  }
  if (buttonRetry) {
    yes = context.i18n.retryButtonText;
  }
  if (buttonSave) {
    yes = context.i18n.saveButtonText;
  }
  if (buttonClose) {
    cancel = context.i18n.closeButtonText;
  }
  if (yes == null && no == null && cancel == null) {
    cancel = context.i18n.closeButtonText;
  }
  return await showDialog<bool?>(
      context: context,
      barrierColor: context.themeColor(
          dark: const Color.fromRGBO(25, 25, 28, 0.6), light: const Color.fromRGBO(230, 230, 238, 0.6)),
      barrierDismissible: false,
      builder: (BuildContext ctx) {
        return Dialog(
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: BlurryContainer(
            enableBlurry: false,
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
                  if (icon != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Icon(
                        icon,
                        color: iconColor,
                        size: 64,
                      ),
                    ),
                  scrollContent
                      ? SizedBox(
                          height: 200,
                          child: SingleChildScrollView(
                            child: ListBody(
                              children: <Widget>[
                                _showTitle(),
                                _showMessage(title != null || icon != null || warning),
                                _showFooter(),
                              ],
                            ),
                          ),
                        )
                      : Column(children: [
                          _showTitle(),
                          _showMessage(title != null || icon != null || warning),
                          _showFooter(),
                        ]),
                  _showButton(
                    keyAlertButtonYes,
                    yes,
                    assentButtonColor!,
                    Colors.white,
                    true,
                  ),
                  _showButton(
                    keyAlertButtonNo,
                    no,
                    buttonColor!,
                    context.themeColor(dark: Colors.blue.shade50, light: Colors.black54),
                    false,
                  ),
                  const SizedBox(height: 10),
                  _showButton(
                    keyAlertButtonCancel,
                    cancel,
                    yes != null ? buttonColor : assentButtonColor,
                    yes != null ? context.themeColor(dark: Colors.blue.shade50, light: Colors.black54) : Colors.white,
                    null,
                  ),
                  if (emailUs)
                    Container(
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () => eventbus.broadcast(context, eventbus.EmailSupportEvent()),
                              child: const Icon(
                                Icons.email,
                                color: Colors.blueAccent,
                                size: 18,
                              ),
                            ),
                            const SizedBox(width: 10),
                            InkWell(
                                child: GestureDetector(
                                    onTap: () => eventbus.broadcast(context, eventbus.EmailSupportEvent()),
                                    child: Text(
                                      context.i18n.errorEmailUsLink,
                                      style: const TextStyle(fontSize: 16, color: Colors.blueAccent),
                                    ))),
                          ],
                        )),
                ],
              ),
            ),
          ),
        );
      });
}

/// confirm show on/cancel dialog, return true if it's ok
///
Future<bool?> confirm(
  BuildContext context,
  String message, {
  IconData? icon,
  Color iconColor = const Color.fromRGBO(239, 91, 93, 1),
  String? title,
  bool buttonOK = true,
  bool buttonCancel = true,
}) async {
  return alert(
    context,
    message,
    icon: icon,
    iconColor: iconColor,
    title: title,
    buttonOK: buttonOK,
    buttonCancel: buttonCancel,
  );
}
