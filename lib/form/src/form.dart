import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:libcli/dialog/dialog.dart' as dialog;
import 'package:libcli/i18n/i18n.dart' as i18n;
import 'submit.dart';

/// allowToExit is true mean form can exit
Future<bool> isAllowToExit(
  BuildContext context, {
  required FormGroup formGroup,
  required Future<void> Function() submitCallback,
}) async {
  if (formGroup.dirty) {
    var result = await dialog.alert(context, context.i18n.formContentChangedText,
        buttonYes: true, buttonNo: true, buttonCancel: true, blurry: false);
    if (result == true) {
      // user want save
      bool ok = await submit(context, formGroup: formGroup, callback: submitCallback);
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
