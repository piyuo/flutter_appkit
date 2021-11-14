import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'slide_segment.dart';
import 'swipe_container.dart';

/// SlideSegmentContainer provides a segmented control container
///
class SlideSegmentContainer extends StatefulWidget {
  const SlideSegmentContainer({
    required this.children,
    required this.segments,
    required this.controller,
    this.onBeforeChange,
    this.height = 100,
    this.padding,
    Key? key,
  }) : super(key: key);

  /// children is children widget
  final List<Widget> children;

  /// segments is segment control widget
  final List<Widget> segments;

  /// controller is dropdown value controller
  final ValueNotifier<int?> controller;

  final Future<bool> Function(int?)? onBeforeChange;

  /// height is container height;
  final double height;

  final EdgeInsetsGeometry? padding;

  @override
  _SlideSegmentContainerState createState() => _SlideSegmentContainerState();
}

class _SlideSegmentContainerState extends State<SlideSegmentContainer> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      SlideSegment<int>(
        controller: widget.controller,
        children: widget.segments.asMap(),
        onBeforeChange: widget.onBeforeChange,
      ),
      Padding(
          padding: widget.padding ?? EdgeInsets.zero,
          child: SwipeContainer(
            height: widget.height,
            controller: widget.controller,
            children: widget.children,
          ))
    ]);
  }
}
