// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';

import 'random.dart';

void main() {
  group('[utils.radom]', () {
    test('should generate random number string', () {
      String i = randomNumber(6);
      expect(i.length, 6);
    });
  });
}
