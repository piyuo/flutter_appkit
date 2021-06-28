import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:libcli/i18n.dart' as i18n;
import 'field.dart';

/// InputField for input simple text
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

  /// decoration allow custom decoration
  final InputDecoration? decoration;

  InputField({
    required this.controller,
    this.textInputAction = TextInputAction.next,
    this.minLength = 0,
    this.maxLength = 256,
    this.formatters,
    this.decoration,
    String? label,
    String? hint,
    String? require,
    FormFieldValidator<String>? validator,
    FocusNode? focusNode,
  }) : super(
          label: label,
          hint: hint,
          require: require,
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
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: focusNode,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: controller,
      inputFormatters: [LengthLimitingTextInputFormatter(maxLength), ...formatters ?? []],
      textInputAction: textInputAction,
      validator: defaultValidator,
      decoration: decoration ?? defaultDecoration,
    );
  }
}
