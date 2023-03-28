import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter/foundation.dart';
import 'package:libcli/delta/delta.dart' as delta;

/// _applyTheme apply theme before show toast
void _applyTheme({
  EasyLoadingIndicatorType indicatorType = EasyLoadingIndicatorType.fadingCircle,
}) {
  final colorScheme = Theme.of(delta.globalContext).colorScheme;
  final mediaQuery = MediaQuery.of(delta.globalContext);

  EasyLoading.instance
    ..indicatorSize = 140.0
    ..radius = 26.0
    ..backgroundColor = colorScheme.primary.withOpacity(0.7)
    ..boxShadow = [
      BoxShadow(
        color: colorScheme.surfaceTint.withOpacity(0.5),
        blurRadius: 3,
        offset: const Offset(1, 1),
      ),
    ]
    ..indicatorType = indicatorType
    ..loadingStyle = EasyLoadingStyle.custom
    ..indicatorColor = colorScheme.onPrimary
    ..textColor = colorScheme.onPrimary
    ..progressWidth = 8
    ..progressColor = colorScheme.onPrimary
    ..textStyle = TextStyle(fontSize: 18, color: colorScheme.onPrimary);

  double width = mediaQuery.size.width;
  if (width > 600) {
    EasyLoading.instance
      ..indicatorSize = 140.0
      ..radius = 28.0
      ..progressWidth = 12
      ..textPadding = const EdgeInsets.symmetric(vertical: 10, horizontal: 20)
      ..textStyle = TextStyle(
        fontSize: 24,
        color: colorScheme.onPrimary,
        fontWeight: FontWeight.bold,
      );
  }
}

/// toastWidget toast a widget
void toastWidget(
  Widget child,
) {
  _applyTheme();
  EasyLoading.show(
      maskType: EasyLoadingMaskType.clear,
      indicator: Column(children: [
        child,
      ]));
}

/// toastMask
void toastMask() {
  _applyTheme(
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
    indicatorType: EasyLoadingIndicatorType.fadingCircle,
  );
  EasyLoading.show(
    status: text ?? delta.i18n.hintPleaseWait,
    maskType: EasyLoadingMaskType.black,
    dismissOnTap: false,
  );
}

/// toastDone show done toast
void toastDone({String? text}) {
  _applyTheme();
  EasyLoading.showSuccess(
    text ?? delta.i18n.hintDone,
    maskType: EasyLoadingMaskType.none,
    dismissOnTap: true,
  );
}

/// toastProgress show progress toast
void toastProgress(double value, {String? text}) {
  _applyTheme();
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
  String text, {
  Widget? widget,
  Duration autoHideDuration = const Duration(milliseconds: 2000),
}) {
  _applyTheme();

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
void toastError(String text) {
  _applyTheme();
  final colorScheme = Theme.of(delta.globalContext).colorScheme;
  EasyLoading.instance
    ..backgroundColor = colorScheme.error.withOpacity(0.7)
    ..loadingStyle = EasyLoadingStyle.custom
    ..indicatorColor = colorScheme.onError
    ..textColor = colorScheme.onError
    ..textStyle = TextStyle(fontSize: 18, color: colorScheme.onError);

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
