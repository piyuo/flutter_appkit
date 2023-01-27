import 'package:libcli/i18n/i18n.dart' as i18n;

/// serviceMark
///
String baseDomain = 'piyuo.com';

/// serviceRegion is set if service need tie to specify region, usually when user sign in and they need to to same region where they create the account
///
String serviceRegion = '';

/// determineRegion return data center region base on user prefer country in user locale
///
String determineRegion() {
  return mapping(i18n.countryCode);
}

/// country code world map
/// https://www.nationsonline.org/gallery/World/World-map-all-country-codes.jpg

/// mapping country to nearest google data center
///
String mapping(String region) {
  var asia = ['JP', 'KR', 'SG', 'TH', 'TW', 'CN', 'HK', 'MO'];
  if (asia.contains(region)) {
    return 'JP';
  }

  var eu = ['BE', 'GB', 'DE', 'FR', 'IT', 'CZ', 'IE', 'ES'];
  if (eu.contains(region)) {
    return 'BE';
  }
  return 'US';
}

/// setServiceRegionByCountryCode force specified region by country code
///
///     setServiceRegionByCountryCode('KR');
///
void setServiceRegionByCountryCode(String countryCode) {
  serviceRegion = mapping(countryCode);
}
