import 'package:flutter/material.dart';
import 'package:libcli/dialog/dialog.dart' as dialog;

/// Submit is form submit button
class Submit extends StatefulWidget {
  const Submit({
    required Key key, // all submit must have key, it's important for test and identify field
    required this.label,
    required this.formKey,
    this.onPressed,
    this.focusNode,
    this.fontSize = 16,
    this.padding = const EdgeInsets.symmetric(horizontal: 38, vertical: 10),
    this.elevation = 2,
    this.color,
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

  /// form is form key, button will call form.validate() if form is not null
  final GlobalKey<FormState> formKey;

  /// button elevation, if elevation is 0 use outlined button
  final double elevation;

  /// color is text and outline color
  final Color? color;

  @override
  State<StatefulWidget> createState() => _SubmitState();
}

class _SubmitState extends State<Submit> {
  /// _pressed is true when button is pressed
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      focusNode: widget.focusNode,
      style: ElevatedButton.styleFrom(
        primary: widget.color != null && widget.onPressed != null ? widget.color : null,
        padding: widget.padding,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
      ),
      child: Text(
        widget.label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: widget.fontSize,
        ),
      ),
      onPressed: widget.onPressed != null
          ? () async {
              if (_pressed) {
                return;
              }

              if (!widget.formKey.currentState!.validate()) {
                return;
              }

              dialog.toastLoading(context);
              setState(() {
                _pressed = true;
              });
              try {
                await widget.onPressed?.call();
              } finally {
                setState(() {
                  _pressed = false;
                });
                dialog.dismiss();
              }
            }
          : null,
    );
  }
}
