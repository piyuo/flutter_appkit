import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter/foundation.dart';
import 'package:libcli/delta/delta.dart' as delta;
import 'package:libcli/i18n/i18n.dart' as i18n;

/// _applyTheme apply theme before show toast
void _applyTheme(
  BuildContext context, {
  EasyLoadingIndicatorType indicatorType = EasyLoadingIndicatorType.fadingCircle,
}) {
  var mediaQuery = MediaQuery.of(context);
  var color = context.themeColor(light: Colors.white, dark: Colors.black);

  EasyLoading.instance
    ..indicatorSize = 140.0
    ..radius = 26.0
    ..backgroundColor = context.themeColor(
      light: Colors.black.withOpacity(0.7),
      dark: Colors.white.withOpacity(0.7),
    )
    ..boxShadow = const [
      BoxShadow(
        color: Colors.black26,
        blurRadius: 15.0,
        offset: Offset(3, 4),
      ),
    ]
    ..indicatorType = indicatorType
    ..loadingStyle = EasyLoadingStyle.custom
    ..indicatorColor = color
    ..textColor = color
    ..progressWidth = 8
    ..progressColor = color
    ..textStyle = TextStyle(fontSize: 18, color: color);

  double width = mediaQuery.size.width;
  if (width > 600) {
    EasyLoading.instance
      ..indicatorSize = 140.0
      ..radius = 28.0
      ..progressWidth = 12
      ..textPadding = const EdgeInsets.symmetric(vertical: 10, horizontal: 20)
      ..textStyle = TextStyle(
        fontSize: 24,
        color: color,
        fontWeight: FontWeight.bold,
      );
  }
}

/// toastWidget toast a widget
void toastWidget(
  Widget child,
) {
  _applyTheme(delta.globalContext);
  EasyLoading.show(
      maskType: EasyLoadingMaskType.clear,
      indicator: Column(children: [
        child,
      ]));
}

/// toastMask
void toastMask() {
  _applyTheme(
    delta.globalContext,
    indicatorType: EasyLoadingIndicatorType.fadingCircle,
  );
  EasyLoading.show(
    dismissOnTap: false,
  );
}

/// toastWait show wait toast
void toastWait({
  String? text,
}) {
  _applyTheme(
    delta.globalContext,
    indicatorType: EasyLoadingIndicatorType.fadingCircle,
  );
  EasyLoading.show(
    status: text ?? delta.globalContext.i18n.hintPleaseWait,
    maskType: EasyLoadingMaskType.black,
    dismissOnTap: false,
  );
}

/// toastDone show done toast
void toastDone({String? text}) {
  _applyTheme(delta.globalContext);
  EasyLoading.showSuccess(
    text ?? delta.globalContext.i18n.hintDone,
    maskType: EasyLoadingMaskType.none,
    dismissOnTap: true,
  );
}

/// toastProgress show progress toast
void toastProgress(BuildContext context, double value, {String? text}) {
  _applyTheme(context);
  if (value >= 1) {
    dismissToast();
  }

  EasyLoading.showProgress(
    value,
    status: text ?? '${(value * 100).round()} %',
    maskType: EasyLoadingMaskType.clear,
  );
}

/// toastInfo
void toastInfo(
  BuildContext context,
  String text, {
  Widget? widget,
  Duration autoHideDuration = const Duration(milliseconds: 2000),
}) {
  _applyTheme(context);

  if (kReleaseMode) {
    // only auto hide in release mode, cause timer will break test
    Future.delayed(autoHideDuration, () {
      dismissToast();
    });
  }

  EasyLoading.show(
    status: text,
    indicator: widget,
    dismissOnTap: true,
  );
}

/// toastError show error toast
void toastError(BuildContext context, String text) {
  _applyTheme(context);
  EasyLoading.instance
    ..backgroundColor = Colors.red[700]
    ..loadingStyle = EasyLoadingStyle.custom
    ..indicatorColor = Colors.white
    ..textColor = Colors.white;
  EasyLoading.showError(
    text,
    maskType: EasyLoadingMaskType.none,
    duration: const Duration(seconds: 5),
    dismissOnTap: true,
  );
}

/// dismissToast dismiss toast
Future<void> dismissToast() {
  return EasyLoading.dismiss(animation: true);
}
