import 'dart:ui';
import 'package:flutter/material.dart';

const double kColorOpacity = 0.0;

class BlurryContainer extends StatelessWidget {
  final Widget child;

  final double blur;

  final double? height, width;

  final EdgeInsetsGeometry? padding;

  final Color? backgroundColor;

  final Border? border;

  final BorderRadius borderRadius;

  BlurryContainer({
    required this.child,
    this.blur = 18,
    this.height,
    this.width,
    this.padding,
    this.backgroundColor,
    this.border,
    this.borderRadius = const BorderRadius.all(Radius.circular(20)),
  });

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
      child: Container(
        decoration: BoxDecoration(
          border: border,
          borderRadius: borderRadius,
          color: backgroundColor,
        ),
        height: height,
        width: width,
        padding: padding,
        child: child,
      ),
    );
  }
}
