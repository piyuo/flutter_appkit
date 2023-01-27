// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:flutter_test/flutter_test.dart';
import 'url.dart';

void main() {
  group('[command_url_test]', () {
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
