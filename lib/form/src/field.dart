import 'package:flutter/material.dart';

abstract class Field<T> extends StatelessWidget {
  const Field({
    required Key key, // all field must have key, it's important for test and identify field
    required this.controller, // all field must have key, it's important for test and identify field
    this.label,
    this.hint,
    this.require,
    this.validator,
    this.focusNode,
    this.nextFocusNode,
  }) : super(key: key);

  /// controller is field value controller
  final ValueNotifier<T?> controller;

  /// label will show when value is not empty
  final String? label;

  /// hint will show when value is empty
  final String? hint;

  // required set to string will trigger validator and will show when value is empty
  final String? require;

  // validator can set custom validator
  final FormFieldValidator<T>? validator;

  final FocusNode? focusNode;

  final FocusNode? nextFocusNode;

  /// validate value return error message if value is not validate
  String? validate(T? value) {
    if (require != null) {
      if (value == null) {
        return require;
      }
      if (value is String && value.isEmpty) {
        return require;
      }
    }

    if (validator != null) {
      return validator!(value);
    }
    return null;
  }
}
