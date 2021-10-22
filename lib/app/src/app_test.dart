import 'package:flutter_test/flutter_test.dart';
import 'app.dart';

void main() {
  group('[env]', () {
    test('should set/get variable', () {
      userID = '1-2';
      expect(userID, '1-2');
    });
  });
}
