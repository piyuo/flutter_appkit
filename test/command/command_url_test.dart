import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/command/command_url.dart' as commandUrl;
import 'package:libcli/env/env.dart';

void main() {
  group('[command_url_test]', () {
    test('should get service url', () {
      envBranch = Branch.test;
      expect(commandUrl.branch(), 't');
      envRegion = Region.us;
      expect(commandUrl.region(), 'us');
      expect(commandUrl.host(), 'us-central1');
      expect(commandUrl.region(), 'us');
      //expect(command.serviceUrl('sys',3001), 'https://us-central1-piyuo-t-us.cloudfunctions.net/sys');

      envBranch = Branch.debug;
      expect(commandUrl.serviceUrl('sys', 3001), 'http://localhost:3001/sys');
    });
  });
}
