import 'dart:html' as html;
import 'package:libcli/log.dart';

void webRedirect(String url) {
  log('redirect: $url');
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
