import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
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
        ? Shimmer.fromColors(
            baseColor: context.themeColor(light: Colors.grey.shade300, dark: Colors.grey.shade800),
            highlightColor: context.themeColor(light: Colors.grey.shade100, dark: Colors.grey.shade600),
            child: child,
            enabled: true,
          )
        : child;
  }
}

/// ShimmerSpot display shimmer with custom width and height
class ShimmerSpot extends StatelessWidget {
  const ShimmerSpot({
    this.builder,
    this.width,
    this.height,
    Key? key,
    this.enabled = true,
    this.margin = const EdgeInsets.all(5),
    this.radius = 5,
  }) : super(key: key);

  /// builder only called when flicker is done
  final Widget Function()? builder;

  /// enabled is true will show shimmer
  final bool enabled;

  /// width is shimmer width
  final double? width;

  /// height is shimmer height
  final double? height;

  /// radius is shimmer radius
  final double? radius;

  /// margin for place holder, make place holder smaller than actual widget
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    // ignore: prefer_if_null_operators
    final h = height == null
        ? width == null
            ? 28.0
            : null
        : height;
    return enabled
        ? Container(
            decoration: BoxDecoration(
              color: context.themeColor(light: Colors.grey.shade300, dark: Colors.grey.shade800),
              borderRadius: radius != null ? BorderRadius.all(Radius.circular(radius!)) : null,
            ),
            margin: margin,
            width: width,
            height: h, // avoid empty container
          )
        : builder != null
            ? builder!()
            : const SizedBox();
  }
}
