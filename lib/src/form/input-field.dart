import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:libcli/i18n.dart' as i18n;
import 'field.dart';

class InputField extends Field {
  /// controller is input value controller
  final TextEditingController controller;

  /// textInputAction control keyboard text input action
  final TextInputAction? textInputAction;

  /// maxLength specified max input length
  final int maxLength;

  /// maxLength specified min input length
  final int minLength;

  final List<TextInputFormatter>? formatters;

  InputField({
    required this.controller,
    this.textInputAction = TextInputAction.next,
    this.minLength = 0,
    this.maxLength = 256,
    this.formatters,
    String? label,
    String? hint,
    String? required,
    FormFieldValidator<String>? validator,
    FocusNode? focusNode,
    Key? key,
  }) : super(
          key: key,
          label: label,
          hint: hint,
          required: required,
          validator: validator,
          focusNode: focusNode,
        );

  @override
  bool isEmpty() => controller.text.isEmpty;

  @override
  String? defaultValidator(String? text) {
    var result = super.defaultValidator(text);
    if (result != null) {
      return result;
    }
    if (text!.length < minLength) {
      return 'minLength'
          .i18n_
          .replaceAll('%1', label ?? '')
          .replaceAll('%2', '$minLength')
          .replaceAll('%3', '${text.length}');
    }
    if (text.length > maxLength) {
      return 'maxLength'
          .i18n_
          .replaceAll('%1', label ?? '')
          .replaceAll('%2', '$maxLength')
          .replaceAll('%3', '${text.length}');
    }
    return null;
  }

  @override
  InputFieldState createState() => InputFieldState();
}

class InputFieldState extends State<InputField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: widget.focusNode,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: widget.controller,
      inputFormatters: [LengthLimitingTextInputFormatter(widget.maxLength), ...widget.formatters ?? []],
      textInputAction: widget.textInputAction,
      validator: widget.defaultValidator,
      decoration: widget.defaultDecoration,
    );
  }
}
