import 'package:flutter/material.dart';
import 'field.dart';

/// DropdownField for simple dropdown selection
class DropdownField extends Field {
  /// controller is dropdown value controller
  final TextEditingController controller;

  /// items is items user can select
  final Map items;

  const DropdownField({
    required this.controller,
    required this.items,
    required Key key,
    String? label,
    String? require,
    FormFieldValidator<String>? validator,
    FocusNode? focusNode,
    FocusNode? nextFocusNode,
  }) : super(
          label: label,
          require: require,
          validator: validator,
          focusNode: focusNode,
          nextFocusNode: nextFocusNode,
          key: key,
        );

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
      icon: const Icon(
        Icons.expand_more,
      ),
      isExpanded: true,
      focusNode: focusNode,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onChanged: (String? value) {
        controller.text = value ?? '';
        if (nextFocusNode != null) {
          nextFocusNode!.requestFocus();
        }
      },
      value: controller.text.isEmpty ? null : controller.text,
      validator: defaultValidator,
      decoration: defaultDecoration,
    );
  }
}
