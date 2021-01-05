import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/i18n.dart' as i18n;
import 'package:flutter/widgets.dart';

void main() {
  // ignore: invalid_use_of_visible_for_testing_member
  i18n.mockI18n(Locale('en', 'US'), '{"a": "A"}');

  setUp(() async {});

  group('[i18n-global]', () {
    test('should have global translation', () async {
      expect(i18n.globalTranslate('ok'), 'OK');
    });
  });
}
