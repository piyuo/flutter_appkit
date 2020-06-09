import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/command.dart';
import 'package:libcli/i18n.dart' as i18n;
import 'package:libcli/configuration.dart';

void main() {
  mockCommand();
  group('[command_url_test]', () {
    test('should use stable url', () async {
      setBranch(BRANCH_STABLE);
      serviceRegion = 'us';
      expect(serviceUrl('mock'), 'https://mock-us.piyuo.com/?q');
    });

    test('should use master url', () async {
      setBranch(BRANCH_MASTER);
      serviceRegion = 'us';
      expect(serviceUrl('mock'), 'https://mock-us-master.piyuo.com/?q');
    });

    test('should use defult url', () async {
      setBranch(BRANCH_MASTER);
      i18n.userPreferCountryCode = null;
      serviceRegion = null;
      expect(serviceUrl('mock'), 'https://mock-us-master.piyuo.com/?q');
    });

    test('should use beta url', () async {
      setBranch(BRANCH_BETA);
      i18n.userPreferCountryCode = 'tw';
      serviceRegion = null;
      //tw using jp data center
      expect(serviceUrl('mock'), 'https://mock-jp-beta.piyuo.com/?q');
    });

    test('should use service country', () async {
      setBranch(BRANCH_BETA);
      i18n.userPreferCountryCode = 'tw';
      serviceRegion = 'us';
      expect(serviceUrl('mock'), 'https://mock-us-beta.piyuo.com/?q');
    });
  });
}
