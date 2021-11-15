import 'dart:async';
import 'package:flutter/material.dart';
import 'toast.dart';

/// loading show loading dialog when callback running
///
void loading(
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
