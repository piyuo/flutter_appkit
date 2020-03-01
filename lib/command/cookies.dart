import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart'; // rememeber to import shared_preferences: ^0.5.4+8

String _cookiesName = 'command_cookies';
String _tempCookies = '';

///loadCookies load cookies store in local
///
///     var cookies = await loadCookies();
Future<String> loadCookies() async {
  if (kReleaseMode) {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_cookiesName);
  }
  return _tempCookies;
}

///saveCookies load cookies store in local
///
///     await  saveCookies('mock');
saveCookies(String cookies) async {
  if (kReleaseMode) {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(_cookiesName, cookies);
  }
  _tempCookies = cookies;
}

///clearCookies set cookies empty
///
///     await  clearCookies();
clearCookies() async {
  if (kReleaseMode) {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(_cookiesName, '');
  }
  _tempCookies = '';
}
