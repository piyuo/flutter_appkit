import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/src/env/env.dart';

void main() {
  group('[env]', () {
    test('should set/get variable', () {
      init(
        appName: 'appName',
        branch: branchMaster,
        serviceEmail: 'serviceEmail',
      );
      userID = '1-2';
      expect(userID, '1-2');
      expect(appName, 'appName');
      expect(serviceEmail, 'serviceEmail');
      expect(branch, branchMaster);
    });
  });
}
