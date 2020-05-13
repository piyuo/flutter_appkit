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
