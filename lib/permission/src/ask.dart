import 'dart:core';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:libcli/dialog/dialog.dart' as dialog;
import 'package:libcli/delta/delta.dart' as delta;
import 'package:libcli/i18n/i18n.dart' as i18n;

/// askPermission return true if user grant permission
Future<bool> ask({
  required Permission permission,
  required String name,
}) async {
  try {
    var status = await permission.status;
    if (status.isGranted) {
      return true;
    }
  } catch (e) {
    if (e is MissingPluginException) {
      return false;
    }
    rethrow;
  }

  final permissionStatus = await permission.request();
  final granted = permissionStatus.isGranted;
  if (granted) {
    return true;
  }

  final gotoSetting = await dialog.show(
    textContent: delta.globalContext.i18n.permissionAsk.replaceAll('%1', name),
    yes: delta.globalContext.i18n.permissionGotoSetting,
    showCancel: true,
  );
  if (gotoSetting == true) {
    openAppSettings();
  }
  return false;
}

/// openSettings open the app settings page.
///
/// Returns [true] if the app settings page could be opened, otherwise [false].
Future<bool> openSettings() => openAppSettings();
