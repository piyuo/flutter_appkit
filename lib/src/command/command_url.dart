import 'package:libcli/i18n.dart' as i18n;

/// serviceMark
///
String baseDomain = 'piyuo.com';

/// serviceRegion is set if service need tie to specify region, usually when user sign in and they need to to same region where they create the account
///
String serviceRegion;

/// serviceBranch is service branch
///
String serviceBranch = BRANCH_STABLE;

/// BRANCH_MASTER is The current tip-of-tree, absolute latest cutting edge build. Usually functional, though sometimes we accidentally break things
///
const BRANCH_MASTER = 'master';

/// BRANCH_BETA We will branch from master for a new beta release at the beginning of the month, usually the first Monday
///
const BRANCH_BETA = 'beta';

/// BRANCH_STABLE is a a branch that has been stabilized on beta will become our next stable branch and we will create a stable release from that branch. We recommend that you use this channel for all production app releases.
///
const BRANCH_STABLE = 'stable';

/// serviceUrl return service url base on app.branch
///
///     String url = serviceUrl('sys'); // https://auth-us.piyuo.com , https://auth-us-master.piyuo.com
///
String serviceUrl(String funcName) {
  String branch = '-' + serviceBranch;
  if (branch == '-stable') {
    branch = '';
  }
  // add /?q query string to avoid cache by cloud flare
  return 'https://$funcName-${determineRegion()}$branch.$baseDomain/?q';
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
