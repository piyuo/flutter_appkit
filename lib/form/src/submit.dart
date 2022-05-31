import 'package:flutter/material.dart';
import 'package:libcli/dialog/dialog.dart' as dialog;
import 'package:reactive_forms/reactive_forms.dart';

/// Submit is form submit button
class Submit extends StatelessWidget {
  const Submit({
    required this.label,
    this.onPressed,
    this.focusNode,
    this.fontSize = 16,
    this.padding = const EdgeInsets.symmetric(horizontal: 38, vertical: 10),
    this.elevation = 2,
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

  /// button elevation, if elevation is 0 use outlined button
  final double elevation;

  /// color is text and outline color
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return ReactiveFormConsumer(
      builder: (context, form, child) => ElevatedButton(
        focusNode: focusNode,
        style: ElevatedButton.styleFrom(
          primary: color != null && onPressed != null ? color : null,
          padding: padding,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        child: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: fontSize,
          ),
        ),
        onPressed: onPressed != null && form.valid && form.enabled && form.dirty
            ? () async {
                dialog.toastLoading(context);
                try {
                  form.markAsDisabled();
                  await onPressed?.call();
                  form.markAsPristine();
                } finally {
                  form.markAsEnabled();
                  dialog.dismiss();
                }
              }
            : null,
      ),
    );
  }
}
