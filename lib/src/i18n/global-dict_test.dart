import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/src/i18n/global-dict.dart';

void main() {
  setUp(() async {});

  group('[i18n-global]', () {
    test('should have global translation', () async {
      expect(globalTranslate('ok'), 'OK');
    });
  });
}
