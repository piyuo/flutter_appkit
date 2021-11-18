import 'dart:core';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:libcli/dialog/dialog.dart' as dialog;
import 'package:libcli/delta/delta.dart' as delta;
import 'package:libcli/i18n/i18n.dart' as i18n;

/// askPermission return true if user grant permission
Future<bool> ask(
  BuildContext context, {
  required Permission permission,
  required String name,
  required IconData icon,
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

  final request = await permission.request();
  final granted = request.isGranted;
  if (granted) {
    return true;
  }

  final gotoSetting = await dialog.alert(
    context,
    context.i18n.permissionAsk.replaceAll('%1', name),
    icon: icon,
    iconColor: context.themeColor(
      light: Colors.grey[900]!,
      dark: Colors.grey[100]!,
    ),
    yes: context.i18n.permissionGotoSetting,
    buttonCancel: true,
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
