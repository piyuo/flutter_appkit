import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/src/command/url.dart';
import 'package:libcli/i18n.dart' as i18n;
import 'package:libcli/env.dart' as env;

void main() {
  group('[command_url_test]', () {
    test('should use default url', () async {
      env.branch = env.BRANCH_MASTER;
      expect(serviceUrl('mock'), 'https://mock-us-master.piyuo.com/?q');
    });

    test('should use stable url', () async {
      env.branch = env.BRANCH_STABLE;
      serviceRegion = 'US';
      expect(serviceUrl('mock'), 'https://mock-us.piyuo.com/?q');
    });

    test('should use master url', () async {
      env.branch = env.BRANCH_MASTER;
      serviceRegion = 'US';
      expect(serviceUrl('mock'), 'https://mock-us-master.piyuo.com/?q');
    });

    test('should use beta url', () async {
      env.branch = env.BRANCH_BETA;
      i18n.userPreferCountryCode = 'TW';
      serviceRegion = '';
      //TW using JP data center
      expect(serviceUrl('mock'), 'https://mock-jp-beta.piyuo.com/?q');
    });

    test('should use service country', () async {
      env.branch = env.BRANCH_BETA;
      i18n.userPreferCountryCode = 'TW';
      serviceRegion = 'US';
      expect(serviceUrl('mock'), 'https://mock-us-beta.piyuo.com/?q');
    });
  });
}
