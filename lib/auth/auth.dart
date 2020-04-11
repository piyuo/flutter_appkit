import 'package:flutter/foundation.dart';
import 'package:libcli/prefs.dart' as prefs;
import 'package:flutter/material.dart';

/// refreshTokenExipre set refresh token expire duration
///
var accessTokenExipre = Duration(hours: 4);

/// kRefreshToken key in preference
///
const kRefreshToken = 'kRefresh';

/// kAccessToken key in preference
///
const kAccessToken = 'kAccess';

/// kAccessTokenCreateDate key in preference
///
const kAccessTokenCreateDate = 'kAccessDate';

/// kUserName key in preference
///
const kUserName = 'kUser';

/// setRefreshToken save refresh token
///
///     await auth.setRefreshToken('xxx');
///
setRefreshToken(String token) async {
  await prefs.setString(kRefreshToken, token);
}

/// getRefreshToken load refresh token
///
///     await auth.getRefreshToken();
///
Future<String> getRefreshToken() async {
  return await prefs.getString(kRefreshToken);
}

/// setAccessToken save access token
///
///     await auth.setAccessToken('xxx');
///
setAccessToken(String token) async {
  await prefs.setString(kAccessToken, token);
  await prefs.setDateTime(kAccessTokenCreateDate,
      token != null && token.length > 0 ? DateTime.now() : null);
}

/// getAccessToken load access token,return empty if no access token or token is expired
///
///     await auth.getAccessToken();
///
Future<String> getAccessToken() async {
  var createDate = await prefs.getDateTime(kAccessTokenCreateDate);
  if (createDate != null) {
    var token = await prefs.getString(kAccessToken);
    if (createDate.add(accessTokenExipre).isAfter(DateTime.now()) &&
        token.length > 0) {
      return token;
    } else {
      await prefs.setString(kAccessToken, null);
      await prefs.setString(kAccessTokenCreateDate, null);
    }
  }
  return '';
}

/// mockAccessTokenCreateDate mock token create date
///
///     await auth.mockAccessTokenCreateDate(DateTime.now().add(Duration(hours: -5)));
///
@visibleForTesting
mockAccessTokenCreateDate(DateTime date) async {
  await prefs.setDateTime(kAccessTokenCreateDate, date);
}

/// mockInit create test enviroment
///
///     mockInit({});
///
@visibleForTesting
mockInit(Map<String, dynamic> values) {
  prefs.mock(values);
}
