import 'package:libcli/i18n.dart' as i18n;
import 'package:libcli/env/env.dart' as env;
import 'package:flutter/foundation.dart';

/// serviceMark
///
String baseDomain = 'piyuo.com';

/// serviceRegion is set if service need tie to specify region, usually when user sign in and they need to to same region where they create the account
///
String serviceRegion = '';

/// serviceUrl return service url base on app.branch
///
///     String url = serviceUrl('sys'); // https://auth-us.piyuo.com , https://auth-us-master.piyuo.com
///
String serviceUrl(String funcName) {
  if (!kReleaseMode) {
    if (env.branch == env.branchDebug) {
      return 'http://localhost:8080/?q';
    }
  }

  if (env.branch == env.branchStable) {
    String region = serviceRegion;
    if (region.isEmpty) {
      region = determineRegion();
    }
    return 'https://$funcName-${region.toLowerCase()}.$baseDomain/?q';
  }
  // always use US when not in stable branch
  return 'https://$funcName-us-${env.branch}.$baseDomain/?q';
}

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
