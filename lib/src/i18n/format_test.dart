import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'format.dart';

void main() {
  setUp(() async {});

  group('[i18n_format]', () {
    test('should get english number format', () async {
      expect(numberFormat, isNotNull);
      expect(currencySymbol, '\$');
      expect(currencyName, 'USD');
      expect(formatMoney(10.99), '\$10.99');
      expect(formatNumber(1000.99), '1,000.99');
      expect(formatNumber(-1000.99), '-1,000.99');
      expect(formatPercentage(.99), '99%');
    });

    test('should get chinese number format', () async {
      Intl.defaultLocale = 'zh_CN';
      expect(numberFormat, isNotNull);
      expect(currencySymbol, '¥');
      expect(currencyName, 'CNY');
      expect(formatMoney(10.99), '¥10.99');
      expect(formatNumber(1000.99), '1,000.99');
      expect(formatNumber(-1000.99), '-1,000.99');
      expect(formatPercentage(.99), '99%');
    });
  });
}
