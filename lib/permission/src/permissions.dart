import 'dart:core';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:libcli/i18n/i18n.dart' as i18n;
import 'package:libcli/delta/delta.dart' as delta;
import 'ask.dart';

/// bluetooth return true if user grant bluetooth permission
/// ```dart
/// if (await bluetooth)
///  // do something
/// ```
Future<bool> get bluetooth => ask(
      permission: Permission.bluetoothConnect,
      name: delta.globalContext.i18n.permissionBluetooth,
    );

/// camera return true if user grant camera permission
/// ```dart
/// if (await camera)
///  // do something
/// ```
Future<bool> get camera => ask(
      permission: Permission.camera,
      name: delta.globalContext.i18n.permissionCamera,
    );

/// photo return true if user grant photo permission
/// ```dart
/// if (await photo)
///  // do something
/// ```
Future<bool> get photo => ask(
      permission: Permission.photos,
      name: delta.globalContext.i18n.permissionBluetooth,
    );

/// location return true if user grant location permission
/// ```dart
/// if (await location)
///  // do something
/// ```
Future<bool> get location => ask(
      permission: Permission.location,
      name: delta.globalContext.i18n.permissionLocation,
    );

/// notification return true if user grant notification permission
/// ```dart
/// if (await notification)
///  // do something
/// ```
Future<bool> get notification => ask(
      permission: Permission.accessNotificationPolicy,
      name: delta.globalContext.i18n.permissionNotification,
    );

/// microphone return true if user grant microphone permission
/// ```dart
/// if (await microphone)
///  // do something
/// ```
Future<bool> get microphone => ask(
      permission: Permission.microphone,
      name: delta.globalContext.i18n.permissionMic,
    );
