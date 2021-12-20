import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;

class Badge extends StatelessWidget {
  const Badge({
    required this.child,
    this.badgeContent,
    this.badgeColor = Colors.red,
    this.badgeTextColor = Colors.white,
    Key? key,
  }) : super(key: key);

  final Widget child;

  final String? badgeContent;

  final Color badgeColor;

  final Color badgeTextColor;

  @override
  Widget build(BuildContext context) {
    return badges.Badge(
      padding: const EdgeInsets.fromLTRB(6, 1, 6, 3),
      showBadge: badgeContent != null && badgeContent!.isNotEmpty,
      position: badges.BadgePosition.topEnd(top: -12, end: -14),
      elevation: 3,
      shape: badges.BadgeShape.square,
      borderRadius: const BorderRadius.all(Radius.circular(15)),
      badgeColor: badgeColor.withOpacity(.9),
      badgeContent: badgeContent != null
          ? Text(
              badgeContent!,
              style: TextStyle(
                color: badgeTextColor,
                fontSize: 13,
              ),
            )
          : null,
      child: child,
    );
  }
}
