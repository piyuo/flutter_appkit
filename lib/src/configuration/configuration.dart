import 'package:flutter/foundation.dart';

const _here = 'configuration';

/// master: customer production use
/// beta: customer test on
/// alpha: QA test on
/// test: for unit test
/// debug: can debug local service
enum Branches { debug, test, alpha, beta, master }

/// service deploy location,
enum Regions { us, cn, tw }

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
