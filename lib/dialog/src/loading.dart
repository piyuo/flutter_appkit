import 'dart:async';
import 'package:flutter/material.dart';
import 'toast.dart';

/// withLoading show loading dialog when callback running
///
Future<void> withLoading(
  BuildContext context,
  Future<void> Function() callback,
) async {
  toastLoading(context);
  try {
    await callback();
  } finally {
    dismiss();
  }
}

/// withLoadingThenDone show loading dialog when callback running, show done dialog when callback done
///
Future<void> withLoadingThenDone(
  BuildContext context,
  Future<void> Function() callback,
) async {
  toastLoading(context);
  try {
    await callback();
  } finally {
    dismiss();
    toastDone(context);
  }
}
