import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/i18n.dart' as i18n;
import 'package:libcli/env.dart' as env;
import 'package:libcli/src/command/url.dart';

void main() {
  group('[command_url_test]', () {
    test('should use default url', () async {
      // ignore: invalid_use_of_visible_for_testing_member
      env.branch = env.branchMaster;
      expect(serviceUrl('mock'), 'https://mock-us-master.piyuo.com/?q');
    });

    test('should use stable url', () async {
      // ignore: invalid_use_of_visible_for_testing_member
      env.branch = env.branchStable;
      serviceRegion = 'US';
      expect(serviceUrl('mock'), 'https://mock-us.piyuo.com/?q');
    });

    test('should use master url', () async {
      // ignore: invalid_use_of_visible_for_testing_member
      env.branch = env.branchMaster;
      serviceRegion = 'US';
      expect(serviceUrl('mock'), 'https://mock-us-master.piyuo.com/?q');
    });

    test('should use beta url', () async {
      // ignore: invalid_use_of_visible_for_testing_member
      env.branch = env.branchBeta;
      i18n.country = i18n.us;
      serviceRegion = '';
      //TW using JP data center
      expect(serviceUrl('mock'), 'https://mock-us-beta.piyuo.com/?q');
    });

    test('should use service country', () async {
      // ignore: invalid_use_of_visible_for_testing_member
      env.branch = env.branchBeta;
      i18n.country = i18n.tw;
      serviceRegion = i18n.us;
      expect(serviceUrl('mock'), 'https://mock-us-beta.piyuo.com/?q');
    });

    test('should force region', () async {
      setServiceRegionByCountryCode('KR');
      expect(serviceRegion, 'JP');
      setServiceRegionByCountryCode('DE');
      expect(serviceRegion, 'BE');
      setServiceRegionByCountryCode('NotExists');
      expect(serviceRegion, 'US');
      serviceRegion = '';
    });
  });
}
