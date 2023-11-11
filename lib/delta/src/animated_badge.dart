import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;

/// _kOffsetX is badge offset
const _kOffset = -5.0;

/// AnimatedBadge is badge that can be animated.
/// ```dart
/// AnimatedBadge(
///  badgeText: '1',
///  badgeText: '112',
///  child: Text('Badge', style: TextStyle(fontSize: 20)),
/// )
/// ```
class AnimatedBadge extends StatelessWidget {
  const AnimatedBadge({
    required this.child,
    this.label,
    this.backgroundColor,
    this.textColor = Colors.white,
    this.onBottom = false,
    super.key,
  });

  /// label is a widget that shows a badge on top of another widget.
  final String? label;

  /// text color for badge
  final Color textColor;

  /// color for badge
  final Color? backgroundColor;

  /// onBottom is true will show badge on bottom
  final bool onBottom;

  /// child for badge
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return badges.Badge(
      badgeAnimation: const badges.BadgeAnimation.slide(
        slideTransitionPositionTween: badges.SlideTween(
          begin: Offset(0, 0.3),
          end: Offset(0, 0),
        ),
      ),
      badgeStyle: badges.BadgeStyle(
        padding: const EdgeInsets.fromLTRB(6, 1, 5, 2),
        elevation: 2,
        shape: badges.BadgeShape.square,
        borderRadius: const BorderRadius.all(Radius.circular(15)),
        badgeColor: backgroundColor ?? Colors.red.shade800,
      ),
      showBadge: label != null,
      position: onBottom
          ? badges.BadgePosition.bottomEnd(bottom: _kOffset, end: _kOffset)
          : badges.BadgePosition.topEnd(top: _kOffset, end: _kOffset),
      badgeContent: label != null
          ? Text(
              label!,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 10,
                color: textColor,
              ),
            )
          : null,
      child: child,
    );
  }
}
