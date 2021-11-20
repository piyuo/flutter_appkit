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
    this.inputFormatters,
    this.decoration,
    String? label,
    String? hint,
    bool requiredField = false,
    this.readOnly = false,
    FormFieldValidator<TextEditingValue>? validator,
    this.keyboardType,
    FocusNode? focusNode,
  }) : super(
          key: key,
          controller: controller,
          label: label,
          hint: hint,
          requiredField: requiredField,
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

  final List<TextInputFormatter>? inputFormatters;

  /// readOnly set input field readOnly
  final bool readOnly;

  final TextInputType? keyboardType;

  @override
  String? validate(BuildContext context, TextEditingValue? value) {
    var result = super.validate(context, value);
    if (result != null) {
      return result;
    }

    if (value != null) {
      if (value.text.length < minLength) {
        return context.i18n.fieldTextTooShort
            .replaceAll('%1', label ?? '')
            .replaceAll('%2', '$minLength')
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
      inputFormatters: [
        if (maxLength > 0) LengthLimitingTextInputFormatter(maxLength),
        if (inputFormatters != null) ...inputFormatters!,
      ],
      textInputAction: textInputAction,
      validator: (value) => validate(context, controller.value),
      keyboardType: keyboardType,
      decoration: decoration ??
          InputDecoration(
            labelText: label,
            hintText: hint,
          ),
    );
  }
}
