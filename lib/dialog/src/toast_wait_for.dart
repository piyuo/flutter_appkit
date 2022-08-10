import 'dart:async';
import 'toast.dart';

/// toastWaitFor show wait toast when callback running
Future<void> toastWaitFor({
  required Future<void> Function() callback,
  bool showDone = true,
}) async {
  toastWait();
  try {
    await callback();
  } finally {
    if (showDone) {
      toastDone();
    } else {
      dismissToast();
    }
  }
}
