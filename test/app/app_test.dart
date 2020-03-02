import 'package:flutter_test/flutter_test.dart';

import 'package:libcli/app/app.dart' as app;

void main() {
  group('app', () {
    test('should set variable', () {
      app.piyuoid = 'piyuo-web-index';
      app.identity = '111-222';
      app.branch = app.Branch.debug;
      app.region = app.Region.us;
      expect(app.piyuoid, 'piyuo-web-index');
    });
  });
}
