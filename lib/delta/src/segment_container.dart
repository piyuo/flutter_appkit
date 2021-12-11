import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'swipe_container.dart';

/// SegmentContainer provides a segmented control container
///
class SegmentContainer extends StatelessWidget {
  const SegmentContainer({
    required this.children,
    required this.controller,
    required this.segmentControl,
    this.height = 100,
    this.padding,
    Key? key,
  }) : super(key: key);

  /// segmentControl show segments control
  final Widget segmentControl;

  /// children is children widget
  final List<Widget> children;

  /// controller is dropdown value controller
  final ValueNotifier<int?> controller;

  /// height is container height;
  final double height;

  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      segmentControl,
      Padding(
          padding: padding ?? EdgeInsets.zero,
          child: SwipeContainer(
            height: height,
            controller: controller,
            children: children,
          ))
    ]);
  }
}
