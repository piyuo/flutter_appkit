import 'package:flutter_test/flutter_test.dart';

import 'package:libcli/hook.dart';

void main() {
  group('[vars]', () {
    test('should set/get variable', () {
      appID = 'piyuo-app';
      userID = '1-2';
      branch = Branches.debug;
      region = Regions.us;
      expect(appID, 'piyuo-app');
      expect(userID, '1-2');
      expect(branch, Branches.debug);
      expect(region, Regions.us);
    });

    test('should set current branch', () {
      branch = Branches.test;
      expect(branchString(), 't');
      region = Regions.us;
      expect(regionString(), 'us');
      expect(host(), 'us-central1');
    });
  });
}
