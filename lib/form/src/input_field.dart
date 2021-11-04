import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:libcli/i18n/i18n.dart' as i18n;
import 'field.dart';

/// InputField for input simple text
class InputField extends Field<String> {
  const InputField({
    required Key key,
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
          key: key,
          label: label,
          hint: hint,
          require: require,
          validator: validator,
          focusNode: focusNode,
        );

  /// controller is input value controller
  final TextEditingController controller;

  /// textInputAction control keyboard text input action
  final TextInputAction? textInputAction;

  /// maxLength specified max input length
  final int maxLength;

  /// maxLength specified min input length
  final int minLength;

  /// decoration use for custom decoration
  final InputDecoration? decoration;

  final List<TextInputFormatter>? formatters;

  @override
  String? validate(String? value) {
    var result = super.validate(value);
    if (result != null) {
      return result;
    }
    if (require != null && (value == null || value.isEmpty)) {
      return require;
    }

    if (value != null) {
      if (value.length < minLength) {
        return 'minLength'
            .i18n_
            .replaceAll('%1', label ?? '')
            .replaceAll('%2', '$minLength')
            .replaceAll('%3', '${value.length}');
      }
      if (value.length > maxLength) {
        return 'maxLength'
            .i18n_
            .replaceAll('%1', label ?? '')
            .replaceAll('%2', '$maxLength')
            .replaceAll('%3', '${value.length}');
      }
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
      validator: validate,
      decoration: decoration ?? defaultDecoration,
    );
  }
}
