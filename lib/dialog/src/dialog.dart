import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'toast.dart';

Widget Function(BuildContext, Widget? child) init() {
  /// init toast
  return EasyLoading.init(builder: (ctx, w) {
    return MaxScaleTextWidget(
      child: w!,
    );
  });
}

/// MaxScaleTextWidget prevent user set scale too big, the layout may not show correctly
class MaxScaleTextWidget extends StatelessWidget {
  final Widget child;

  const MaxScaleTextWidget({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var data = MediaQuery.of(context);
    var scale = math.min(1.0, data.textScaleFactor);
    return MediaQuery(
      data: data.copyWith(textScaleFactor: scale),
      child: child,
    );
  }
}

/// routeOrDialog will push route if screen size small than 600, otherwise it will show widget in dialog with width 600
/// ```dart
/// routeOrDialog(
///          context,
///          Scaffold(
///            appBar: AppBar(title: const Text('normal')),
///            body: Container(color: Colors.blue),
///          ),
///        )
/// ```
Future<T?> routeOrDialog<T>(BuildContext context, Widget child) async {
  final screenSize = MediaQuery.of(context).size;

  if (screenSize.width > 600) {
    // show dialog
    return await showDialog<T>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext ctx) {
          return Dialog(
            child: SizedBox(
              width: 600,
              child: child,
            ),
          );
        });
  }

  // show route
  return await Navigator.push<T>(
    context,
    MaterialPageRoute(builder: (context) => child),
  );
}

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
