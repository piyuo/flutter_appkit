import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/src/app/configuration.dart';

void main() {
  group('[configuration]', () {
    test('should set/get variable', () {
      appID = 'piyuo-app';
      userID = '1-2';
      expect(appID, 'piyuo-app');
      expect(userID, '1-2');
    });
  });
}
