import 'package:flutter/material.dart';

/// confirmButton return confirm button
Widget confirmButton(BuildContext context, double width, double height, double fontSize, String text,
    FocusNode? focusNode, VoidCallback onClick) {
  final isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
  return ElevatedButton(
    focusNode: focusNode,
    style: ButtonStyle(
      elevation: MaterialStateProperty.all(8),
      shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0))),
      shadowColor: MaterialStateProperty.all(isDark ? Colors.cyan[800] : Colors.cyan[300]),
      backgroundColor: MaterialStateProperty.all(Colors.cyan[600]),
      padding: MaterialStateProperty.all(EdgeInsets.fromLTRB(0, 12, 0, 12)),
      fixedSize: MaterialStateProperty.all(Size(width, height)),
    ),
    child: Text(
      text,
      style: TextStyle(fontSize: fontSize),
    ),
    onPressed: onClick,
  );
}
