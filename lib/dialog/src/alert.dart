import 'dart:async';
import 'package:flutter/services.dart';
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

/// emailUsLink show link to email us
/// ```dart
/// emailUsLink(context);
/// ```
Widget emailUsLink(BuildContext context) => InkWell(
      onTap: () => eventbus.broadcast(eventbus.EmailSupportEvent()),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.email,
            color: Colors.blueAccent,
            size: 18,
          ),
          const SizedBox(width: 10),
          Text(
            context.i18n.errorEmailUsLink,
            style: const TextStyle(fontSize: 16, color: Colors.blueAccent),
          ),
        ],
      ),
    );

/// show dialog, return true if it's ok or yes
/// ```dart
/// show(content:Text('hi'), warning: true)
/// ```
Future<bool?> show({
  Widget? content,
  String? textContent,
  IconData? icon,
  Color? iconColor,
  String? title,
  String? footer,
  bool warning = false,
  bool emailUs = false,
  String? yes,
  String? no,
  String? cancel,
  Color? assentButtonColor,
  Color? buttonColor,
  bool showOK = false,
  bool showCancel = false,
  bool showYes = false,
  bool showNo = false,
  bool showRetry = false,
  bool showSave = false,
  bool showClose = false,
  bool blurry = true,
  bool keyboardFocus = true,
}) async {
  assert(content != null || textContent != null, 'must have content or textContent');
  if (!kReleaseMode && _disableAlert) {
    return null;
  }

  content = content ??
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Text(
          textContent!,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 17),
        ),
      );

  Widget createButton(Key key, String text, Color color, Color textColor, bool autofocus, bool? value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      width: double.infinity,
      height: 42,
      child: ElevatedButton(
        autofocus: keyboardFocus && autofocus,
        style: ElevatedButton.styleFrom(
          elevation: 1,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
          backgroundColor: color,
          textStyle: TextStyle(color: color),
        ),
        key: key,
        child: Text(text),
        onPressed: () => Navigator.of(delta.globalContext).pop(value),
      ),
    );
  }

  assentButtonColor = assentButtonColor ?? (warning ? Colors.red.shade400 : Colors.blue.shade700);
  buttonColor = buttonColor ??
      delta.globalContext.themeColor(
        dark: const Color(0xcc6a7073),
        light: Colors.grey,
      );
  if (showOK) {
    yes = delta.globalContext.i18n.okButtonText;
  }
  if (showCancel) {
    cancel = delta.globalContext.i18n.cancelButtonText;
  }
  if (showYes) {
    yes = delta.globalContext.i18n.yesButtonText;
  }
  if (showNo) {
    no = delta.globalContext.i18n.noButtonText;
  }
  if (showRetry) {
    yes = delta.globalContext.i18n.retryButtonText;
  }
  if (showSave) {
    yes = delta.globalContext.i18n.saveButtonText;
  }
  if (showClose) {
    cancel = delta.globalContext.i18n.closeButtonText;
  }
  if (yes == null && no == null && cancel == null) {
    cancel = delta.globalContext.i18n.closeButtonText;
  }

  return await showDialog<bool?>(
      context: delta.globalContext,
      barrierColor: delta.globalContext
          .themeColor(dark: const Color.fromRGBO(25, 25, 28, 0.6), light: const Color.fromRGBO(230, 230, 238, 0.6)),
      //barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          elevation: 2,
          backgroundColor: Colors.transparent,
          child: BlurryContainer(
            enableBlurry: blurry,
            shadow: BoxShadow(
              color: context.themeColor(
                  dark: const Color.fromARGB(51, 0, 0, 17), light: const Color.fromARGB(102, 117, 117, 118)),
              blurRadius: 5,
              spreadRadius: 3,
              offset: const Offset(2, 2),
            ),
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: context.themeColor(dark: Colors.white24, light: Colors.black26),
            ),
            backgroundColor: context.themeColor(
                dark: const Color.fromRGBO(75, 75, 78, 0.85), light: const Color.fromRGBO(252, 252, 255, 0.85)),
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
                  Column(children: [
                    if (title != null)
                      Align(
                        alignment: Alignment.center,
                        child: Text(title,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600)),
                      ),
                    content!,
                    if (footer != null)
                      Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Text(footer,
                            textAlign: TextAlign.center, style: TextStyle(fontSize: 16.0, color: Colors.grey[600])),
                      )
                  ]),
                  if (yes != null) const SizedBox(height: 20),
                  if (yes != null) createButton(keyAlertButtonYes, yes, assentButtonColor!, Colors.white, true, true),
                  if (no != null)
                    createButton(keyAlertButtonNo, no, buttonColor!,
                        context.themeColor(dark: Colors.blue.shade50, light: Colors.black54), false, false),
                  if (cancel != null) const SizedBox(height: 10),
                  if (cancel != null)
                    createButton(
                        keyAlertButtonCancel,
                        cancel,
                        yes != null ? buttonColor! : assentButtonColor!,
                        yes != null
                            ? context.themeColor(dark: Colors.blue.shade50, light: Colors.black54)
                            : Colors.white,
                        yes == null,
                        null),
                  if (emailUs) Container(padding: const EdgeInsets.fromLTRB(0, 10, 0, 10), child: emailUsLink(context)),
                ],
              ),
            ),
          ),
        );
      });
}

/// alert show text dialog, return true if it's ok
Future<bool?> alert(
  String message, {
  IconData? icon,
  String? title,
  bool showOK = true,
  bool showCancel = false,
  bool warning = false,
  bool emailUs = false,
  bool blurry = true,
}) async {
  /*
  Align(
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30),
        child: Text(message, textAlign: TextAlign.center, style: const TextStyle(fontSize: 17.0)),
      ),
    )*/
  return show(
    textContent: message,
    icon: icon,
    title: title,
    showOK: showOK,
    showCancel: showCancel,
    warning: warning,
    emailUs: emailUs,
    blurry: blurry,
  );
}

/// confirm show on/cancel dialog, return true if it's ok
Future<bool?> confirm(
  String message, {
  IconData? icon,
  String? title,
  bool showOK = true,
  bool showCancel = true,
}) async {
  return alert(
    message,
    icon: icon,
    title: title,
    showOK: showOK,
    showCancel: showCancel,
  );
}

/// prompt let user input text, return true if it's ok
Future<String?> prompt({
  String? label,
  String? initialValue,
  int? maxLength,
  TextInputType? keyboardType,
  TextInputAction textInputAction = TextInputAction.done,
  List<TextInputFormatter>? inputFormatters,
}) async {
  final controller = TextEditingController(text: initialValue);
  final result = await show(
    content: TextField(
      inputFormatters: inputFormatters,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      autofocus: true,
      controller: controller,
      maxLength: maxLength,
      onSubmitted: (newText) {
        if (newText.isNotEmpty) {
          Navigator.of(delta.globalContext).pop(true);
        }
      },
      decoration: InputDecoration(
        labelText: label,
        counterText: '',
      ),
    ),
    keyboardFocus: false,
    showOK: true,
  );
  if (result == true) {
    return controller.text;
  }
  return null;
}

/// promptInt let user input integer, return true if it's ok
Future<int?> promptInt({
  String? label,
  int? initialValue,
  int? maxLength,
}) async {
  final result = await prompt(
    label: label,
    initialValue: initialValue?.toString(),
    maxLength: maxLength,
    keyboardType: TextInputType.number,
    inputFormatters: [
      FilteringTextInputFormatter.digitsOnly,
    ],
  );
  return result == null ? null : int.tryParse(result);
}
