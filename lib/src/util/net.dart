import 'dart:io';

/// _lookup return true if url can be lookup
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
  return _lookup('starbucks.com');
}

/// isGoogleCloudFunctionAvailable check google cloud function can be connect
///
///     bool result = await tools.isGoogleCloudFunctionAvailable();
Future<bool> isGoogleCloudFunctionAvailable() async {
  return _lookup('www.cloudfunctions.net');
}
