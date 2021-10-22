import 'package:flutter_test/flutter_test.dart';
import 'app.dart';

void main() {
  group('[app.app]', () {
    test('should set/get variable', () {
      userID = '1-2';
      expect(userID, '1-2');
    });
  });
}
