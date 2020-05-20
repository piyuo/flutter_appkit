import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/command.dart';
import 'package:libcli/i18n.dart' as i18n;

void main() {
  mockCommand();
  group('[command_url_test]', () {
    test('should use debug url', () async {
      serviceBranch = BRANCH_DEBUG;
      expect(serviceUrl('mock', 80), 'http://localhost:80/mock');
    });

    test('should use defult url', () async {
      i18n.userPreferCountryCode = null;
      serviceCountry = null;
      serviceBranch = BRANCH_MASTER;
      expect(serviceUrl('mock', 80),
          'https://us-central1-piyuo-us.cloudfunctions.net/mock');
    });

    test('should use beta url', () async {
      i18n.userPreferCountryCode = 'tw';
      serviceCountry = null;
      serviceBranch = BRANCH_BETA;
      expect(serviceUrl('mock', 80),
          'https://asia-east2-piyuo-beta-cn.cloudfunctions.net/mock');
    });

    test('should use service country', () async {
      i18n.userPreferCountryCode = 'tw';
      serviceCountry = 'us';
      serviceBranch = BRANCH_BETA;
      expect(serviceUrl('mock', 80),
          'https://us-central1-piyuo-beta-us.cloudfunctions.net/mock');
    });
  });
}
