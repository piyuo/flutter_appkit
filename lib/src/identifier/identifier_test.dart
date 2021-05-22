import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/src/identifier/identifier.dart';

void main() {
  group('[identifier]', () {
    test('should generate uuid', () {
      String i = uuid();
      expect(i, isNotEmpty);
    });

    test('should generate random number string', () {
      String i = randomNumber(6);
      expect(i.length, 6);
    });
  });
}
