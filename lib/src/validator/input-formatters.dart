import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import 'package:libcli/i18n.dart';

TextEditingValue currencyFormatter(
    TextEditingValue oldValue, TextEditingValue newValue) {
  if (newValue.selection.baseOffset == 0) {
    return newValue;
  }
  double value = double.parse(newValue.text);
  final formatter = NumberFormat.simpleCurrency(locale: localeID);
  String newText = formatter.format(value);
  return newValue.copyWith(
      text: newText,
//      selection: new TextSelection.collapsed(offset: newText.length));
      selection: new TextSelection.collapsed());
}
