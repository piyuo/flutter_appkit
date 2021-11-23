// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/i18n/i18n.dart' as i18n;
import 'package:libcli/app/app.dart' as app;
import 'url.dart';

void main() {
  group('[command_url_test]', () {
    test('should use default url', () async {
      app.branch = app.branchMaster;
      expect(serviceUrl('mock'), 'https://mock-us-master.piyuo.com/?q');
    });

    test('should use stable url', () async {
      app.branch = app.branchStable;
      serviceRegion = 'US';
      expect(serviceUrl('mock'), 'https://mock-us.piyuo.com/?q');
    });

    test('should use master url', () async {
      app.branch = app.branchMaster;
      serviceRegion = 'US';
      expect(serviceUrl('mock'), 'https://mock-us-master.piyuo.com/?q');
    });

    test('should use beta url', () async {
      app.branch = app.branchBeta;
      i18n.mockLocale('en_US');
      serviceRegion = '';
      //TW using JP data center
      expect(serviceUrl('mock'), 'https://mock-us-beta.piyuo.com/?q');
    });

    test('should use service country', () async {
      app.branch = app.branchBeta;
      i18n.mockLocale('zh_TW');
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
