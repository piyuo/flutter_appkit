import 'package:flutter/material.dart';
import 'field.dart';

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
    Key? key,
  }) : super(
          key: key,
          label: label,
          required: required,
          validator: validator,
          focusNode: focusNode,
        ) {}

  @override
  bool isEmpty() => controller.text.isEmpty;

  @override
  DropdownFieldState createState() => DropdownFieldState();
}

class DropdownFieldState extends State<DropdownField> {
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      items: widget.items.entries
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
      focusNode: widget.focusNode,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onChanged: (String? value) {
        value = value ?? '';
        setState(() => widget.controller.text = value!);
      },
      value: widget.controller.text.isEmpty ? null : widget.controller.text,
      validator: widget.defaultValidator,
      decoration: widget.defaultDecoration,
    );
  }
}
