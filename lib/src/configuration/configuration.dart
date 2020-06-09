import 'package:flutter/foundation.dart';

const _here = 'configuration';

/// supportEmail
///
///     vars.supportEmail='anyone@piyuo.com'
String supportEmail = 'support@piyuo.com';

/// application identity
///
///     vars.appID='piyuo-web-index'
String _appID = '';
String get appID => _appID;
set appID(String value) {
  debugPrint('$_here~set appID=$value');
  _appID = value;
}

/// user identity
///
///     vars.userID='user-store'
String _userID = '';
String get userID => _userID;
set userID(String value) {
  debugPrint('$_here~set userID=$value');
  _userID = value;
}

/// branch used in command pattern, determine which branch to use, default is master branch
///
String _branch = BRANCH_MASTER;

/// setBranch set current branch
void setBranch(value) {
  _branch = value;
  debugPrint('$_here~set branch=$value');
}

/// branch return current branch read onlyt
String get branch => _branch;

/// BRANCH_MASTER is The current tip-of-tree, absolute latest cutting edge build. Usually functional, though sometimes we accidentally break things
///
const BRANCH_MASTER = 'master';

/// BRANCH_BETA We will branch from master for a new beta release at the beginning of the month, usually the first Monday
///
const BRANCH_BETA = 'beta';

/// BRANCH_STABLE is a a branch that has been stabilized on beta will become our next stable branch and we will create a stable release from that branch. We recommend that you use this channel for all production app releases.
///
const BRANCH_STABLE = 'stable';
