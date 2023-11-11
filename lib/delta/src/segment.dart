import 'package:flutter/cupertino.dart';

/// Segment provides a normal segmented control
class Segment<T extends Object> extends StatefulWidget {
  const Segment({
    required this.children,
    required this.controller,
    this.onBeforeChange,
    super.key,
  });

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
  SegmentState createState() => SegmentState<T>();
}

class SegmentState<T extends Object> extends State<Segment<T>> {
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

/// SlideSegment provides a segmented control with sliding effect.
class SlideSegment<T> extends StatefulWidget {
  const SlideSegment({
    required this.children,
    required this.controller,
    this.onBeforeChange,
    super.key,
  });

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
  SlideSegmentState createState() => SlideSegmentState<T>();
}

class SlideSegmentState<T> extends State<SlideSegment<T>> {
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

/// SwipeContainer provides a swiper control with sliding effect.
class SwipeContainer extends StatefulWidget {
  const SwipeContainer({
    required this.children,
    required this.controller,
    super.key,
  });

  /// children is segment children widget
  final List<Widget> children;

  /// controller is dropdown value controller
  final ValueNotifier<int?> controller;

  @override
  SwipeContainerState createState() => SwipeContainerState();
}

class SwipeContainerState extends State<SwipeContainer> {
  final PageController pager = PageController(initialPage: 0);

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
    setState(() {
      pager.animateToPage(
        widget.controller.value ?? 0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.linear,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      scrollDirection: Axis.horizontal,
      controller: pager,
      children: widget.children,
      onPageChanged: (index) {
        widget.controller.value = index;
      },
    );
  }
}

/// SegmentContainer provides a segmented control container
class SegmentContainer extends StatelessWidget {
  const SegmentContainer({
    required this.children,
    required this.controller,
    required this.segmentControl,
    this.padding,
    super.key,
  });

  /// segmentControl show segments control
  final Widget segmentControl;

  /// children is children widget
  final List<Widget> children;

  /// controller is dropdown value controller
  final ValueNotifier<int?> controller;

  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      segmentControl,
      Expanded(
          child: Padding(
              padding: padding ?? EdgeInsets.zero,
              child: SwipeContainer(
                controller: controller,
                children: children,
              )))
    ]);
  }
}
