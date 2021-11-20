import 'package:flutter/material.dart';
import 'field.dart';

/// DropdownField for simple dropdown selection
class DropdownField<T> extends Field<T> {
  const DropdownField({
    required ValueNotifier<T?> controller,
    required this.items,
    required Key key,
    String? label,
    bool requiredField = false,
    FormFieldValidator<T>? validator,
    FocusNode? focusNode,
    FocusNode? nextFocusNode,
  }) : super(
          label: label,
          controller: controller,
          requiredField: requiredField,
          validator: validator,
          focusNode: focusNode,
          nextFocusNode: nextFocusNode,
          key: key,
        );

  /// items is items user can select
  final Map items;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      items: items.entries
          .map((entry) => DropdownMenuItem<T>(
                child: Text(
                  entry.value,
                  textWidthBasis: TextWidthBasis.parent,
                  overflow: TextOverflow.ellipsis,
                ),
                value: entry.key,
              ))
          .toList(),
      icon: const Icon(
        Icons.expand_more,
      ),
      isExpanded: true,
      focusNode: focusNode,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onChanged: (T? value) {
        controller.value = value;
        if (nextFocusNode != null) {
          nextFocusNode!.requestFocus();
        }
      },
      value: controller.value,
      validator: (value) => validate(context, value),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
      ),
    );
  }
}
