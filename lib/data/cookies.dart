import 'package:flutter/foundation.dart';
import 'package:libcli/data/prefs.dart' as prefs;
import 'package:libcli/hook/preferences.dart' as pref;

///get cookies from
///
///     var cookies = await cookies.get();
Future<String> get() async {
  if (kIsWeb) {
    return '';
  }
  return await prefs.getString(pref.kCookies);
}

///set cookies to data
///
///     await  cookies.set('mock');
set(String cookies) async {
  if (kIsWeb) {
  } else {
    await prefs.setString(pref.kCookies, cookies);
  }
}

/// mockInit Initializes the value for testing
///
///     data.mockInit({});
///
@visibleForTesting
void mockInit(Map<String, dynamic> values) {
  prefs.mockInit(values);
}
