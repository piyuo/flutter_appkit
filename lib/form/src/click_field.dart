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
    bool requiredField = false,
    FocusNode? focusNode,
    FocusNode? nextFocusNode,
  }) : super(
          key: key,
          controller: controller,
          validator: validator,
          label: label,
          requiredField: requiredField,
          focusNode: focusNode,
          nextFocusNode: nextFocusNode,
        );

  /// onClicked return new result
  final Future<T?> Function(T? value) onClicked;

  /// valueToString convert value to string
  final String Function(T?) valueToString;

  /// superValidate use field validate
  String? superValidate(BuildContext context, T? value) => super.validate(context, value);

  @override
  Widget build(BuildContext context) {
    return CustomField<T>(
      label: label,
      focusNode: focusNode,
      nextFocusNode: nextFocusNode,
      controller: controller,
      validator: (T? value) => super.validate(context, value),
      suffixIcon: const Icon(
        Icons.navigate_next,
      ),
      builder: () => InkWell(
        focusNode: focusNode,
        onTap: () async {
          controller.value = await onClicked(controller.value);
        },
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
          child: Text(valueToString(controller.value), style: Theme.of(context).textTheme.subtitle1),
        ),
      ),
    );
  }
}
