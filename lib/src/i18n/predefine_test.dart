import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/src/i18n/predefine.dart';

void main() {
  setUp(() async {});

  group('[predefine]', () {
    test('should get text', () async {
      expect(predefine('ok'), 'OK');
    });
    test('should replace', () async {
      expect(replace('required', '%1', 'replace'), contains('replace'));
    });
  });
}
