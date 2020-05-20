import 'package:flutter/foundation.dart';
import 'package:libcli/i18n.dart' as i18n;

/// serviceMark
///
String serviceMark = 'piyuo';

/// serviceCountry is country where service locate
///
String serviceCountry;

/// serviceBranch is service branch
///
String serviceBranch = BRANCH_MASTER;

const BRANCH_DEBUG = 'd';
const BRANCH_BETA = 'b';
const BRANCH_MASTER = 'm';

/// serviceUrl return service url base on app.branch
///
///     String url = serviceUrl('sys',3001);
String serviceUrl(String funcName, int debugPort) {
  if (!kReleaseMode && serviceBranch == BRANCH_DEBUG) {
    return 'http://localhost:$debugPort/$funcName';
  }
  return 'https://$_googleHost-$serviceMark$_branch-$_country.cloudfunctions.net/$funcName';
}

String get _branch {
  switch (serviceBranch) {
    case BRANCH_BETA:
      return '-beta';
  }
  return '';
}

String get _i18nCountry {
  if (i18n.userPreferCountryCode != null) {
    return i18n.userPreferCountryCode.toLowerCase();
  }
  return 'us';
}

String get _serviceCountryFromI18n {
  switch (_i18nCountry) {
    case 'tw':
    case 'cn':
    case 'hk':
    case 'mo':
      return 'cn';
  }
  return 'us';
}

/// _country return country where service located
///
String get _country {
  if (serviceCountry != null) {
    return serviceCountry;
  }
  return _serviceCountryFromI18n;
}

/// _googleHost return google region where service located
///
String get _googleHost {
  switch (_country) {
    case 'cn':
      return 'asia-east2';
  }
  return 'us-central1';
}
