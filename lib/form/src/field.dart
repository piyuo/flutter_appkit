import 'package:flutter/material.dart';

abstract class Field<T> extends StatelessWidget {
  const Field({
    required Key key, // all field must have key, it's important for test and identify field
    this.label,
    this.hint,
    this.require,
    this.validator,
    this.focusNode,
    this.nextFocusNode,
  }) : super(key: key);

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

  /// you need override this method to provide is value empty
  bool isEmpty();

  /// validate value return error message if value is not validate
  String? validate(T? value) {
    if (require != null && value == null) {
      return require;
    }

    if (validator != null) {
      return validator!(value);
    }
    return null;
  }

  InputDecoration get defaultDecoration => InputDecoration(
        labelText: label,
        hintText: hint,
      );
}
