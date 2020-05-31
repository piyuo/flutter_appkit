import 'package:libcli/i18n.dart' as i18n;

/// serviceMark
///
String baseDomain = 'piyuo.com';

/// serviceRegion is country where service locate
///
String serviceRegion;

/// serviceBranch is service branch
///
String serviceBranch = BRANCH_MASTER;

/// BRANCH_BETA is for development
///
const BRANCH_BETA = 'b';

/// BRANCH_MASTER is for production
///
const BRANCH_MASTER = 'm';

/// serviceUrl return service url base on app.branch
///
///     String url = serviceUrl('sys');
///
String serviceUrl(String funcName) {
  String subdomain = 'api';
  if (serviceBranch == BRANCH_BETA) {
    subdomain = 'beta';
  }
  // add /?q query string to avoid cache by cloud flare
  return 'https://$funcName-${determineRegion()}.$subdomain.$baseDomain/?q';
}

/// _country return country where service located
///
String determineRegion() {
  if (serviceRegion != null) {
    return serviceRegion;
  }
  var region = 'us';
  //first check i18n prefered
  if (i18n.userPreferCountryCode != null) {
    region = i18n.userPreferCountryCode.toLowerCase();
  }
  return mapping(region);
}

/// country code world map
/// https://www.nationsonline.org/gallery/World/World-map-all-country-codes.jpg

/// mapping country to nearest google data center
///
String mapping(String region) {
  var asia = ['jp', 'kr', 'sg', 'th', 'tw', 'cn', 'hk', 'mo'];
  if (asia.contains(region)) {
    return 'jp';
  }

  var eu = ['be', 'gb', 'de', 'fr', 'it', 'cz', 'ie', 'es'];
  if (eu.contains(region)) {
    return 'be';
  }

  return 'us';
}
