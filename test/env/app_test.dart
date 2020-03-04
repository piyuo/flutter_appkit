import 'package:flutter_test/flutter_test.dart';

import 'package:libcli/env/env.dart';

void main() {
  group('[app]', () {
    test('should set variable', () {
      envAppID = 'piyuo-web-index';
      envUserID = '111-222';
      envBranch = Branch.debug;
      envRegion = Region.us;
      expect(envAppID, 'piyuo-web-index');
    });
  });
}
