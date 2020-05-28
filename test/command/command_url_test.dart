import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/command.dart';
import 'package:libcli/i18n.dart' as i18n;

void main() {
  mockCommand();
  group('[command_url_test]', () {
    test('should use production url', () async {
      serviceBranch = BRANCH_MASTER;
      serviceRegion = 'us';
      expect(serviceUrl('mock'), 'https://mock-us.api.piyuo.com');
    });

    test('should use defult url', () async {
      i18n.userPreferCountryCode = null;
      serviceRegion = null;
      serviceBranch = BRANCH_MASTER;
      expect(serviceUrl('mock'), 'https://mock-us.api.piyuo.com');
    });

    test('should use beta url', () async {
      i18n.userPreferCountryCode = 'tw';
      serviceRegion = null;
      serviceBranch = BRANCH_BETA;
      expect(serviceUrl('mock'), 'https://mock-jp.beta.piyuo.com');
    });

    test('should use service country', () async {
      i18n.userPreferCountryCode = 'tw';
      serviceRegion = 'us';
      serviceBranch = BRANCH_BETA;
      expect(serviceUrl('mock'), 'https://mock-us.beta.piyuo.com');
    });
  });
}
