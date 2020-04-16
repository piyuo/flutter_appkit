import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/src/log/analytic.dart' as analytic;
import 'package:libcli/command.dart' as command;
import 'package:libcli/configuration.dart' as configuration;
import 'package:libcli/log.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _here = 'analytic_test';

void main() {
  SharedPreferences.setMockInitialValues({});

  group('[analytic]', () {
    test('should set time', () {
      var time = command.Timestamp.fromDateTime(DateTime.now());
      expect(time != null, true);
    });

    test('should log', () async {
      analytic.clear();
      var current = analytic.current();
      expect(current.logs.length, 0);
      warning('$_here~mock warning');
      expect(current.logs.length, 1);
      configuration.branch = configuration.Branches.test;
      var result = await analytic.post(null);
      expect(result, true);
    });

    test('should error', () async {
      configuration.branch = configuration.Branches.test;
      analytic.clear();
      var current = analytic.current();
      expect(current.errors.length, 0);
      try {
        throw Exception('test error');
      } catch (e, s) {
        error(_here, e, s);
      }
      expect(current.errors.length, 1);
      var result = await analytic.post(null);
      expect(result, true);
    });

    test('should return false if no logs or errors', () async {
      analytic.clear();
      var result = await analytic.post(null);
      expect(result, false);
    });
  });
}
