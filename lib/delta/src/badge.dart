import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;

class Badge extends StatelessWidget {
  const Badge({
    required this.child,
    this.text,
    this.color = Colors.red,
    this.textColor = Colors.white,
    this.onBottom = false,
    Key? key,
  }) : super(key: key);

  /// child for badge
  final Widget child;

  /// text for badge
  final String? text;

  /// color for badge
  final Color color;

  /// text color for badge
  final Color textColor;

  /// onBottom is true will show badge on bottom
  final bool onBottom;

  @override
  Widget build(BuildContext context) {
    return badges.Badge(
      padding: const EdgeInsets.fromLTRB(6, 1, 6, 3),
      showBadge: text != null && text!.isNotEmpty,
      position: onBottom
          ? badges.BadgePosition.bottomEnd(bottom: -8, end: -8)
          : badges.BadgePosition.topEnd(top: -8, end: -8),
      elevation: 3,
      shape: badges.BadgeShape.square,
      borderRadius: const BorderRadius.all(Radius.circular(15)),
      badgeColor: color.withOpacity(.9),
      badgeContent: text != null
          ? Text(
              text!,
              style: TextStyle(
                color: textColor,
                fontSize: 13,
              ),
            )
          : null,
      child: child,
    );
  }
}
