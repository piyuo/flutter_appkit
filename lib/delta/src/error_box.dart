import 'package:flutter/material.dart';
import 'package:dotted_decoration/dotted_decoration.dart';
import 'delta.dart';

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
      decoration: DottedDecoration(
        shape: Shape.box,
        color: Colors.red.shade400,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ErrorLabel(
        icon: Icons.error_outlined,
        message: message,
        maxLines: maxLines,
        iconSize: 40,
        space: 20,
      ),
    );
  }
}
