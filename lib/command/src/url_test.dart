import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/i18n/i18n.dart' as i18n;
import 'package:libcli/app/app.dart' as app;
import 'url.dart';

void main() {
  group('[command_url_test]', () {
    test('should use default url', () async {
      // ignore: invalid_use_of_visible_for_testing_member
      app.branch = app.branchMaster;
      expect(serviceUrl('mock'), 'https://mock-us-master.piyuo.com/?q');
    });

    test('should use stable url', () async {
      // ignore: invalid_use_of_visible_for_testing_member
      app.branch = app.branchStable;
      serviceRegion = 'US';
      expect(serviceUrl('mock'), 'https://mock-us.piyuo.com/?q');
    });

    test('should use master url', () async {
      // ignore: invalid_use_of_visible_for_testing_member
      app.branch = app.branchMaster;
      serviceRegion = 'US';
      expect(serviceUrl('mock'), 'https://mock-us-master.piyuo.com/?q');
    });

    test('should use beta url', () async {
      // ignore: invalid_use_of_visible_for_testing_member
      app.branch = app.branchBeta;
      i18n.localeName = 'en_US';
      serviceRegion = '';
      //TW using JP data center
      expect(serviceUrl('mock'), 'https://mock-us-beta.piyuo.com/?q');
    });

    test('should use service country', () async {
      // ignore: invalid_use_of_visible_for_testing_member
      app.branch = app.branchBeta;
      i18n.localeName = 'zh_TW';
      serviceRegion = 'US';
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
