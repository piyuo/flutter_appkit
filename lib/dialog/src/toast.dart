import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter/foundation.dart';

/// applyTheme before show toast
///
void applyTheme(BuildContext context, bool strong) {
  var mediaQuery = MediaQuery.of(context);
  var isDark = mediaQuery.platformBrightness == Brightness.dark;
  var color = isDark ? Colors.black87 : Colors.white70;
  if (strong) {
    color = isDark ? Colors.black : Colors.white;
  }
  EasyLoading.instance
    ..indicatorSize = 140.0
    ..radius = 26.0
    ..backgroundColor = isDark ? Colors.white.withOpacity(0.8) : Colors.black.withOpacity(0.8)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.custom
    ..indicatorColor = color
    ..textColor = color
    ..progressWidth = 8
    ..progressColor = isDark ? Colors.black : Colors.white
    ..textStyle = TextStyle(fontSize: 18, color: color);

  double width = mediaQuery.size.width;
  if (width > 600) {
    EasyLoading.instance
      ..indicatorSize = 160.0
      ..radius = 28.0
      ..progressWidth = 12
      ..textStyle = TextStyle(fontSize: 24, color: color, fontWeight: FontWeight.bold);
  }
}

/// loading show loading toast
///
Future<void> loading(BuildContext context, {String? text}) {
  applyTheme(context, false);
  return EasyLoading.show(
    status: text,
    maskType: EasyLoadingMaskType.clear,
  );
}

Future<void> progress(BuildContext context, double value, {String? text}) {
  applyTheme(context, false);
  if (value >= 1) {
    dismiss();
  }

  return EasyLoading.showProgress(
    value,
    status: text ?? (value * 100).round().toString() + ' %',
    maskType: EasyLoadingMaskType.clear,
  );
}

/// info
///
Future<void> info(BuildContext context,
    {String? text, Widget? widget, Duration autoHide = const Duration(milliseconds: 2000)}) {
  applyTheme(context, true);

  if (kReleaseMode) {
    // only auto hide in release mode, cause timer will break test
    Future.delayed(autoHide, () {
      dismiss();
    });
  }

  return EasyLoading.show(
    status: text,
    indicator: widget,
    dismissOnTap: true,
  );
}

/// ok show ok toast
///
Future<void> ok(BuildContext context, String text) {
  applyTheme(context, true);
  return EasyLoading.showSuccess(
    text,
    maskType: EasyLoadingMaskType.none,
    dismissOnTap: true,
  );
}

/// wrong show wrong toast
///
Future<void> wrong(BuildContext context, String text) {
  applyTheme(context, true);
  EasyLoading.instance
    ..backgroundColor = Colors.red[700]
    ..loadingStyle = EasyLoadingStyle.custom
    ..indicatorColor = Colors.white
    ..textColor = Colors.white;
  return EasyLoading.showError(
    text,
    maskType: EasyLoadingMaskType.none,
    duration: const Duration(seconds: 5),
    dismissOnTap: true,
  );
}

/// dismiss toast
///
Future<void> dismiss() {
  return EasyLoading.dismiss();
}
