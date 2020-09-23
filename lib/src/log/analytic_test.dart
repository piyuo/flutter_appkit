import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/src/log/analytic.dart';

import 'package:libcli/command.dart' as command;
import 'package:libcli/log.dart';
import 'package:libcli/configuration.dart';

const _here = 'analytic_test';

void main() {
  setUp(() async {
    // ignore: invalid_use_of_visible_for_testing_member
    sysService = command.MockService((ctx, act) async {
      return command.ok();
    });
  });

  group('[analytic]', () {
    test('should set time', () {
      var time = command.Timestamp.fromDateTime(DateTime.now());
      expect(time != null, true);
    });

    test('should log', () async {
      reset();
      // ignore: invalid_use_of_visible_for_testing_member
      var curr = current();
      expect(curr.logs.length, 0);
      warning('$_here~mock warning');
      expect(curr.logs.length, 1);
      setBranch(BRANCH_MASTER);
      var id = await sendAnalytic();
      expect(id, isNotEmpty);
    });

    test('should error', () async {
      setBranch(BRANCH_MASTER);
      reset();
      // ignore: invalid_use_of_visible_for_testing_member
      var curr = current();
      expect(curr.errors.length, 0);
      try {
        throw Exception('test error');
      } catch (e, s) {
        error(_here, e, s);
      }
      expect(curr.errors.length, 1);
      var result = await sendAnalytic();
      expect(result, isNotEmpty);
    });

    test('should have no id if no logs or errors', () async {
      reset();
      var id = await sendAnalytic();
      expect(id, isEmpty);
    });
  });
}
