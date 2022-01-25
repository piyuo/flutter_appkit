import 'package:flutter/material.dart';
import 'extensions.dart';

/// PlaceHolder display shimmer with custom width and height
class PlaceHolder extends StatelessWidget {
  const PlaceHolder({
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
    // ignore: prefer_if_null_operators
    final h = height == null
        ? width == null
            ? 28.0
            : null
        : height;
    return enabled
        ? Container(
            width: width,
            height: h, // avoid empty container
            color: context.themeColor(light: Colors.grey.shade300, dark: Colors.grey.shade800),
          )
        : builder != null
            ? builder!()
            : const SizedBox();
  }
}
