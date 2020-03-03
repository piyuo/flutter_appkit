import 'package:flutter/foundation.dart';
import 'package:libcli/data/data.dart' as data;
import 'package:libcli/constant/preferences.dart' as pref;

///get cookies from
///
///     var cookies = await cookies.get();
Future<String> get() async {
  if (kIsWeb) {
    return '';
  }
  return await data.getString(pref.kCookies);
}

///set cookies to data
///
///     await  cookies.set('mock');
set(String cookies) async {
  if (kIsWeb) {
  } else {
    await data.setString(pref.kCookies, cookies);
  }
}
