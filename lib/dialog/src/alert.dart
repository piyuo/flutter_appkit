import 'dart:ui';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:libcli/i18n/i18n.dart' as i18n;
import 'package:libcli/delta/delta.dart' as delta;

/// _disableAlert is used for testing
bool _disableAlert = false;

/// disable alert when testing
@visibleForTesting
void disableAlert() {
  _disableAlert = true;
}

enum DialogButtonType { yes, yesNo, yesNoCancel, cancel }

/// show dialog, return true if it's ok or yes. set isError to true to show error dialog
/// ```dart
/// show(content:Text('hi'), warning: true)
/// ```
Future<bool?> show({
  Widget? content,
  Widget? footer,
  String? textContent,
  Widget? icon,
  String? title,
  bool isError = false,
  String? yesText,
  String? noText,
  String? cancelText,
  DialogButtonType type = DialogButtonType.yes,
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

  final colorScheme = Theme.of(delta.globalContext).colorScheme;
  return await showDialog<bool?>(
      context: delta.globalContext,
      barrierDismissible: barrierDismissible,
      builder: (BuildContext context) {
        Widget createButton(Key? key, String text, bool autofocus, bool? value) {
          return Padding(
              padding: const EdgeInsets.only(top: 9),
              child: SizedBox(
                width: double.infinity,
                height: 42,
                child: ElevatedButton(
                  autofocus: keyboardFocus && autofocus,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isError
                        ? value == true
                            ? colorScheme.errorContainer
                            : colorScheme.error
                        : null,
                  ),
                  onPressed: () => Navigator.of(delta.globalContext).pop(value),
                  key: key,
                  child: Text(text,
                      style: isError
                          ? TextStyle(
                              color: value == true ? colorScheme.onErrorContainer : colorScheme.onError,
                            )
                          : null),
                ),
              ));
        }

        buttonsBuilder() {
          switch (type) {
            case DialogButtonType.yes:
              return [createButton(keyYes, yesText ?? context.i18n.okButtonText, true, true)];
            case DialogButtonType.yesNo:
              return [
                createButton(keyYes, yesText ?? context.i18n.yesButtonText, true, true),
                createButton(keyNo, noText ?? context.i18n.noButtonText, false, false),
              ];
            case DialogButtonType.yesNoCancel:
              return [
                createButton(keyYes, yesText ?? context.i18n.yesButtonText, true, true),
                createButton(keyNo, noText ?? context.i18n.noButtonText, false, false),
                createButton(keyCancel, cancelText ?? context.i18n.cancelButtonText, false, null),
              ];
            case DialogButtonType.cancel:
              return [createButton(keyCancel, cancelText ?? context.i18n.cancelButtonText, true, null)];
          }
        }

        content = content ??
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text(
                textContent!,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: isError ? colorScheme.onError : null),
              ),
            );

        final backgroundColor = isError ? colorScheme.error : Theme.of(context).dialogBackgroundColor;

        final dialog = Dialog(
          elevation: 2,
          backgroundColor: Colors.transparent,
          child: BlurryContainer(
            blur: barrierDismissible ? 0 : 8,
            shadow: isError
                ? null
                : BoxShadow(
                    color: Theme.of(context).shadowColor,
                    blurRadius: 2,
                    spreadRadius: 1,
                    offset: const Offset(1, 1),
                  ),
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
            borderRadius: BorderRadius.circular(20),
            //border: Border.all(color: backgroundColor),
            backgroundColor: backgroundColor.withOpacity(.9),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                minWidth: 240,
                maxWidth: 360,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) icon,
                  if (title != null)
                    Text(title,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(color: isError ? colorScheme.onError : null)),
                  const SizedBox(height: 10),
                  content!,
                  const SizedBox(height: 10),
                  ...buttonsBuilder(),
                  if (footer != null) footer,
                ],
              ),
            ),
          ),
        );

        return isError
            ? Theme(
                data: Theme.of(context).copyWith(colorScheme: colorScheme.copyWith(primary: colorScheme.error)),
                child: dialog, // Takes the theme of its direct parent
              )
            : dialog;
      });
}

/// alert show text dialog, return true if it's ok
Future<bool?> alert(
  String message, {
  Widget? icon,
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
    isError: warning,
    keyYes: keyYes,
    keyNo: keyNo,
    keyCancel: keyCancel,
  );
}

/// confirm show on/cancel dialog, return true if it's ok
Future<bool?> confirm(
  String message, {
  Widget? icon,
  String? title,
  bool showOK = true,
  bool showCancel = true,
}) async {
  return show(
    textContent: message,
    icon: icon,
    title: title,
    type: DialogButtonType.yesNo,
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
    type: DialogButtonType.yes,
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
