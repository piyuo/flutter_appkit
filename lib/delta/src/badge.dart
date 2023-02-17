import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;

/// NotificationBadge is a widget that shows a badge on top of another widget.
/// ```dart
/// NotificationBadge(
///  badgeText: '1',
///  badgeText: '112',
///  child: Text('Badge', style: TextStyle(fontSize: 20)),
/// )
/// ```
class NotificationBadge extends StatelessWidget {
  const NotificationBadge({
    required this.child,
    this.badgeText,
    this.color = Colors.red,
    this.badgeTextColor = Colors.white,
    this.onBottom = false,
    Key? key,
  }) : super(key: key);

  /// badge value
  final String? badgeText;

  /// text color for badge
  final Color badgeTextColor;

  /// color for badge
  final Color color;

  /// onBottom is true will show badge on bottom
  final bool onBottom;

  /// child for badge
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return badges.Badge(
      /*badgeAnimation: const badges.BadgeAnimation.size(
        animationDuration: Duration(seconds: 1),
        colorChangeAnimationDuration: Duration(seconds: 1),
        loopAnimation: false,
        curve: Curves.fastOutSlowIn,
        colorChangeAnimationCurve: Curves.easeInCubic,
      ),*/
      badgeStyle: badges.BadgeStyle(
        padding: const EdgeInsets.fromLTRB(5, 1, 4, 3),
        elevation: 3,
        shape: badges.BadgeShape.square,
        borderRadius: const BorderRadius.all(Radius.circular(15)),
        badgeColor: color.withOpacity(.9),
      ),
      showBadge: badgeText != null && badgeText!.isNotEmpty,
      position: onBottom
          ? badges.BadgePosition.bottomEnd(bottom: -4, end: -4)
          : badges.BadgePosition.topEnd(top: -4, end: -4),
      badgeContent: badgeText != null
          ? Text(
              badgeText!,
              style: TextStyle(
                color: badgeTextColor,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            )
          : null,
      child: child,
    );
  }
}
