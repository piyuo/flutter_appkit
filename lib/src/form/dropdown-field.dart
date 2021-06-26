import 'package:flutter/material.dart';
import 'field.dart';

/// DropdownField for simple dropdown selection
class DropdownField extends Field {
  /// controller is dropdown value controller
  final TextEditingController controller;

  /// items is items user can select
  final Map items;

  DropdownField({
    required this.controller,
    required this.items,
    String? label,
    String? required,
    FormFieldValidator<String>? validator,
    FocusNode? focusNode,
  }) : super(
          label: label,
          required: required,
          validator: validator,
          focusNode: focusNode,
        ) {}

  @override
  bool isEmpty() => controller.text.isEmpty;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      items: items.entries
          .map((entry) => DropdownMenuItem<String>(
                child: Text(
                  entry.value,
                  textWidthBasis: TextWidthBasis.parent,
                  overflow: TextOverflow.ellipsis,
                ),
                value: entry.key,
              ))
          .toList(),
      isExpanded: true,
      focusNode: focusNode,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onChanged: (String? value) {
        controller.text = value ?? '';
      },
      value: controller.text.isEmpty ? null : controller.text,
      validator: defaultValidator,
      decoration: defaultDecoration,
    );
  }
}
