import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:libcli/src/validator/validator.dart' as validator;

class TextEdit extends StatefulWidget {
  final TextEditingController controller;

  final String label;

  final FocusNode? focusNode;

  final TextInputAction? textInputAction;

  final InputDecoration? decoration;

  final TextAlign textAlign;

  final TextStyle? style;

  final int textInputMaxLength;

  final int textInputMinLength;

  final List<TextInputFormatter>? inputFormatters;

  final bool require;

  final bool enterYour;

  TextEdit({
    required this.label,
    required this.controller,
    this.focusNode,
    this.decoration,
    this.textAlign = TextAlign.left,
    this.textInputAction = TextInputAction.next,
    this.style,
    this.textInputMinLength = 0,
    this.textInputMaxLength = 256,
    this.inputFormatters,
    this.require = false,
    this.enterYour = false,
    Key? key,
  }) : super(key: key);

  @override
  TextEditState createState() => TextEditState();
}

class TextEditState extends State<TextEdit> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: widget.focusNode,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: widget.controller,
      textAlign: widget.textAlign,
      style: widget.style,
      inputFormatters: [LengthLimitingTextInputFormatter(widget.textInputMaxLength), ...widget.inputFormatters ?? []],
      textInputAction: widget.textInputAction,
      validator: (String? input) => widget.require
          ? validator.requiredValidator(
              input: input,
              label: widget.label.toLowerCase(),
              enterYour: widget.enterYour,
              minLength: widget.textInputMinLength,
            )
          : null,
      decoration: widget.decoration ??
          InputDecoration(
            hintText: widget.label,
            labelText: widget.label,
          ),
    );
  }
}
