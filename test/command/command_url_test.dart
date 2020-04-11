import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/command.dart' as command;
import 'package:libcli/hook.dart' as vars;

void main() {
  command.mock();
  group('[command_url_test]', () {
    test('should use serviceUrl', () async {
      vars.branch = vars.Branches.debug;
      expect(command.serviceUrl('mock', 80), 'http://localhost:80/mock');
    });
  });
}
