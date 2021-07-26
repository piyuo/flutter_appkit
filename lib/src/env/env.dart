import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:libcli/log.dart' as log;
import 'package:url_strategy/url_strategy.dart';

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

/// _branch used in command pattern, determine which branch to use, default is master branch
///
String _branch = BRANCH_MASTER;

/// branch used in command pattern, determine which branch to use, default is master branch
///
String get branch => _branch;

@visibleForTesting
set branch(String value) => _branch = value;

/// _appName is application name, used in log
///
String _appName = '';

/// appName is application name, used in log
///
String get appName => _appName;

@visibleForTesting
set appName(String value) => _appName = value;

/// _serviceEmail is service email, alert dialog will guide user to send email
///
String _serviceEmail = '';

/// serviceEmail is service email, alert dialog will guide user to send email
///
String get serviceEmail => _serviceEmail;

/// RouterBuilder used in web to build a route
///
typedef Widget RouteBuilder(BuildContext context, Map<String, String> arguments);

/// user identity
///
///     vars.userID='user-store'
String _userID = '';
String get userID => _userID;
set userID(String value) {
  log.log('[env] set userID=$value');
  _userID = value;
}

/// init config
///
void init({
  required String appName,
  String branch = BRANCH_MASTER,
  String serviceEmail = 'support@piyuo.com',
}) {
  if (kReleaseMode) {
    setPathUrlStrategy(); //remove the leading hash (#) from the URL
  }
  log.log('[env] appName=$appName, branch=$branch, serviceEmail=$serviceEmail');
  _branch = branch;
  _appName = appName;
  _serviceEmail = serviceEmail;
  //no need for now, cause GlobalLocalizations will load date formatting
//  i18n.initDateFormatting = (String localeID) => initializeDateFormatting(localeID, null);
  Provider.debugCheckInvalidValueType = null;
  WidgetsFlutterBinding.ensureInitialized();
}
