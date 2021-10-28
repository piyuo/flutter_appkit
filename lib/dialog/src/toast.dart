import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter/foundation.dart';
import 'package:libcli/delta/delta.dart' as delta;

/// _applyTheme apply theme before show toast
///
void _applyTheme(
  BuildContext context, {
  EasyLoadingIndicatorType indicatorType = EasyLoadingIndicatorType.fadingCircle,
}) {
  var mediaQuery = MediaQuery.of(context);
  var color = context.themeColor(light: Colors.black, dark: Colors.white);

  EasyLoading.instance
    ..indicatorSize = 140.0
    ..radius = 26.0
    ..backgroundColor = context.themeColor(
      light: Colors.white.withOpacity(0.8),
      dark: Colors.black.withOpacity(0.8),
    )
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
      ..indicatorSize = 160.0
      ..radius = 28.0
      ..progressWidth = 12
      ..textStyle = TextStyle(fontSize: 24, color: color, fontWeight: FontWeight.bold);
  }
}

/// toastBluetoothSearching show bluetooth searching toast
///
Future<void> toastBluetoothSearching(
  BuildContext context, {
  String? text,
}) async {
  _applyTheme(context);
  await toastWidget(
      context,
      Container(
        margin: const EdgeInsets.all(20),
        width: 200,
        height: 200,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Expanded(
            child: Center(
              child: Container(
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.blue[600]!,
                    ),
                    color: Colors.blue[600],
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                  ),
                  child: const Icon(
                    Icons.bluetooth,
                    size: 90,
                    color: Colors.white,
                  )),
            ),
          ),
          if (text != null)
            Padding(
                padding: const EdgeInsets.fromLTRB(0, 4, 0, 10),
                child: Text(text,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: context.themeColor(
                        light: Colors.grey[800]!,
                        dark: Colors.grey[300]!,
                      ),
                    ))),
          LinearProgressIndicator(
            backgroundColor: Colors.grey[300]!,
            color: Colors.grey[500]!,
          ),
        ]),
      ));
}

/// toastWidget toast a widget
///
Future<void> toastWidget(
  BuildContext context,
  Widget child,
) async {
  _applyTheme(context);
  return await EasyLoading.show(
      maskType: EasyLoadingMaskType.clear,
      indicator: Column(children: [
        child,
      ]));
}

/// toastLoading show loading toast
///
Future<void> toastLoading(
  BuildContext context, {
  String? text,
  bool searching = false,
}) async {
  _applyTheme(
    context,
    indicatorType: searching ? EasyLoadingIndicatorType.threeBounce : EasyLoadingIndicatorType.fadingCircle,
  );
  return await EasyLoading.show(
    status: text,
    maskType: EasyLoadingMaskType.clear,
  );
}

Future<void> toastProgress(BuildContext context, double value, {String? text}) async {
  _applyTheme(context);
  if (value >= 1) {
    dismiss();
  }

  return await EasyLoading.showProgress(
    value,
    status: text ?? (value * 100).round().toString() + ' %',
    maskType: EasyLoadingMaskType.clear,
  );
}

/// info
///
Future<void> toastInfo(BuildContext context,
    {String? text, Widget? widget, Duration autoHide = const Duration(milliseconds: 2000)}) async {
  _applyTheme(context);

  if (kReleaseMode) {
    // only auto hide in release mode, cause timer will break test
    Future.delayed(autoHide, () {
      dismiss();
    });
  }

  return await EasyLoading.show(
    status: text,
    indicator: widget,
    dismissOnTap: true,
  );
}

/// toastOK show ok toast
///
Future<void> toastOK(BuildContext context, String text) async {
  _applyTheme(context);
  return await EasyLoading.showSuccess(
    text,
    maskType: EasyLoadingMaskType.none,
    dismissOnTap: true,
  );
}

/// toastError show error toast
///
Future<void> toastError(BuildContext context, String text) async {
  _applyTheme(context);
  EasyLoading.instance
    ..backgroundColor = Colors.red[700]
    ..loadingStyle = EasyLoadingStyle.custom
    ..indicatorColor = Colors.white
    ..textColor = Colors.white;
  return await EasyLoading.showError(
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
