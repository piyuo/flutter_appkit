import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'extensions.dart';

class Flickering extends StatelessWidget {
  const Flickering({
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

/// Flicker display shimmer with custom width and height
class Flicker extends StatelessWidget {
  const Flicker({
    this.builder,
    this.width,
    this.height,
    Key? key,
    this.enabled = true,
  }) : super(key: key);

  /// builder only called when flicker is done
  final Widget Function()? builder;

  /// enabled is true will show shimmer
  final bool enabled;

  /// width is shimmer width
  final double? width;

  /// width is shimmer height
  final double? height;

  @override
  Widget build(BuildContext context) {
    return enabled
        ? SizedBox(
            width: width,
            height: height,
            child: const DecoratedBox(
                decoration: BoxDecoration(
              color: Colors.white,
            )),
          )
        : builder != null
            ? builder!()
            : const SizedBox();
  }
}
