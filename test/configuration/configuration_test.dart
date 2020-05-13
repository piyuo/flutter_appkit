import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/configuration.dart' as configuration;

void main() {
  group('[configuration]', () {
    test('should set/get variable', () {
      configuration.appID = 'piyuo-app';
      configuration.userID = '1-2';
      expect(configuration.appID, 'piyuo-app');
      expect(configuration.userID, '1-2');
    });
  });
}
