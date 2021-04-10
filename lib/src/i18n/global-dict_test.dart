import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/widgets.dart';
import 'package:libcli/src/i18n/main.dart';
import 'package:libcli/src/i18n/global-dict.dart';

void main() {
  // ignore: invalid_use_of_visible_for_testing_member
  mock(Locale('en', 'US'), '{"a": "A"}');

  setUp(() async {});

  group('[i18n-global]', () {
    test('should have global translation', () async {
      expect(globalTranslate('ok'), 'OK');
    });
  });
}
