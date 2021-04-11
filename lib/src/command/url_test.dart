import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/src/command/url.dart';
import 'package:libcli/src/i18n/i18n.dart' as i18n;
import 'package:libcli/src/application/application.dart' as application;

void main() {
  group('[command_url_test]', () {
    test('should use default url', () async {
      application.branch = application.BRANCH_MASTER;
      expect(serviceUrl('mock'), 'https://mock-us-master.piyuo.com/?q');
    });

    test('should use stable url', () async {
      application.branch = application.BRANCH_STABLE;
      serviceRegion = 'US';
      expect(serviceUrl('mock'), 'https://mock-us.piyuo.com/?q');
    });

    test('should use master url', () async {
      application.branch = application.BRANCH_MASTER;
      serviceRegion = 'US';
      expect(serviceUrl('mock'), 'https://mock-us-master.piyuo.com/?q');
    });

    test('should use beta url', () async {
      application.branch = application.BRANCH_BETA;
      i18n.userPreferCountryCode = 'TW';
      serviceRegion = '';
      //TW using JP data center
      expect(serviceUrl('mock'), 'https://mock-jp-beta.piyuo.com/?q');
    });

    test('should use service country', () async {
      application.branch = application.BRANCH_BETA;
      i18n.userPreferCountryCode = 'TW';
      serviceRegion = 'US';
      expect(serviceUrl('mock'), 'https://mock-us-beta.piyuo.com/?q');
    });
  });
}
