import 'package:flutter/material.dart';
import 'package:animations/animations.dart';

/// AxisAnimationType determines which type of shared axis transition is used.
enum AxisAnimationType {
  /// Creates a shared axis vertical (y-axis) page transition.
  vertical,

  /// Creates a shared axis horizontal (x-axis) page transition.
  horizontal,

  /// Creates a shared axis scaled (z-axis) page transition.
  scaled,
}

/// AxisAnimation is used for transitions between UI elements that have a spatial or navigational relationship
/// ```dart
/// AxisAnimation(
///  reverse: isSwitched,
///  type: AxisAnimationType.vertical,
///  child: isSwitched
///   ? Container(key: UniqueKey(), width: 200, height: 200, color: Colors.red)
///   : Container(key: UniqueKey(), width: 200, height: 200, color: Colors.blue),
/// )
/// ```
class AxisAnimation extends StatelessWidget {
  /// AxisAnimation is used for transitions between UI elements that have a spatial or navigational relationship
  /// ```dart
  /// AxisAnimation(
  ///  reverse: isSwitched,
  ///  type: AxisAnimationType.vertical,
  ///  child: isSwitched
  ///   ? Container(key: UniqueKey(), width: 200, height: 200, color: Colors.red)
  ///   : Container(key: UniqueKey(), width: 200, height: 200, color: Colors.blue),
  /// )
  /// ```
  const AxisAnimation({
    required this.child,
    this.reverse = false,
    this.type = AxisAnimationType.horizontal,
    Key? key,
  }) : super(key: key);

  /// child is the child need to animate
  final Widget child;

  /// reverse is used to reverse the animation
  final bool reverse;

  /// type is used to determine which type of shared axis transition is used.
  final AxisAnimationType type;

  @override
  Widget build(BuildContext context) {
    return PageTransitionSwitcher(
      duration: const Duration(milliseconds: 600),
      reverse: reverse,
      transitionBuilder: (Widget child, Animation<double> animation, Animation<double> secondaryAnimation) {
        return SharedAxisTransition(
          child: child,
          animation: animation,
          secondaryAnimation: secondaryAnimation,
          transitionType: type == AxisAnimationType.horizontal
              ? SharedAxisTransitionType.horizontal
              : type == AxisAnimationType.vertical
                  ? SharedAxisTransitionType.vertical
                  : SharedAxisTransitionType.scaled,
        );
      },
      child: child,
    );
  }
}
