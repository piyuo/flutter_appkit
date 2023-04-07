/// country code world map
/// https://www.nationsonline.org/gallery/World/World-map-all-country-codes.jpg
/// mapping country to nearest google data center
String findGoogleDataCenterByCountryCode(String countryCode) {
  var asia = ['JP', 'KR', 'SG', 'TH', 'TW', 'CN', 'HK', 'MO'];
  if (asia.contains(countryCode)) {
    return 'JP';
  }

  var eu = ['BE', 'GB', 'DE', 'FR', 'IT', 'CZ', 'IE', 'ES'];
  if (eu.contains(countryCode)) {
    return 'BE';
  }
  return 'US';
}
