import 'package:flutter_test/flutter_test.dart';
import 'uid.dart';

void main() {
  group('[uid]', () {
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
