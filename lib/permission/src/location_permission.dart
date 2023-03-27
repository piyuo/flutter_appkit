import 'dart:core';
import 'package:flutter/foundation.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:libcli/dialog/dialog.dart' as dialog;
import 'package:app_settings/app_settings.dart';
import 'package:geolocator/geolocator.dart';
import 'package:libcli/delta/delta.dart' as delta;
import 'package:libcli/i18n/i18n.dart' as i18n;

/// getLocationPermission return true if user grant location permission
/// ```dart
/// await getLocationPermission('to show you nearby places');
/// ```
Future<bool> getLocationPermission(String reason) async {
  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (serviceEnabled) {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.denied && permission != LocationPermission.deniedForever) {
        return true;
      }
    } else if (permission != LocationPermission.denied && permission != LocationPermission.deniedForever) {
      return true;
    }
  }
  await askLocationPermission(reason);
  return false;
}

/// askLocationPermission ask user to grant permission
Future<void> askLocationPermission(String reason) async {
  final title = 'We need location permission $reason';

  if (kIsWeb) {
    dialog.show(
      title: title,
      textContent: 'Please go to Site Settings / Location Services and enable location permission, ',
      yesText: delta.globalContext.i18n.closeButtonText,
    );
    return;
  }

  if (UniversalPlatform.isIOS || UniversalPlatform.isAndroid || kIsWeb) {
    final gotoSetting = await dialog.show(
      title: title,
      textContent: 'Please go to location settings and enable location permission',
      yesText: 'Go to location settings',
    );
    if (gotoSetting == true) {
      AppSettings.openLocationSettings();
    }
    return;
  }
  // mac or windows
  dialog.show(
    title: title,
    textContent: 'Please go to System Settings/ Privacy / Location Services and enable location permission, ',
    yesText: delta.globalContext.i18n.closeButtonText,
  );
}
