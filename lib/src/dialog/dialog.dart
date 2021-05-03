import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

/// NavigatorKey used in rootContext
///
final NavigatorKey = GlobalKey<NavigatorState>();

/// RootContext return context from navigatorKey
///
BuildContext get RootContext {
  assert(NavigatorKey.currentState != null && NavigatorKey.currentState!.overlay != null,
      'you need set navigatorKey: dialogsNavigatorKey in MaterialApp');
  return NavigatorKey.currentState!.overlay!.context;
}

/// init loading
///
Widget Function(BuildContext, Widget?) init() {
  return EasyLoading.init(builder: (ctx, w) {
    return MaxScaleTextWidget(
      child: w!,
    );
  });
}

/// prevent user set scale too big, the layout may not show correctly
///
class MaxScaleTextWidget extends StatelessWidget {
  final Widget child;

  const MaxScaleTextWidget({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var data = MediaQuery.of(context);
    var scale = math.min(1.2, data.textScaleFactor);
    return MediaQuery(
      data: data.copyWith(textScaleFactor: scale),
      child: child,
    );
  }
}
