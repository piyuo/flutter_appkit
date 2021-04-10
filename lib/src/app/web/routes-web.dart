import 'dart:html' as html;
import 'package:libcli/src/log/log.dart' as log;

void webRedirect(String url) {
  log.log('redirect: $url');
  html.window.location.href = url;
}

Uri webUri() {
  return Uri.parse(html.window.location.href);
}

String webUriPath() {
  return webUri().path;
}

String webUriName() {
  Uri uri = webUri();
  return uri.pathSegments[uri.pathSegments.length - 1];
}

Map<String, String> webArguments() {
  Uri uri = Uri.parse(html.window.location.href);
  return uri.queryParameters;
}
