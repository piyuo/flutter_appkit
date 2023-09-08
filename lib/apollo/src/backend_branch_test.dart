// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/preferences/preferences.dart' as preferences;
import 'backend_branch.dart';

void main() {
  preferences.initForTest({});

  group('[base.backend_branch]', () {
    test('should set/get backend branch', () async {
      backendBranch = kBranchStable;
      final branch = backendBranch;
      expect(branch, kBranchStable);

      backendBranch = kBranchBeta;
      final branch2 = backendBranch;
      expect(branch2, kBranchBeta);

      backendBranch = kBranchStable;
      final branch3 = backendBranch;
      expect(branch3, kBranchStable);
    });
  });
}
