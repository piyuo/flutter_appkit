import 'package:flutter/material.dart';
import 'package:libcli/dialog/dialog.dart' as dialog;
import 'package:libcli/general/general.dart' as general;
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
    this.showToastWait = true,
    this.showToastDone = true,
    this.onlySubmitOnDirty = true,
    Key? key, // all submit must have key, it's important for test and identify field
  }) : super(key: key);

  /// padding is button padding
  final EdgeInsets padding;

  /// fontSize is button font size
  final double fontSize;

  /// child is button text
  final Widget? child;

  /// onSubmit called when user pressed button to submit form, return true will show done animation
  final general.FutureContextCallback<bool>? onSubmit;

  /// showToastWait show wait toast when submit
  final bool showToastWait;

  /// showToastDone show toast done after submit
  final bool showToastDone;

  /// onlySubmitOnDirty is true will only submit when form is dirty
  final bool onlySubmitOnDirty;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return ReactiveFormConsumer(
      builder: (context, formGroup, _) {
        bool valid = formGroup.valid;
        if (onlySubmitOnDirty) {
          valid = valid && formGroup.dirty;
        }
        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: colorScheme.secondary.withOpacity(valid ? 1 : .3),
            foregroundColor: colorScheme.onSecondary.withOpacity(valid ? 1 : .8),
            elevation: valid ? null : 0,
            padding: padding,
          ),
          onPressed: onSubmit != null && formGroup.enabled
              ? () => submit(
                    formGroup: formGroup,
                    callback: onSubmit!,
                    showWait: showToastWait,
                    showDone: showToastDone,
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
    dialog.showTextBanner(delta.i18n.formSavedBanner);
    return false;
  }
  if (!formGroup.valid) {
    dialog.showErrorBanner(
      delta.i18n.formAttentionBanner,
    );
    formGroup.markAllAsTouched();
    return false;
  }
  return true;
}

/// submit form, return true if form is submitted
Future<bool> submit({
  required FormGroup formGroup,
  required general.FutureContextCallback<bool> callback,
  bool showWait = true,
  bool showDone = true,
}) async {
  if (!formGroup.valid) {
    formGroup.markAllAsTouched();
    return false;
  }

  bool result = false;
  if (showWait) dialog.toastWait();
  try {
    formGroup.markAsDisabled();
    result = await callback.call(delta.globalContext);
    return result;
  } finally {
    formGroup.markAsEnabled();
    formGroup.markAsPristine();
    if (showDone) {
      dialog.toastDone();
    } else {
      dialog.dismissToast();
    }
  }
}

/// isAllowToExit is true mean form can exit
Future<bool> isAllowToExit({
  required FormGroup formGroup,
  required general.FutureContextCallback<bool> submitCallback,
}) async {
  if (formGroup.dirty) {
    var result = await dialog.show(
      textContent: delta.i18n.formContentChangedText,
      type: dialog.DialogButtonsType.yesNoCancel,
    );
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
