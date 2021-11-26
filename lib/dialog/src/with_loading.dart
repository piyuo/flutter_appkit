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
  Future<bool> Function() callback,
) async {
  toastLoading(context);
  bool result = false;
  try {
    result = await callback();
  } finally {
    dismiss();
  }
  if (result) {
    toastDone(context);
  }
}
