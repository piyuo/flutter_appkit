import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/cupertino.dart';

/// SlideSegment provides a segmented control with sliding effect.
///
class SlideSegment<T> extends StatefulWidget {
  const SlideSegment({
    required this.children,
    required this.controller,
    Key? key,
  }) : super(key: key);

  /// children is segment children widget
  final Map<T, Widget> children;

  /// controller is dropdown value controller
  final ValueNotifier<T?> controller;

  @override
  _SlideSegmentState createState() => _SlideSegmentState<T>();
}

class _SlideSegmentState<T> extends State<SlideSegment> {
  @override
  void initState() {
    widget.controller.addListener(_onValueChanged);
    super.initState();
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onValueChanged);
    super.dispose();
  }

  /// _onValueChanged happen when control value change
  void _onValueChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoSlidingSegmentedControl<T>(
        groupValue: widget.controller.value,
        children: widget.children as Map<T, Widget>,
        onValueChanged: (value) {
          widget.controller.value = value;
        });
  }
}
