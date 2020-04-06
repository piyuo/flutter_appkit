import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/command/command_url.dart' as commandUrl;
import 'package:libcli/command/command.dart' as command;
import 'package:libcli/hook/vars.dart' as vars;

void main() {
  command.mockInit();
  group('[command_url_test]', () {
    test('should use serviceUrl', () async {
      vars.branch = vars.Branches.debug;
      expect(commandUrl.serviceUrl('mock', 80), 'http://localhost:80/mock');
    });
  });
}
