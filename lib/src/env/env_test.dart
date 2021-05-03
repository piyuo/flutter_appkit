import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/src/env/env.dart';

void main() {
  group('[configuration]', () {
    test('should set/get variable', () {
      name = 'piyuo-app';
      userID = '1-2';
      expect(name, 'piyuo-app');
      expect(userID, '1-2');
    });
  });
}
