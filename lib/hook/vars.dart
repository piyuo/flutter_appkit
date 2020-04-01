import 'package:libcli/log/log.dart';
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
///     variables.appID='piyuo-web-index'
String _appID = '';
String get AppID => _appID;
set AppID(String value) {
  debugPrint('$_here|set AppID=${NOUN}$value');
  _appID = value;
}

/// user identity
///
///     variables.userID='user-store'
String _userID = '';
String get UserID => _userID;
set UserID(String value) {
  debugPrint('$_here|set UserID=${NOUN}$value');
  _userID = value;
}

/// current service branch
///
///     variables.branch=Branch.debug
Branches _branch = Branches.debug;
Branches get Branch => _branch;
set Branch(Branches value) {
  debugPrint('$_here|set Branch=${NOUN}${value.toString()}');
  _branch = value;
}

/// current service region
///
///     variables.region=Region.us
Regions _region = Regions.us;
Regions get Region => _region;
set Region(Regions value) {
  debugPrint('$_here|set Region=${NOUN}${value.toString()}');
  _region = value;
}

/// branch in string
///
///     variables.region=Region.us
String branch() => branchToString(Branch);

/// region in string
///
///     variables.region=Region.us
String region() => regionToString(Region);

/// region in host
///
///     variables.region=Region.us
String host() => regionToHost(Region);

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
