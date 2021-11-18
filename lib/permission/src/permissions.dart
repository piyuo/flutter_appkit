import 'dart:core';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:libcli/i18n/i18n.dart' as i18n;
import 'ask.dart';

/// bluetooth return true if user grant bluetooth permission
Future<bool> bluetooth(BuildContext context) => ask(
      context,
      permission: Permission.bluetoothConnect,
      name: context.i18n.permissionBluetooth,
      icon: Icons.bluetooth,
    );

/// camera return true if user grant camera permission
Future<bool> camera(BuildContext context) => ask(
      context,
      permission: Permission.camera,
      name: context.i18n.permissionCamera,
      icon: Icons.camera,
    );

/// photo return true if user grant photo permission
Future<bool> photo(BuildContext context) => ask(
      context,
      permission: Permission.photos,
      name: context.i18n.permissionBluetooth,
      icon: Icons.photo,
    );

/// location return true if user grant location permission
Future<bool> location(BuildContext context) => ask(
      context,
      permission: Permission.location,
      name: context.i18n.permissionLocation,
      icon: Icons.location_on,
    );

/// notification return true if user grant notification permission
Future<bool> notification(BuildContext context) => ask(
      context,
      permission: Permission.accessNotificationPolicy,
      name: context.i18n.permissionNotification,
      icon: Icons.notifications,
    );

/// microphone return true if user grant microphone permission
Future<bool> microphone(BuildContext context) => ask(
      context,
      permission: Permission.microphone,
      name: context.i18n.permissionMic,
      icon: Icons.mic,
    );
