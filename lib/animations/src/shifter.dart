import 'package:flutter/material.dart';

/// Shifter provide shift animation, child must have key and use newChildKey to control how to animate
/// ```dart
/// Shifter(
///   reverse: shifterReverse,
///   vertical: shifterVertical,
///   newChildKey: ValueKey(shifterIndex),
///   child: shifterIndex == 1
///       ? Container(
///           key: const ValueKey(1), width: 200, height: 200, color: Colors.red, child: const Text('text 1'))
///       : shifterIndex == 2
///           ? Container(
///               key: const ValueKey(2), width: 200, height: 200, color: Colors.blue, child: const Text('text 2'))
///           : Container(
///               key: const ValueKey(3),
///               width: 200,
///               height: 200,
///               color: Colors.green,
///               child: const Text('text 3')),
/// ),
/// ```
class Shifter extends StatelessWidget {
  /// Shifter provide shift animation, child must have key and use newChildKey to control how to animate
  /// ```dart
  /// Shifter(
  ///   reverse: shifterReverse,
  ///   vertical: shifterVertical,
  ///   newChildKey: ValueKey(shifterIndex),
  ///   child: shifterIndex == 1
  ///       ? Container(
  ///           key: const ValueKey(1), width: 200, height: 200, color: Colors.red, child: const Text('text 1'))
  ///       : shifterIndex == 2
  ///           ? Container(
  ///               key: const ValueKey(2), width: 200, height: 200, color: Colors.blue, child: const Text('text 2'))
  ///           : Container(
  ///               key: const ValueKey(3),
  ///               width: 200,
  ///               height: 200,
  ///               color: Colors.green,
  ///               child: const Text('text 3')),
  /// ),
  /// ```
  const Shifter({
    required this.child,
    required this.newChildKey,
    this.reverse = false,
    this.vertical = false,
    this.alignment = Alignment.topLeft,
    this.duration = const Duration(milliseconds: 300),
    Key? key,
  }) : super(key: key);

  /// child need to animate, child must have key
  final Widget child;

  /// newChildKey is the key of new child
  final Key newChildKey;

  /// reverse the animation
  final bool reverse;

  /// vertical the animation
  final bool vertical;

  /// alignment is layout alignment
  final Alignment alignment;

  /// duration is the duration of the transition from the old [child] value to the new one
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: duration,
      layoutBuilder: (Widget? currentChild, List<Widget> previousChildren) {
        return Stack(
          alignment: alignment,
          children: <Widget>[
            ...previousChildren,
            if (currentChild != null) currentChild,
          ],
        );
      },
      transitionBuilder: (Widget child, Animation<double> animation) {
        var inAnimation = Tween<Offset>(
          begin: vertical ? const Offset(0, 1.0) : const Offset(1.0, 0.0),
          end: const Offset(0.0, 0.0),
        ).animate(animation);
        var outAnimation = Tween<Offset>(
          begin: vertical ? const Offset(0, -1.0) : const Offset(-1.0, 0.0),
          end: const Offset(0.0, 0.0),
        ).animate(animation);

        final backup = inAnimation;
        if (reverse) {
          inAnimation = outAnimation;
          outAnimation = backup;
        }

        return ClipRect(
          child: SlideTransition(
            position: child.key == newChildKey ? inAnimation : outAnimation,
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}
