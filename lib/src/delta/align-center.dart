import 'package:flutter/material.dart';

class AlignCenter extends StatelessWidget {
  final Widget child;

  final double? width;

  final double? height;

  final EdgeInsetsGeometry? padding;

  final AlignmentGeometry? alignment;

  const AlignCenter({
    required this.child,
    this.width,
    this.height,
    this.padding,
    this.alignment,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.center,
        child: Container(
          width: width,
          height: height,
          padding: padding,
          alignment: alignment,
          child: child,
        ));
  }
}
