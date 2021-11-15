import 'dart:core';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'l10n.dart';
import 'ask.dart';

/// bluetooth return true if user grant bluetooth permission
Future<bool> bluetooth(BuildContext context) => ask(
      context,
      permission: Permission.bluetoothConnect,
      name: 'bluetooth'.l10n,
      icon: Icons.bluetooth,
    );

/// camera return true if user grant camera permission
Future<bool> camera(BuildContext context) => ask(
      context,
      permission: Permission.camera,
      name: 'camera'.l10n,
      icon: Icons.camera,
    );

/// photo return true if user grant photo permission
Future<bool> photo(BuildContext context) => ask(
      context,
      permission: Permission.photos,
      name: 'photo'.l10n,
      icon: Icons.photo,
    );

/// location return true if user grant location permission
Future<bool> location(BuildContext context) => ask(
      context,
      permission: Permission.location,
      name: 'location'.l10n,
      icon: Icons.location_on,
    );

/// notification return true if user grant notification permission
Future<bool> notification(BuildContext context) => ask(
      context,
      permission: Permission.accessNotificationPolicy,
      name: 'notification'.l10n,
      icon: Icons.notifications,
    );

/// microphone return true if user grant microphone permission
Future<bool> microphone(BuildContext context) => ask(
      context,
      permission: Permission.microphone,
      name: 'mic'.l10n,
      icon: Icons.mic,
    );
