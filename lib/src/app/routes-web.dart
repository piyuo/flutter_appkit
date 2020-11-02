import 'dart:html' as html;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void webRedirect(String url) {
  debugPrint('redirect: $url');
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

/*
      Uri uri = new Uri(scheme: 'http',
          host: 'localhost',
          port: 8080,
          path: 'myapp',
          queryParameters:json);
          */
