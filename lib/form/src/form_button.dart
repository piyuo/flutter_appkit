import 'package:flutter/material.dart';
import 'package:libcli/dialog/dialog.dart' as dialog;
import 'package:libcli/delta/delta.dart' as delta;

/// FormButton is form button
class FormButton extends StatelessWidget {
  const FormButton({
    required this.label,
    this.onPressed,
    this.focusNode,
    this.fontSize = 16,
    this.padding = const EdgeInsets.symmetric(horizontal: 38, vertical: 10),
    this.color,
    Key? key, // all submit must have key, it's important for test and identify field
  }) : super(key: key);

  /// padding is button padding
  final EdgeInsets padding;

  /// fontSize is button font size
  final double fontSize;

  /// label is button text
  final String label;

  /// onPressed called when user pressed button
  final Future<void> Function()? onPressed;

  /// focusNode is focusNode set to button
  final FocusNode? focusNode;

  /// color is text and outline color
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      focusNode: focusNode,
      style: OutlinedButton.styleFrom(
        primary: color ?? context.invertedColor,
        side: BorderSide(
          color: onPressed != null ? color ?? context.invertedColor : Colors.grey,
          style: BorderStyle.solid,
          width: 1,
        ),
        padding: padding,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
      ),
      onPressed: onPressed != null
          ? () => dialog.toastWaitFor(
                context,
                callback: () async {
                  await onPressed?.call();
                },
              )
          : null,
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: onPressed != null ? color ?? context.invertedColor : Colors.grey,
          fontSize: fontSize,
        ),
      ),
    );
  }
}
