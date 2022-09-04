import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'number.dart';

void main() {
  setUp(() async {});

  group('[i18n_format]', () {
    test('should get english number format', () async {
      expect(numberFormat, isNotNull);
      expect(currencySymbol, '\$');
      expect(currencyName, 'USD');
      expect(formatCurrency(10.99), '\$10.99');
      expect(formatNumber(1000.00), '1,000');
      expect(formatNumber(1000.99), '1,000.99');
      expect(formatNumber(-1000.99), '-1,000.99');
      expect(formatPercentage(.99), '99%');
    });

    test('should get chinese number format', () async {
      Intl.defaultLocale = 'zh_CN';
      expect(numberFormat, isNotNull);
      expect(currencySymbol, '¥');
      expect(currencyName, 'CNY');
      expect(formatCurrency(10.99), '¥10.99');
      expect(formatNumber(1000.99), '1,000.99');
      expect(formatNumber(-1000.99), '-1,000.99');
      expect(formatPercentage(.99), '99%');
    });

    test('should format bytes', () async {
      expect(formatBytes(10, 0), '10 B');
      expect(formatBytes(2 * 1024 + 8, 2), '2.01 KB');
      expect(formatBytes(2 * 1024 * 1024, 2), '2.00 MB');
      expect(formatBytes(2 * 1024 * 1024 * 1024, 2), '2.00 GB');
      expect(formatBytes(2 * 1024 * 1024 * 1024 * 1024, 2), '2.00 TB');
    });
  });
}
