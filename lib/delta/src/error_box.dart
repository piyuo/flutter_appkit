import 'package:flutter/material.dart';
import 'package:dotted_decoration/dotted_decoration.dart';
import 'error_label.dart';

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
