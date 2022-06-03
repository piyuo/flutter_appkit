import 'package:flutter_test/flutter_test.dart';
import 'random.dart';

void main() {
  group('[generator]', () {
    test('should generate random number string', () {
      String i = randomNumber(6);
      expect(i.length, 6);
    });
  });
}
