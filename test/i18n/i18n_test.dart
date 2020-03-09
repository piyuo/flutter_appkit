import 'package:flutter_test/flutter_test.dart';
import 'package:libui/i18n/i18n.dart' as i18n;
import 'package:libui/i18n/i18n_state.dart';

void main() {
  setUp(() async {});

  group('[i18n]', () {
    test('should set/get global variable', () async {
      i18n.localeID = 'en_US';
      expect(i18n.localeID, 'en_US');
    });
  });
}
