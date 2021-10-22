import 'dart:core';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:libcli/dialog/dialog.dart' as dialog;
import 'l10n.dart';

Future<bool> checkCameraPermission(BuildContext context) async {
  if (kIsWeb) {
    dialog.alert(
      context,
      'webCamera'.l10n,
      warning: true,
    );
    return false;
  }

  var status = await Permission.camera.status;
  if (status.isGranted) {
    return true;
  }

  if (await Permission.camera.request().isGranted) {
    return true;
  }

  final gotoSetting = await dialog.alert(
    context,
    'appSetting'.l10n,
    warning: true,
    yes: 'gotoSetting'.l10n,
    buttonYes: true,
    buttonCancel: true,
  );
  if (gotoSetting == true) {
    openAppSettings();
  }
  return false;
}
