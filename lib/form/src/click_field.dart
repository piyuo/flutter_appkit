import 'package:flutter/material.dart';
import 'field.dart';
import 'custom_field.dart';

/// ClickFiled show read only text, user must click to change value
class ClickField<T> extends Field<T> {
  const ClickField({
    required Key key,
    required ValueNotifier<T?> controller,
    required this.onClicked,
    required this.valueToString,
    FormFieldValidator<T>? validator,
    String? label,
    String? require,
    FocusNode? focusNode,
    FocusNode? nextFocusNode,
  }) : super(
          key: key,
          controller: controller,
          validator: validator,
          label: label,
          require: require,
          focusNode: focusNode,
          nextFocusNode: nextFocusNode,
        );

  /// onClicked return new result
  final Future<T?> Function(T? value) onClicked;

  /// valueToString convert value to string
  final String Function(T?) valueToString;

  /// superValidate use field validate
  String? superValidate(T? value) => super.validate(value);

  @override
  Widget build(BuildContext context) {
    return CustomField<T>(
      label: label,
      focusNode: focusNode,
      nextFocusNode: nextFocusNode,
      controller: controller,
      valueToString: valueToString,
      validator: (T? value) => super.validate(value),
      suffixIcon: const Icon(
        Icons.navigate_next,
      ),
      onTap: () async {
        controller.value = await onClicked(controller.value);
      },
    );
  }
}
