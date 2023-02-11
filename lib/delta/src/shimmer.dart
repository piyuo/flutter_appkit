import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart' as shimmer;
import 'extensions.dart';

class ShimmerScope extends StatelessWidget {
  /// ShimmerScope set scope for all shimmer spot
  const ShimmerScope({
    required this.child,
    Key? key,
    this.enabled = true,
  }) : super(key: key);

  /// enabled is true will show shimmer
  final bool enabled;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return enabled
        ? shimmer.Shimmer.fromColors(
            baseColor: context.themeColor(light: Colors.grey.shade300, dark: Colors.grey.shade800),
            highlightColor: context.themeColor(light: Colors.grey.shade100, dark: Colors.grey.shade600),
            enabled: true,
            child: child,
          )
        : child;
  }
}

/// Shimmer display shimmer with custom width and height
class Shimmer extends StatelessWidget {
  const Shimmer({
    this.width,
    this.height,
    this.radius = 10,
    this.margin = EdgeInsets.zero,
    Key? key,
  }) : super(key: key);

  /// width is shimmer width
  final double? width;

  /// height is shimmer height
  final double? height;

  /// radius is shimmer radius
  final double radius;

  /// margin for place holder, make place holder smaller than actual widget
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.themeColor(light: Colors.grey.shade300, dark: Colors.grey.shade800),
        borderRadius: BorderRadius.all(Radius.circular(radius)),
      ),
      margin: margin,
      width: width,
      height: height,
    );
  }
}
