import 'package:libcli/log/log.dart' as log;

/// kBranchMaster is The current tip-of-tree, absolute latest cutting edge build. Usually functional, though sometimes we accidentally break things
const kBranchMaster = 'master';

/// kBranchBeta We will branch from master for a new beta release at the beginning of the month, usually the first Monday
const kBranchBeta = 'beta';

/// kBranchStable is a a branch that has been stabilized on beta will become our next stable branch and we will create a stable release from that branch. We recommend that you use this channel for all production app releases.
const kBranchStable = '';

/// kBranchDebug is a a branch that always direct remove service url to http://localhost:8080
const kBranchDebug = 'debug';

/// kBranchKey use to save branch in preferences
const kBranchKey = '_branch';

/// _branch keep current branch
String _branch = kBranchStable;

/// backendBranch return backend branch
String get backendBranch => _branch;

/// backendBranch set backend branch
set backendBranch(String value) {
  _branch = value;
  log.log('[base] set branch: $_branch');
}

/// backendBranchUrl return backend branch url
String get backendBranchUrl {
  if (_branch.isEmpty) {
    return _branch;
  }
  return '-$_branch';
}
