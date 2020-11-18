import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/command.dart';
import 'package:libcli/i18n.dart' as i18n;
import 'package:libcli/app.dart' as config;

void main() {
  // ignore: invalid_use_of_visible_for_testing_member
  mockCommand();
  group('[command_url_test]', () {
    test('should use defult url', () async {
      config.branch = config.BRANCH_MASTER;
      expect(serviceUrl('mock'), 'https://mock-us-master.piyuo.com/?q');
    });

    test('should use stable url', () async {
      config.branch = config.BRANCH_STABLE;
      serviceRegion = 'US';
      expect(serviceUrl('mock'), 'https://mock-us.piyuo.com/?q');
    });

    test('should use master url', () async {
      config.branch = config.BRANCH_MASTER;
      serviceRegion = 'US';
      expect(serviceUrl('mock'), 'https://mock-us-master.piyuo.com/?q');
    });

    test('should use beta url', () async {
      config.branch = config.BRANCH_BETA;
      i18n.userPreferCountryCode = 'TW';
      serviceRegion = '';
      //TW using JP data center
      expect(serviceUrl('mock'), 'https://mock-jp-beta.piyuo.com/?q');
    });

    test('should use service country', () async {
      config.branch = config.BRANCH_BETA;
      i18n.userPreferCountryCode = 'TW';
      serviceRegion = 'US';
      expect(serviceUrl('mock'), 'https://mock-us-beta.piyuo.com/?q');
    });
  });
}
