import 'dart:io';
import 'dart:convert';
import 'dart:math';

/// create uuid
///
///     String id = uuid();
String uuid() {
  final Random _random = Random.secure();
  var values = List<int>.generate(24, (i) => _random.nextInt(256));
  String text = base64Url.encode(values);
  return text.substring(0, text.length - 2);
}

/// lookup a url, return true if url can be lookup
///
///     bool result = tools._lookup('baidu.com');
Future<bool> _lookup(String url) async {
  try {
    final result = await InternetAddress.lookup(url);
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      return true;
    }
  } catch (e) {
    print(e);
  }
  return false;
}

/// isInternetConnected return true if internet is connected
///
///     bool result = await tools.isInternetConnected();
Future<bool> isInternetConnected() async {
  return _lookup('baidu.com');
}

/// isGoogleCloudFunctionAvailable check google clound function can be connect
///
///     bool result = await tools.isGoogleCloundFunctionAvailable();
Future<bool> isGoogleCloudFunctionAvailable() async {
  return _lookup('www.cloudfunctions.net');
}
