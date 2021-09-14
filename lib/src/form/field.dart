import 'package:flutter/material.dart';

abstract class Field extends StatelessWidget {
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
  final FormFieldValidator<String>? validator;

  final FocusNode? focusNode;

  final FocusNode? nextFocusNode;

  /// you need override this method to provide is value empty
  bool isEmpty();

  String? defaultValidator(String? text) {
    if (validator != null) {
      return validator!(text);
    }
    if (require != null) {
      if (text == null || text.trim().isEmpty) {
        return require;
      }
    }
    return null;
  }

  InputDecoration get defaultDecoration => InputDecoration(
        labelText: label,
        hintText: hint,
      );
}
