import 'package:intl/intl.dart';
import 'i18n.dart';
import 'dart:math';

/// numberFormat return current number format
NumberFormat get numberFormat {
  return NumberFormat.decimalPattern(localeName);
}

/// numberFormat return current currency format
NumberFormat get currencyFormat {
  return NumberFormat.simpleCurrency(locale: localeName);
}

/// numberFormat return current currency symbol
///
///     expect(currencySymbol, '\$');
///
String get currencySymbol {
  return currencyFormat.currencySymbol;
}

/// currencyName return current currency name
///
///     expect(currencyName, 'USD');
///
String get currencyName {
  return currencyFormat.currencyName ?? '';
}

/// formatMoney format value to currency format
///
///     expect(formatMoney(10.99), '\$10.99');
///
String formatMoney(dynamic value) {
  return currencyFormat.format(value);
}

/// formatNumber format value to number format
///
///     expect(formatNumber(1000.99), '1,000.99');
///
String formatNumber(dynamic value) {
  return numberFormat.format(value);
}

/// formatPercentage format value to percentage
///
///     expect(formatPercentage(.99), '99%');
///
String formatPercentage(dynamic value) {
  return NumberFormat.percentPattern(localeName).format(value);
}

/// formatBytes format value to computer size like bytes, KB, MB, GB, TB
///
///     expect(formatBytes(2 * 1024 * 1024, 2), '2.00 MB');
///
String formatBytes(int bytes, int decimals) {
  if (bytes <= 0) return "0 B";
  const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
  var i = (log(bytes) / log(1024)).floor();
  return ((bytes / pow(1024, i)).toStringAsFixed(decimals)) + ' ' + suffixes[i];
}
