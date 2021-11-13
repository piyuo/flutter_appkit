import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/cupertino.dart';

/// SwipeContainer provides a swiper control with sliding effect.
///
class SwipeContainer extends StatefulWidget {
  const SwipeContainer({
    required this.children,
    required this.controller,
    this.height = 200,
    Key? key,
  }) : super(key: key);

  /// children is segment children widget
  final List<Widget> children;

  /// controller is dropdown value controller
  final ValueNotifier<int?> controller;

  /// height is container height;
  final double height;

  @override
  _SwipeContainerState createState() => _SwipeContainerState();
}

class _SwipeContainerState extends State<SwipeContainer> {
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
    return SizedBox(
        height: widget.height,
        child: PageView(
          scrollDirection: Axis.horizontal,
          controller: pager,
          children: widget.children,
          onPageChanged: (index) {
            widget.controller.value = index;
          },
        ));
  }
}
