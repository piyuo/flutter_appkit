import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RegexpTextInputFormatter extends TextInputFormatter {
  /// A [regexp] to be match
  ///
  final RegExp regexp;

  /// Creates a formatter that allows only the insertion of regexp match
  ///
  /// The [regexp] must not be null.
  RegexpTextInputFormatter(this.regexp) : assert(regexp != null);

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue, // unused.
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }
    if (regexp.hasMatch(newValue.text)) {
      return newValue;
    }
    return oldValue;
  }
}
