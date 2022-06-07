import 'dart:async';
import 'package:flutter/material.dart';
import 'toast.dart';

/// toastWaitFor show wait toast when callback running
Future<void> toastWaitFor(
  BuildContext context, {
  required Future<void> Function() callback,
  bool showDone = true,
}) async {
  toastWait(context);
  try {
    await callback();
  } finally {
    if (showDone) {
      toastDone(context);
    } else {
      dismissToast();
    }
  }
}
