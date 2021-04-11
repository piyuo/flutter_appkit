import 'dart:html' as html;
import 'package:libcli/src/log/log.dart' as log;

void redirect(String url) {
  log.log('redirect: $url');
  html.window.location.href = url;
}

Uri uri() {
  return Uri.parse(html.window.location.href);
}

Map<String, String> query() {
  return uri().queryParameters;
}
