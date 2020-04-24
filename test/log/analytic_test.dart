import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/src/log/analytic.dart' as analytic;
import 'package:libcli/command.dart' as command;
import 'package:libcli/configuration.dart' as configuration;
import 'package:libcli/log.dart';
import 'package:libcli/commands_sys.dart' as commandsSys;

const _here = 'analytic_test';

void main() {
  setUp(() async {
    analytic.sysService = commandsSys.SysService()
      ..mockExecute = (ctx, act) async {
        return await command.ok;
      };
  });

  group('[analytic]', () {
    test('should set time', () {
      var time = command.Timestamp.fromDateTime(DateTime.now());
      expect(time != null, true);
    });

    test('should log', () async {
      analytic.reset();
      var current = analytic.current();
      expect(current.logs.length, 0);
      warning('$_here~mock warning');
      expect(current.logs.length, 1);
      configuration.branch = configuration.Branches.test;
      var id = await analytic.sendAnalytic();
      expect(id, isNotEmpty);
    });

    test('should error', () async {
      configuration.branch = configuration.Branches.test;
      analytic.reset();
      var current = analytic.current();
      expect(current.errors.length, 0);
      try {
        throw Exception('test error');
      } catch (e, s) {
        error(_here, e, s);
      }
      expect(current.errors.length, 1);
      var result = await analytic.sendAnalytic();
      expect(result, isNotEmpty);
    });

    test('should have no id if no logs or errors', () async {
      analytic.reset();
      var id = await analytic.sendAnalytic();
      expect(id, isEmpty);
    });
  });
}
