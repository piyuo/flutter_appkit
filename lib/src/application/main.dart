import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:libcli/src/log/log.dart' as log;

/// BRANCH_MASTER is The current tip-of-tree, absolute latest cutting edge build. Usually functional, though sometimes we accidentally break things
///
const BRANCH_MASTER = 'master';

/// BRANCH_BETA We will branch from master for a new beta release at the beginning of the month, usually the first Monday
///
const BRANCH_BETA = 'beta';

/// BRANCH_STABLE is a a branch that has been stabilized on beta will become our next stable branch and we will create a stable release from that branch. We recommend that you use this channel for all production app releases.
///
const BRANCH_STABLE = 'stable';

/// BRANCH_DEBUG is a a branch that always direct remove service url to http://localhost:8080
///
const BRANCH_DEBUG = 'debug';

/// branch used in command pattern, determine which branch to use, default is master branch
///
String branch = '';

/// application identity
///
///     configuration.appID='piyuo-web-index'
///
String name = '';

/// supportEmail
///
///     vars.supportEmail='anyone@piyuo.com'
String email = 'support@piyuo.com';

/// user identity
///
///     vars.userID='user-store'
String _userID = '';
String get userID => _userID;
set userID(String value) {
  log.log('${log.COLOR_STATE}set userID=$value');
  _userID = value;
}

/// init config
///
void init({
  required String appBranch,
  required String appName,
  required String appEmail,
}) {
  log.log('branch=$appBranch, name=$appName, email=$appEmail');
  branch = appBranch;
  name = appName;
  email = appEmail;
  //no need for now, cause GlobalLocalizations will load date formatting
//  i18n.initDateFormatting = (String localeID) => initializeDateFormatting(localeID, null);
  Provider.debugCheckInvalidValueType = null;
  WidgetsFlutterBinding.ensureInitialized();
}
