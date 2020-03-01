import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/command/command_url.dart' as commandUrl;
import 'package:libcli/app/app.dart' as app;

void main() {
  group('command_url_test', () {
    test('should get service url', () {
      app.branch = app.Branch.test;
      expect(commandUrl.branch(), 't');
      app.region = app.Region.us;
      expect(commandUrl.region(), 'us');
      expect(commandUrl.host(), 'us-central1');
      expect(commandUrl.region(), 'us');
      //expect(command.serviceUrl('sys',3001), 'https://us-central1-piyuo-t-us.cloudfunctions.net/sys');

      app.branch = app.Branch.debug;
      expect(commandUrl.serviceUrl('sys', 3001), 'http://localhost:3001/sys');
    });
  });
}
