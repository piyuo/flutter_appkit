import 'package:flutter/material.dart';
import 'extensions.dart';

/// StatusLight show green/yellow/red status light
class StatusLight extends StatelessWidget {
  const StatusLight({
    Key? key,
    this.status = 1,
    this.iconSize = 24,
    this.onPressed,
    this.tooltip,
  }) : super(key: key);

  /// status 1 green light, 0 yellow light, -1 red light
  final int status;

  /// onPressed call when user press status light
  final VoidCallback? onPressed;

  /// tooltip
  final String? tooltip;

  /// iconSize is status light icon size
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      iconSize: iconSize,
      icon: Icon(
        Icons.circle,
        color: status == 1
            ? context.themeColor(light: Colors.green[600]!, dark: Colors.green[400]!)
            : status == 0
                ? context.themeColor(light: Colors.yellow[600]!, dark: Colors.yellow[400]!)
                : context.themeColor(light: Colors.red[600]!, dark: Colors.red[400]!),
      ),
      onPressed: onPressed,
      tooltip: tooltip,
    );
  }
}
