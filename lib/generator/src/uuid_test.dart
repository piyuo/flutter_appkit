import 'package:flutter_test/flutter_test.dart';
import 'uuid.dart';

void main() {
  group('[generator]', () {
    test('should generate uuid', () {
      String i = uuid();
      expect(i, isNotEmpty);
    });
  });
}
