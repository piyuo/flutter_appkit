import 'package:flutter_test/flutter_test.dart';
import 'unique.dart';

void main() {
  group('[unique]', () {
    test('should generate unique id', () {
      String i = generate(4);
      expect(i, isNotEmpty);
    });

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
