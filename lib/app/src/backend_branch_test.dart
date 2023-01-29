// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/preferences/preferences.dart' as preferences;
import 'backend_branch.dart';

void main() {
  preferences.initForTest({});

  group('[app.backend_branch]', () {
    test('should set/get backend branch', () async {
      await setBackendBranch(kBranchStable);
      final branch = await getBackendBranch();
      expect(branch, kBranchStable);

      await setBackendBranch(kBranchBeta);
      final branch2 = await getBackendBranch();
      expect(branch2, kBranchBeta);

      await setBackendBranch(kBranchStable);
      final branch3 = await getBackendBranch();
      expect(branch3, kBranchStable);
    });

    test('should set/get backend url', () async {
      await setBackendBranch(kBranchStable);
      final url = await getBackendBranchUrl();
      expect(url, '');

      await setBackendBranch(kBranchBeta);
      final url2 = await getBackendBranchUrl();
      expect(url2, '-beta');

      await setBackendBranch(kBranchStable);
      final url3 = await getBackendBranchUrl();
      expect(url3, '');
    });
  });
}
