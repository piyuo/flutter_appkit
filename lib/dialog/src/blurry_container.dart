import 'dart:ui';
import 'package:flutter/material.dart';

const double kColorOpacity = 0.0;

/// BlurryContainer is container support blurry
class BlurryContainer extends StatelessWidget {
  const BlurryContainer({
    Key? key,
    required this.child,
    this.blur = 18,
    this.height,
    this.width,
    this.padding,
    this.backgroundColor,
    this.shadow,
    this.border,
    this.borderRadius = const BorderRadius.all(Radius.circular(20)),
    this.enableBlurry = true,
  }) : super(key: key);

  final Widget child;

  final double blur;

  final double? height, width;

  final EdgeInsetsGeometry? padding;

  final Color? backgroundColor;

  final BoxShadow? shadow;

  final Border? border;

  final BorderRadius borderRadius;

  final bool enableBlurry;

  @override
  Widget build(BuildContext context) {
    final container = Container(
      decoration: BoxDecoration(
        border: border,
        borderRadius: borderRadius,
        color: backgroundColor,
        boxShadow: shadow != null ? [shadow!] : null,
      ),
      height: height,
      width: width,
      padding: padding,
      child: child,
    );

    return enableBlurry
        ? BackdropFilter(filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur), child: container)
        : container;
  }
}
