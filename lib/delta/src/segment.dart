import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/cupertino.dart';

/// SlideSegment provides a segmented control with sliding effect.
///
class Segment<T extends Object> extends StatefulWidget {
  const Segment({
    required this.children,
    required this.controller,
    this.onBeforeChange,
    Key? key,
  }) : super(key: key);

  /// children is segment children widget
  final Map<T, Widget> children;

  /// controller is dropdown value controller
  final ValueNotifier<T?> controller;

  final void Function(T?)? onBeforeChange;

  void notifyBeforeChange(value) {
    if (onBeforeChange != null) {
      onBeforeChange!(value);
    }
  }

  @override
  _SegmentState createState() => _SegmentState<T>();
}

class _SegmentState<T extends Object> extends State<Segment<T>> {
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
    return CupertinoSegmentedControl<T>(
        groupValue: widget.controller.value,
        children: widget.children.map((key, value) {
          return MapEntry(
              key,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                child: value,
              ));
        }).cast<T, Widget>(),
        onValueChanged: (T value) {
          widget.notifyBeforeChange(value);
          widget.controller.value = value;
        });
  }
}
