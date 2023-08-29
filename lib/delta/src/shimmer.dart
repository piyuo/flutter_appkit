import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart' as shimmer;

/// ShimmerScope set scope for all shimmer spot
class ShimmerScope extends StatelessWidget {
  const ShimmerScope({
    required this.child,
    this.enabled = true,
    super.key,
  });

  /// enabled is true will show shimmer
  final bool enabled;

  /// child is widget that will be show
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return enabled
        ? shimmer.Shimmer.fromColors(
            baseColor: Theme.of(context).colorScheme.secondary.withOpacity(.2),
            highlightColor: Theme.of(context).colorScheme.secondaryContainer.withOpacity(.2),
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
    super.key,
  });

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
        color: Colors.grey,
        borderRadius: BorderRadius.all(Radius.circular(radius)),
      ),
      margin: margin,
      width: width,
      height: height,
    );
  }
}

/// ShimmerColumn display column full of shimmer
class ShimmerColumn extends StatelessWidget {
  const ShimmerColumn({
    this.shimmerCount = 20,
    this.shimmerHeight = 58.0,
    this.shimmerMargin = const EdgeInsets.all(10),
    super.key,
  });

  /// shimmerCount is count of shimmer
  final int shimmerCount;

  /// shimmerHeight is shimmer height
  final double shimmerHeight;

  /// shimmerHeight is shimmer height
  final EdgeInsetsGeometry? shimmerMargin;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
            children: List.generate(
      shimmerCount,
      (index) => Shimmer(
        margin: shimmerMargin,
        height: shimmerHeight,
      ),
    )));
  }
}

/// ShimmerRow display row full of shimmer
class ShimmerRow extends StatelessWidget {
  const ShimmerRow({
    this.shimmerCount = 20,
    this.shimmerWidth = 100.0,
    this.shimmerMargin = const EdgeInsets.all(10),
    super.key,
  });

  /// shimmerCount is count of shimmer
  final int shimmerCount;

  /// shimmerWidth is shimmer width
  final double shimmerWidth;

  /// shimmerHeight is shimmer height
  final EdgeInsetsGeometry? shimmerMargin;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
            children: List.generate(
          shimmerCount,
          (index) => Shimmer(
            margin: shimmerMargin,
            width: shimmerWidth,
          ),
        )));
  }
}
