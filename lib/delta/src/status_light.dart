import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
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
                ? context.themeColor(light: Colors.green.shade600, dark: Colors.green.shade400)
                : status == LightStatus.yellow
                    ? context.themeColor(light: Colors.yellow.shade600, dark: Colors.yellow.shade400)
                    : context.themeColor(light: Colors.red.shade600, dark: Colors.red.shade400),
          ),
          onPressed: null,
          tooltip: tooltip,
        ),
        if (label != null)
          Expanded(
              child: AutoSizeText(
            label!,
            maxLines: 1,
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ))
      ],
    );
  }
}
