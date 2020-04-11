import 'package:libcli/log.dart';
import 'package:flutter/foundation.dart';

const _here = 'vars';

/// master: customer production use
/// beta: customer test on
/// alpha: QA test on
/// test: for unit test
/// debug: can debug local service
enum Branches { debug, test, alpha, beta, master }

/// service deploy location,
enum Regions { us, cn, tw }

/// application identity
///
///     vars.appID='piyuo-web-index'
String _appID = '';
String get appID => _appID;
set appID(String value) {
  debugPrint('$_here~set appID=${NOUN}$value');
  _appID = value;
}

/// user identity
///
///     vars.userID='user-store'
String _userID = '';
String get userID => _userID;
set userID(String value) {
  debugPrint('$_here~set userID=${NOUN}$value');
  _userID = value;
}

/// country
///
///     vars.appID='piyuo-web-index'
String _country = '';
String get country => _country;
set country(String value) {
  debugPrint('$_here~set country=${NOUN}$value');
  _country = value;
}

/// current service branch
///
///     vars.branch=Branch.debug
Branches _branch = Branches.debug;
Branches get branch => _branch;
set branch(Branches value) {
  debugPrint('$_here~set branch=${NOUN}${value.toString()}');
  _branch = value;
}

/// current service region
///
///     vars.region=Region.us
Regions _region = Regions.us;
Regions get region => _region;
set region(Regions value) {
  debugPrint('$_here~set region=${NOUN}${value.toString()}');
  _region = value;
}

/// branch in string
///
///     vars.branchString();
String branchString() => branchToString(branch);

/// region in string
///
///     vars.regionString();
String regionString() => regionToString(region);

/// region in host
///
///     vars.region=Region.us
String host() => regionToHost(region);

/// branchToString return string from branch
///
///     branchToString(Branches.test);
String branchToString(Branches branch) {
  switch (branch) {
    case Branches.test:
      return 't';
    case Branches.alpha:
      return 'a';
    case Branches.beta:
      return 'b';
    case Branches.master:
      return 'm';
    default:
      return 'd';
  }
}

/// stringToBranch return tag for service branch
///
///     stringToBranch('t');
Branches stringToBranch(String value) {
  switch (value) {
    case 't':
      return Branches.test;
    case 'a':
      return Branches.alpha;
    case 'b':
      return Branches.beta;
    case 'm':
      return Branches.master;
    default:
      return Branches.debug;
  }
}

/// regionTohost return google cloud platform host location
///
///     expect(commandUrl.host(), 'us-central1');
String regionToHost(Regions value) {
  switch (value) {
    case Regions.us:
      return 'us-central1';
    case Regions.cn:
      return 'asia-east2';
    case Regions.tw:
      return 'asia-east1';
    default:
  }
  assert(false, 'region not support');
  return '';
}

/// regionToString return string from region
///
///     regionToString(Regions.test);
String regionToString(Regions value) {
  return value.toString().replaceAll('Regions.', '');
}

/// stringToBranch return tag for service branch
///
///     stringToBranch('t');
Regions stringToRegion(String value) {
  assert(value.length > 0);
  for (var v in Regions.values) {
    if (v.toString() == value) {
      return v;
    }
  }
  assert(false, '$value not found in Regions');
  return null;
}
