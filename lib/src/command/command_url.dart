import 'package:flutter/foundation.dart';
import 'package:libcli/i18n.dart' as i18n;

/// serviceCountry is country code where service locate
///
String serviceCountry;

/// serviceBranch is service branch
///
String serviceBranch = BRANCH_MASTER;

const BRANCH_DEBUG = 'd';
const BRANCH_TEST = 't';
const BRANCH_ALPHA = 'a';
const BRANCH_BETA = 'b';
const BRANCH_MASTER = 'm';

/// serviceUrl return service url base on app.branch
///
///     String url = serviceUrl('sys',3001);
String serviceUrl(String funcName, int debugPort) {
  if (!kReleaseMode && serviceBranch == BRANCH_DEBUG) {
    return 'http://localhost:$debugPort/$funcName';
  }
  return 'https://$_googleHost-$_country-$serviceBranch.cloudfunctions.net/$funcName';
}

/// _country return country where service located
///
String get _country {
  if (serviceCountry != null) {
    return serviceCountry;
  }
  if (i18n.userPreferCountryCode != null) {
    return i18n.userPreferCountryCode;
  }
  return 'US';
}

/// _googleHost return google region where service located
///
String get _googleHost {
  switch (_country) {
    case 'TW':
      return 'asia-east1';
    case 'CN':
      return 'asia-east2';
    case 'US':
    default:
      return 'us-central1';
  }
}
