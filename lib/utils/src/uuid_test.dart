import 'package:flutter_test/flutter_test.dart';
import 'uuid.dart';

void main() {
  group('[utils.uuid]', () {
    test('should generate uuid', () {
      String i = uuid();
      expect(i, isNotEmpty);
    });
  });
}
