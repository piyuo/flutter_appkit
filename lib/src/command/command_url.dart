import 'package:flutter/foundation.dart';
import 'package:libcli/i18n.dart' as i18n;

/// serviceCountry is country where service locate
///
String serviceCountry;

/// serviceBranch is service branch
///
String serviceBranch = BRANCH_MASTER;

const BRANCH_DEBUG = 'debug';
const BRANCH_BETA = 'beta';
const BRANCH_MASTER = 'master';

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
  return 'us';
}

/// _googleHost return google region where service located
///
String get _googleHost {
  switch (_country) {
    case 'CN':
      return 'asia-east2';
    case 'US':
    default:
      return 'us-central1';
  }
}
