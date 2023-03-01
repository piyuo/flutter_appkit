import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

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
