import 'package:flutter_test/flutter_test.dart';
import 'l10n.dart';
import 'package:intl/intl.dart';

void main() {
  setUp(() async {});

  group('[l10n]', () {
    test('should lookup', () async {
      expect(lookup('a', 'test', _enUS, zhTW: _zhTW, zhCN: _zhCN), '1');
      Intl.defaultLocale = 'zh_TW';
      expect(lookup('a', 'test', _enUS, zhTW: _zhTW, zhCN: _zhCN), '2');
      Intl.defaultLocale = 'zh_CN';
      expect(lookup('a', 'test', _enUS, zhTW: _zhTW, zhCN: _zhCN), '3');
      Intl.defaultLocale = 'en_US';
    });
  });
}

String? _enUS(String key) => {
      'a': '1',
    }[key];

String? _zhTW(String key) => {
      'a': '2',
    }[key];

String? _zhCN(String key) => {
      'a': '3',
    }[key];
