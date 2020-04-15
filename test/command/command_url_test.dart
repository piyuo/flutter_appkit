import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/command.dart' as command;
import 'package:libcli/common.dart' as configuration;

void main() {
  command.mockCommand();
  group('[command_url_test]', () {
    test('should use serviceUrl', () async {
      configuration.branch = configuration.Branches.debug;
      expect(command.serviceUrl('mock', 80), 'http://localhost:80/mock');
    });
  });
}
