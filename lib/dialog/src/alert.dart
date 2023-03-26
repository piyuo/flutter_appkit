import 'dart:ui';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:libcli/i18n/i18n.dart' as i18n;
import 'package:libcli/delta/delta.dart' as delta;

bool _disableAlert = false;

/// disable alert when testing
@visibleForTesting
void disableAlert() {
  _disableAlert = true;
}

/// show dialog, return true if it's ok or yes
/// ```dart
/// show(content:Text('hi'), warning: true)
/// ```
Future<bool?> show({
  Widget? content,
  Widget? footer,
  String? textContent,
  IconData? icon,
  Color? iconColor,
  String? title,
  bool warning = false,
  String? yes,
  String? no,
  String? cancel,
  bool showOK = false,
  bool showCancel = false,
  bool showYes = false,
  bool showNo = false,
  bool showRetry = false,
  bool showSave = false,
  bool showClose = false,
  bool barrierDismissible = true,
  bool keyboardFocus = true,
  Key? keyYes,
  Key? keyNo,
  Key? keyCancel,
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
      barrierDismissible: barrierDismissible,
      builder: (BuildContext context) {
        Widget createButton(Key? key, String text, bool autofocus, bool? value) {
          return SizedBox(
            width: double.infinity,
            height: 42,
            child: ElevatedButton(
              autofocus: keyboardFocus && autofocus,
              style: ElevatedButton.styleFrom(backgroundColor: warning ? Theme.of(context).colorScheme.error : null),
              onPressed: () => Navigator.of(delta.globalContext).pop(value),
              key: key,
              child: Text(text, style: warning ? TextStyle(color: Theme.of(context).colorScheme.onError) : null),
            ),
          );
        }

        return Dialog(
          elevation: 2,
          backgroundColor: Colors.transparent,
          child: BlurryContainer(
            blur: barrierDismissible ? 0 : 8,
            shadow: BoxShadow(
              color: Theme.of(context).shadowColor,
              blurRadius: 2,
              spreadRadius: 1,
              offset: const Offset(1, 1),
            ),
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Theme.of(context).dialogBackgroundColor),
            backgroundColor: Theme.of(context).dialogBackgroundColor.withOpacity(.9),
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
                  ]),
                  if (yes != null) const SizedBox(height: 20),
                  if (yes != null) createButton(keyYes, yes, true, true),
                  if (no != null) const SizedBox(height: 9),
                  if (no != null) createButton(keyNo, no, false, false),
                  if (cancel != null) const SizedBox(height: 9),
                  if (cancel != null) createButton(keyCancel, cancel, yes == null, null),
                  if (footer != null) footer,
/*                  if (emailUs)
                    Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                        child: TextButton(
                          child: Text(context.i18n.errorEmailUsLink),
                          onPressed: () => eventbus.broadcast(app.EmailSupportEvent()),
                        )),*/
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
  Key? keyYes,
  Key? keyNo,
  Key? keyCancel,
}) async {
  return show(
    textContent: message,
    icon: icon,
    title: title,
    showOK: showOK,
    showCancel: showCancel,
    warning: warning,
    keyYes: keyYes,
    keyNo: keyNo,
    keyCancel: keyCancel,
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

/// BlurryContainer is container support blurry
class BlurryContainer extends StatelessWidget {
  const BlurryContainer({
    Key? key,
    required this.child,
    this.blur = 8,
    this.height,
    this.width,
    this.padding,
    this.backgroundColor,
    this.shadow,
    this.border,
    this.borderRadius = const BorderRadius.all(Radius.circular(20)),
  }) : super(key: key);

  final Widget child;

  final double blur;

  final double? height, width;

  final EdgeInsetsGeometry? padding;

  final Color? backgroundColor;

  final BoxShadow? shadow;

  final Border? border;

  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    final container = Container(
      decoration: BoxDecoration(
        border: border,
        borderRadius: borderRadius,
        color: backgroundColor,
        boxShadow: shadow != null ? [shadow!] : null,
      ),
      height: height,
      width: width,
      padding: padding,
      child: child,
    );

    return blur > 0
        ? BackdropFilter(filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur), child: container)
        : container;
  }
}
