import 'package:flutter/cupertino.dart';

/// SlideSegment provides a segmented control with sliding effect.
///
class SlideSegment<T> extends StatefulWidget {
  const SlideSegment({
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
  _SlideSegmentState createState() => _SlideSegmentState<T>();
}

class _SlideSegmentState<T> extends State<SlideSegment<T>> {
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
        children: widget.children,
        onValueChanged: (value) {
          widget.notifyBeforeChange(value);
          widget.controller.value = value;
        });
  }
}
