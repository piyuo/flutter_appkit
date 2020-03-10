import 'package:flutter_test/flutter_test.dart';

import 'package:libcli/hook/vars.dart';

void main() {
  group('[vars]', () {
    test('should set/get variable', () {
      AppID = 'piyuo-app';
      UserID = '1-2';
      Branch = Branches.debug;
      Region = Regions.us;
      expect(AppID, 'piyuo-app');
      expect(UserID, '1-2');
      expect(Branch, Branches.debug);
      expect(Region, Regions.us);
    });

    test('should set current branch', () {
      Branch = Branches.test;
      expect(branch(), 't');
      Region = Regions.us;
      expect(region(), 'us');
      expect(host(), 'us-central1');
    });
  });
}
