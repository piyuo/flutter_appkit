import 'package:flutter/material.dart';
import 'extensions.dart';

enum LightStatus { green, yellow, red }

/// StatusLight show green/yellow/red status light
class StatusLight extends StatelessWidget {
  const StatusLight({
    Key? key,
    this.status = LightStatus.green,
    this.iconSize = 16,
    this.onPressed,
    this.tooltip,
    this.label,
  }) : super(key: key);

  /// status of status light
  final LightStatus status;

  /// onPressed call when user press status light
  final VoidCallback? onPressed;

  /// tooltip
  final String? tooltip;

  /// iconSize is status light icon size
  final double iconSize;

  /// label is status light label
  final String? label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          iconSize: iconSize,
          icon: Icon(
            Icons.circle,
            color: status == LightStatus.green
                ? context.themeColor(light: Colors.green[600]!, dark: Colors.green[400]!)
                : status == LightStatus.yellow
                    ? context.themeColor(light: Colors.yellow[600]!, dark: Colors.yellow[400]!)
                    : context.themeColor(light: Colors.red[600]!, dark: Colors.red[400]!),
          ),
          onPressed: onPressed,
          tooltip: tooltip,
        ),
        if (label != null) Text(label!, style: const TextStyle(fontSize: 16, color: Colors.grey)),
      ],
    );
  }
}
