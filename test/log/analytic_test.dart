import 'package:flutter_test/flutter_test.dart';

import 'package:libcli/log/analytic.dart' as analytic;
import 'package:libcli/command/commands/google/timestamp.pb.dart' as timestamp;
import 'package:libcli/hook/vars.dart' as vars;
import 'package:libcli/log/log.dart' as log;
import 'package:shared_preferences/shared_preferences.dart';

const _here = 'analytic_test';

void main() {
  SharedPreferences.setMockInitialValues({});

  group('[analytic]', () {
    test('should set time', () {
      var time = timestamp.Timestamp.fromDateTime(DateTime.now());
      expect(time != null, true);
    });

    test('should log', () async {
      analytic.clear();
      var current = analytic.current();
      expect(current.logs.length, 0);
      '$_here|mock warning'.warning;
      expect(current.logs.length, 1);
      vars.Branch = vars.Branches.test;
      var result = await analytic.post();
      expect(result, true);
    });

    test('should error', () async {
      vars.Branch = vars.Branches.test;
      analytic.clear();
      var current = analytic.current();
      expect(current.errors.length, 0);
      try {
        throw Exception('test error');
      } catch (e, s) {
        _here.error(e, s);
      }
      expect(current.errors.length, 1);
      var result = await analytic.post();
      expect(result, true);
    });

    test('should return false if no logs or errors', () async {
      analytic.clear();
      var result = await analytic.post();
      expect(result, false);
    });
  });
}
