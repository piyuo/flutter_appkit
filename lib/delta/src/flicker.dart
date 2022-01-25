import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'extensions.dart';

class Flicker extends StatelessWidget {
  const Flicker({
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
