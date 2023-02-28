import 'package:flutter/material.dart';
import 'package:libcli/dialog/dialog.dart' as dialog;
import 'package:libcli/delta/delta.dart' as delta;
import 'package:libcli/i18n/i18n.dart' as i18n;
import 'package:reactive_forms/reactive_forms.dart';

/// Submit is form submit button
class Submit extends StatelessWidget {
  const Submit({
    this.child,
    this.onSubmit,
    this.fontSize = 16,
    this.padding = const EdgeInsets.symmetric(horizontal: 38, vertical: 10),
    this.elevation = 2,
    this.showToast = true,
    this.onlySubmitOnDirty = true,
    this.color,
    Key? key, // all submit must have key, it's important for test and identify field
  }) : super(key: key);

  /// padding is button padding
  final EdgeInsets padding;

  /// fontSize is button font size
  final double fontSize;

  /// child is button text
  final Widget? child;

  /// onSubmit called when user pressed button to submit form, return true will show done animation
  final delta.FutureContextCallback<bool>? onSubmit;

  /// button elevation, if elevation is 0 use outlined button
  final double elevation;

  /// color is text and outline color
  final Color? color;

  /// show toast is true will show toast on submit
  final bool showToast;

  /// onlySubmitOnDirty is true will only submit when form is dirty
  final bool onlySubmitOnDirty;

  @override
  Widget build(BuildContext context) {
    return ReactiveFormConsumer(
      builder: (context, formGroup, _) {
        bool valid = formGroup.valid;
        if (onlySubmitOnDirty) {
          valid = valid && formGroup.dirty;
        }
        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: valid
                ? color
                : context.themeColor(
                    light: Colors.grey.shade300,
                    dark: Colors.grey.shade800,
                  ),
            foregroundColor: valid ? null : Colors.grey.shade500,
            elevation: valid ? elevation : 0,
            padding: padding,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
          ),
          onPressed: onSubmit != null && formGroup.enabled
              ? () => submit(
                    formGroup: formGroup,
                    callback: onSubmit!,
                    showToast: showToast,
                  )
              : null,
          child: child ??
              Text(
                context.i18n.formSubmitButtonText,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: fontSize,
                ),
              ),
        );
      },
    );
  }
}

/// validate form and show error message to user
bool validate(
  FormGroup formGroup,
) {
  if (!formGroup.dirty && formGroup.valid) {
    dialog.showInfoBanner(delta.globalContext.i18n.formSavedBanner);
    return false;
  }
  if (!formGroup.valid) {
    dialog.showWarningBanner(
      delta.globalContext.i18n.formAttentionBanner,
      backgroundColor: Colors.red.shade400,
      color: Colors.white,
    );
    formGroup.markAllAsTouched();
    return false;
  }
  return true;
}

/// submit form, return true if form is submitted
Future<bool> submit({
  required FormGroup formGroup,
  required delta.FutureContextCallback<bool> callback,
  bool showToast = true,
}) async {
  if (!formGroup.valid) {
    formGroup.markAllAsTouched();
    return false;
  }

  bool result = false;
  if (showToast) dialog.toastWait();
  try {
    formGroup.markAsDisabled();
    result = await callback.call(delta.globalContext);
    return result;
  } finally {
    formGroup.markAsEnabled();
    formGroup.markAsPristine();
    if (showToast) dialog.toastDone();
  }
}

/// isAllowToExit is true mean form can exit
Future<bool> isAllowToExit({
  required FormGroup formGroup,
  required delta.FutureContextCallback<bool> submitCallback,
}) async {
  if (formGroup.dirty) {
    var result = await dialog.show(
        textContent: delta.globalContext.i18n.formContentChangedText,
        showYes: true,
        showNo: true,
        showCancel: true,
        blurry: false);
    if (result == true) {
      // user want save
      bool ok = await submit(formGroup: formGroup, callback: submitCallback);
      if (!ok) {
        return false;
      }
    } else if (result == false) {
      // discard content
      formGroup.reset();
    } else if (result == null) {
      return false;
    }
  }
  return true;
}
