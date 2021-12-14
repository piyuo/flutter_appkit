import 'package:flutter/material.dart';
import 'package:libcli/dialog/dialog.dart' as dialog;

/// kButtonWidth is default button width
const double kButtonWidth = 240;

/// kButtonHeight is default button height
const double kButtonHeight = 52;

class Button extends StatefulWidget {
  const Button({
    required Key key, // all submit must have key, it's important for test and identify field
    required this.label,
    required this.onClick,
    this.focusNode,
    this.width = kButtonWidth,
    this.fontSize = 18,
    this.form,
    this.padding = const EdgeInsets.all(16),
    this.showLoading = const Duration(seconds: 1),
    this.elevation = 6,
    this.color,
  }) : super(key: key);

  /// width is button fixed width
  ///
  final double? width;

  /// padding is button padding
  ///
  final EdgeInsets padding;

  /// fontSize is button font size
  ///
  final double fontSize;

  /// label is button text
  ///
  final String label;

  /// onClick called when onClickStart() return true, return true if click are success
  ///
  final Future<void> Function() onClick;

  /// focusNode is focusNode set to button
  ///
  final FocusNode? focusNode;

  /// showLoading is not null will show loading toast after duration
  ///
  final Duration? showLoading;

  /// form is form key, button will call form.validate() if form is not null
  ///
  final GlobalKey<FormState>? form;

  /// button elevation, if elevation is 0 use outlined button
  final double elevation;

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
    final style = ButtonStyle(
      side: widget.color != null
          ? MaterialStateProperty.all(BorderSide(
              color: _pressed ? Colors.transparent : widget.color!,
              style: BorderStyle.solid,
              width: 1,
            ))
          : null,
      backgroundColor: MaterialStateProperty.all(_pressed ? Theme.of(context).disabledColor : null),
      elevation: MaterialStateProperty.all(_pressed ? 1 : widget.elevation),
      fixedSize: widget.width != null ? MaterialStateProperty.all(Size(widget.width!, kButtonHeight)) : null,
      padding: MaterialStateProperty.all(widget.padding),
      shape: MaterialStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
      ),
    );

    final text = Text(
      widget.label,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        color: _pressed ? Colors.grey : widget.color,
        fontSize: widget.fontSize,
      ),
    );

    void onPressed() async {
      if (_pressed) {
        return;
      }

      if (widget.form != null && !widget.form!.currentState!.validate()) {
        return;
      }

      dialog.toastLoading(context);
      setState(() {
        _pressed = true;
      });
      try {
        await widget.onClick();
      } finally {
        setState(() {
          _pressed = false;
        });
        dialog.dismiss();
      }
    }

    return widget.elevation == 0
        ? OutlinedButton(
            focusNode: widget.focusNode,
            style: style,
            child: text,
            onPressed: onPressed,
          )
        : ElevatedButton(
            focusNode: widget.focusNode,
            style: style,
            child: text,
            onPressed: onPressed,
          );
  }
}
