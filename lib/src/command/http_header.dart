import 'dart:async';
import 'package:libcli/i18n.dart' as i18n;

Future<Map<String, String>> doRequestHeaders() async {
  Map<String, String> headers = {
    'Content-Type': 'multipart/form-data',
    'Accept-Language': i18n.localeToAcceptLanguage(i18n.locale),
    //'accept': '',
  };
  return headers;
  //var accessToken = await services.getAccessToken();
  //if (accessToken.length > 0) {
  //  log('$accessToken=$accessToken');
  //  headers['Cookie'] = accessToken;
  // }
}

Future<void> doResponseHeaders(Map<String, String> headers) async {
  var c = headers['set-cookie'];
  if (c != null && c.isNotEmpty) {
    //log('refresh accessToken=$c');
    // services.setAccessToken(c);
  }
}
