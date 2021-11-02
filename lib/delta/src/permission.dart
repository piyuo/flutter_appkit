import 'dart:core';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:libcli/dialog/dialog.dart' as dialog;
import 'l10n.dart';

/// askBluetoothPermission return true if user grant bluetooth permission
Future<bool> askBluetoothPermission(BuildContext context) => askPermission(
      context,
      permission: Permission.bluetooth,
      name: 'bluetooth'.l10n,
      icon: Icons.bluetooth,
      iconColor: Colors.blue,
      supportByWeb: false,
    );

/// askCameraPermission return true if user grant camera permission
Future<bool> askCameraPermission(BuildContext context) => askPermission(
      context,
      permission: Permission.camera,
      name: 'camera'.l10n,
      icon: Icons.camera,
      iconColor: Colors.red[700]!,
      supportByWeb: false,
    );

/// askPhotoPermission return true if user grant photo permission
Future<bool> askPhotoPermission(BuildContext context) => askPermission(
      context,
      permission: Permission.photos,
      name: 'photo'.l10n,
      icon: Icons.photo,
      iconColor: Colors.red[700]!,
      supportByWeb: true,
    );

/// askLocationPermission return true if user grant location permission
Future<bool> askLocationPermission(BuildContext context) => askPermission(
      context,
      permission: Permission.location,
      name: 'location'.l10n,
      icon: Icons.location_on,
      iconColor: Colors.red[700]!,
      supportByWeb: true,
    );

/// askNotificationPermission return true if user grant notification permission
Future<bool> askNotificationPermission(BuildContext context) => askPermission(
      context,
      permission: Permission.accessNotificationPolicy,
      name: 'notification'.l10n,
      icon: Icons.notifications,
      iconColor: Colors.red[700]!,
      supportByWeb: false,
    );

/// askMicrophonePermission return true if user grant microphone permission
Future<bool> askMicrophonePermission(BuildContext context) => askPermission(
      context,
      permission: Permission.microphone,
      name: 'mic'.l10n,
      icon: Icons.mic,
      iconColor: Colors.red[700]!,
      supportByWeb: false,
    );

/// askPermission return true if user grant permission
Future<bool> askPermission(
  BuildContext context, {
  required Permission permission,
  required String name,
  required IconData icon,
  required Color iconColor,
  required bool supportByWeb,
}) async {
  if (kIsWeb && !supportByWeb) {
    dialog.alert(
      context,
      'notSupport'.l10n.replaceAll('%1', name),
      warning: true,
    );
    return false;
  }

  var status = await permission.status;
  if (status.isGranted) {
    return true;
  }

  if (await permission.request().isGranted) {
    return true;
  }

  final gotoSetting = await dialog.alert(
    context,
    'permission'.l10n.replaceAll('%1', name),
    icon: icon,
    iconColor: iconColor,
    yes: 'gotoSetting'.l10n,
    buttonYes: true,
    buttonCancel: true,
  );
  if (gotoSetting == true) {
    openAppSettings();
  }
  return false;
}
