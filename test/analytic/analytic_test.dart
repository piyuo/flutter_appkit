import 'package:flutter_test/flutter_test.dart';

import 'package:libcli/analytic/analytic.dart' as analytic;
import 'package:libcli/command/commands/google/timestamp.pb.dart' as timestamp;
import 'package:libcli/app/app.dart' as app;
import 'package:libcli/log/log.dart' as log;

const _here = 'analytic_test';

void main() {
  group('analytic', () {
    test('should set time', () {
      var time = timestamp.Timestamp.fromDateTime(DateTime.now());
      expect(time != null, true);
    });

    test('should log', () async {
      analytic.clear();
      var current = analytic.current();
      expect(current.logs.length, 0);
      log.warning(_here, 'test log');
      expect(current.logs.length, 1);
      app.branch = app.Branch.test;
      var result = await analytic.post();
      expect(result, true);
    });

    test('should Error', () async {
      app.branch = app.Branch.test;
      analytic.clear();
      var current = analytic.current();
      expect(current.errors.length, 0);
      try {
        throw Exception('test error');
      } catch (e, s) {
        log.error(_here, e, s);
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
