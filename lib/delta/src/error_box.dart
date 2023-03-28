import 'package:flutter/material.dart';

/// ErrorLabel display error message in a label
class ErrorLabel extends StatelessWidget {
  const ErrorLabel({
    required this.message,
    this.maxLines = 1,
    this.iconSize = 24,
    this.space = 4,
    this.icon = Icons.priority_high_outlined,
    this.color,
    Key? key,
  }) : super(key: key);

  /// message is the error message to display
  final String message;

  final int? maxLines;

  final IconData icon;

  final double iconSize;

  final double space;

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color ?? Theme.of(context).colorScheme.error, size: iconSize),
        SizedBox(width: space),
        Expanded(
          child: Text(
            message,
            maxLines: maxLines,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: color ?? Theme.of(context).colorScheme.error),
          ),
        ),
      ],
    );
  }
}

/// ErrorBox display error message in a box
class ErrorBox extends StatelessWidget {
  const ErrorBox({
    required this.message,
    this.maxLines = 6,
    Key? key,
  }) : super(key: key);

  /// message is the error message to display
  final String message;

  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ErrorLabel(
        icon: Icons.error_outlined,
        message: message,
        maxLines: maxLines,
        iconSize: 40,
        space: 20,
        color: Theme.of(context).colorScheme.onErrorContainer,
      ),
    );
  }
}
