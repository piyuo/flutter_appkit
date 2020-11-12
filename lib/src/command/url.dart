import 'package:libcli/i18n.dart' as i18n;
import 'package:libcli/app.dart' as configuration;

/// serviceMark
///
String baseDomain = 'piyuo.com';

/// serviceRegion is set if service need tie to specify region, usually when user sign in and they need to to same region where they create the account
///
String serviceRegion = 'US';

/// serviceUrl return service url base on app.branch
///
///     String url = serviceUrl('sys'); // https://auth-us.piyuo.com , https://auth-us-master.piyuo.com
///
String serviceUrl(String funcName) {
  String branch = '-' + configuration.branch;
  if (branch == '-stable') {
    branch = '';
  }
  // add /?q query string to avoid cache by cloud flare
  return 'https://$funcName-${serviceRegion.toLowerCase()}$branch.$baseDomain/?q';
}

/// determineRegion return datacenter region base on user prefer country in user locale
///
String determineRegion() {
  return mapping(i18n.userPreferCountryCode);
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
