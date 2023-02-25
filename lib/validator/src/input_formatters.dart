import 'dart:core';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:libcli/i18n/i18n.dart' as i18n;

TextEditingValue currencyFormatter(TextEditingValue oldValue, TextEditingValue newValue) {
  if (newValue.selection.baseOffset == 0) {
    return newValue;
  }
  double value = double.parse(newValue.text);
  final formatter = NumberFormat.simpleCurrency(locale: i18n.localeKey);
  String newText = formatter.format(value);
  return newValue.copyWith(text: newText, selection: TextSelection.collapsed(offset: newText.length));
//      selection: new TextSelection.collapsed());
}

// decimalNumberFormatter only accept 0-9 and .
FilteringTextInputFormatter get decimalNumberFormatter => FilteringTextInputFormatter.allow(RegExp(r"[0-9.]"));
