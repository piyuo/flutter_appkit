import 'package:flutter/material.dart';
import 'extensions.dart';

/// ErrorLabel display error message in a label
class ErrorLabel extends StatelessWidget {
  const ErrorLabel({
    required this.message,
    this.maxLines = 1,
    this.iconSize = 24,
    this.space = 4,
    this.icon = Icons.priority_high_outlined,
    Key? key,
  }) : super(key: key);

  /// message is the error message to display
  final String message;

  final int? maxLines;

  final IconData icon;

  final double iconSize;

  final double space;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon,
            color: context.themeColor(
              light: Colors.red.shade700,
              dark: Colors.red.shade300,
            ),
            size: iconSize),
        SizedBox(width: space),
        Expanded(
          child: Text(
            message,
            maxLines: maxLines,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                color: context.themeColor(
                  light: Colors.red.shade700,
                  dark: Colors.red.shade400,
                ),
                fontSize: 16),
          ),
        ),
      ],
    );
  }
}
