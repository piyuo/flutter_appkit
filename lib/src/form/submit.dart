import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Submit extends StatefulWidget {
  /// sizeLevel is button size level, default is 1
  ///
  final double sizeLevel;

  /// text is button text
  ///
  final String text;

  /// onClick called when onClickStart() return true, return true if click are success
  ///
  final Function() onClick;

  /// focusNode is focusNode set to button
  ///
  final FocusNode? focusNode;

  /// form is form key, button will call form.validate() if form is not null
  ///
  final GlobalKey<FormState>? form;

  Submit(
    this.text, {
    required this.onClick,
    this.focusNode,
    this.form,
    this.sizeLevel = 1,
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => SubmitState();
}

class SubmitState extends State<Submit> {
  bool _disabled = false;

  SubmitState();

  @override
  @mustCallSuper
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      focusNode: widget.focusNode,
      style: ButtonStyle(
        backgroundColor:
            MaterialStateProperty.all(_disabled ? Theme.of(context).disabledColor : Theme.of(context).primaryColor),
        padding: MaterialStateProperty.all(EdgeInsets.fromLTRB(
            36 * widget.sizeLevel, 26 * widget.sizeLevel, 36 * widget.sizeLevel, 26 * widget.sizeLevel)),
        shape: MaterialStateProperty.all(RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(34 * widget.sizeLevel),
        )),
      ),
      child: Text(widget.text, style: TextStyle(fontSize: 18 * widget.sizeLevel, fontWeight: FontWeight.bold)),
      onPressed: () async {
        if (_disabled) {
          return;
        }

        if (widget.form != null && !widget.form!.currentState!.validate()) {
          return;
        }

        setState(() => _disabled = true);
        await widget.onClick();
        setState(() => _disabled = false);
      },
    );
  }
}
