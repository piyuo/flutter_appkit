import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:libcli/i18n/i18n.dart' as i18n;
import 'field.dart';

/// InputField for input simple text
class InputField extends Field<TextEditingValue> {
  const InputField({
    required Key key,
    required TextEditingController controller,
    this.textInputAction = TextInputAction.next,
    this.minLength = 0,
    this.maxLength = 256,
    this.formatters,
    this.decoration,
    String? label,
    String? hint,
    String? require,
    this.readOnly = false,
    FormFieldValidator<TextEditingValue>? validator,
    FocusNode? focusNode,
  }) : super(
          key: key,
          controller: controller,
          label: label,
          hint: hint,
          require: require,
          validator: validator,
          focusNode: focusNode,
        );

  /// textInputAction control keyboard text input action
  final TextInputAction? textInputAction;

  /// maxLength specified max input length
  final int maxLength;

  /// maxLength specified min input length
  final int minLength;

  /// decoration use for custom decoration
  final InputDecoration? decoration;

  final List<TextInputFormatter>? formatters;

  /// readOnly set input field readOnly
  final bool readOnly;

  @override
  String? validate(TextEditingValue? value) {
    var result = super.validate(value);
    if (result != null) {
      return result;
    }
    if (require != null && (value == null || value.text.isEmpty)) {
      return require;
    }

    if (value != null) {
      if (value.text.length < minLength) {
        return 'minLength'
            .i18n_
            .replaceAll('%1', label ?? '')
            .replaceAll('%2', '$minLength')
            .replaceAll('%3', '${value.text.length}');
      }
      if (value.text.length > maxLength) {
        return 'maxLength'
            .i18n_
            .replaceAll('%1', label ?? '')
            .replaceAll('%2', '$maxLength')
            .replaceAll('%3', '${value.text.length}');
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: readOnly,
      focusNode: focusNode,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: controller as TextEditingController,
      inputFormatters: [LengthLimitingTextInputFormatter(maxLength), ...formatters ?? []],
      textInputAction: textInputAction,
      validator: (value) => validate(controller.value),
      decoration: decoration ??
          InputDecoration(
            labelText: label,
            hintText: hint,
          ),
    );
  }
}
