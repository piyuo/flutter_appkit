import 'package:flutter/material.dart';
import 'package:libcli/i18n/i18n.dart' as i18n;

abstract class Field<T> extends StatelessWidget {
  const Field({
    required Key key, // all field must have key, it's important for test and identify field
    required this.controller, // all field must have key, it's important for test and identify field
    this.label,
    this.hint,
    this.validator,
    this.focusNode,
    this.nextFocusNode,
    this.requiredField = false,
  }) : super(key: key);

  /// controller is field value controller
  final ValueNotifier<T?> controller;

  /// label will show when value is not empty
  final String? label;

  /// hint will show when value is empty
  final String? hint;

  // requiredField set to true will show error when value is null || empty. it will use label in error message
  final bool requiredField;

  // validator can set custom validator
  final FormFieldValidator<T>? validator;

  final FocusNode? focusNode;

  final FocusNode? nextFocusNode;

  /// validate value return error message if value is not validate
  String? validate(BuildContext context, T? value) {
    if (value == null || value.toString().isEmpty || (value is TextEditingValue && value.text.isEmpty)) {
      return context.i18n.fieldRequired;
    }

    if (validator != null) {
      return validator!(value);
    }
    return null;
  }
}
