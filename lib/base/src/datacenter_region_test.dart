// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:flutter_test/flutter_test.dart';
import 'datacenter_region.dart';

void main() {
  setUp(() {});

  group('[util]', () {
    test('should force region', () async {
      expect(findGoogleDataCenterByCountryCode('KR'), 'JP');
      expect(findGoogleDataCenterByCountryCode('DE'), 'BE');
      expect(findGoogleDataCenterByCountryCode('NotExists'), 'US');
    });
  });
}
