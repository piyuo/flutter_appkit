import 'package:intl/intl.dart';
import 'i18n.dart';

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
