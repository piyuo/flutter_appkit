import 'package:flutter/material.dart';
import 'package:libcli/dialog/dialog.dart' as dialog;
import 'package:libcli/delta/delta.dart' as delta;

/// Button is form button, it will be submit button if form is not null
class Button extends StatefulWidget {
  const Button({
    required Key key, // all submit must have key, it's important for test and identify field
    required this.label,
    this.onPressed,
    this.focusNode,
    this.fontSize = 16,
    this.padding = const EdgeInsets.symmetric(horizontal: 38, vertical: 10),
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

  /// color is text and outline color
  final Color? color;

  @override
  State<StatefulWidget> createState() => _ButtonState();
}

class _ButtonState extends State<Button> {
  /// _pressed is true when button is pressed
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      focusNode: widget.focusNode,
      style: OutlinedButton.styleFrom(
        primary: widget.color ?? context.invertedColor,
        side: BorderSide(
          color: widget.onPressed != null ? widget.color ?? context.invertedColor : Colors.grey,
          style: BorderStyle.solid,
          width: 1,
        ),
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
          color: widget.onPressed != null ? widget.color ?? context.invertedColor : Colors.grey,
          fontSize: widget.fontSize,
        ),
      ),
      onPressed: widget.onPressed != null
          ? () async {
              if (_pressed) {
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
