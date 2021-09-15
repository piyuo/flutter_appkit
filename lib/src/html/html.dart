// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:libcli/log.dart' as log;
import 'package:libcli/env.dart' as env;

/// uri return browser window.location.href
///
Uri uri() {
  return Uri.parse(html.window.location.href);
}

/// redirect set window.location.href
///
void redirect(String url) {
  log.log('[html] redirect: $url');
  html.window.location.href = url;
}

/// query return queryParameters
///
Map<String, String> query() {
  return uri().queryParameters;
}

/// goBack loads the previous URL in the history list
///
void goBack() {
  var window = html.window;
  window.history.back();
}

/// routeToUrl convert RouteSettings to url string
///
///     String url = routeToURL(settings);
///
String routeToURL(RouteSettings settings) {
  Map<String, dynamic>? map;
  if (settings.arguments != null) {
    map = settings.arguments as Map<String, dynamic>;
  }
  Uri uri = Uri(path: settings.name, queryParameters: map);
  return uri.toString();
}

/// routing first create page using builder, then redirect page if navigation happen
///
///     String url = routing(settings,builder);
///
Route<dynamic>? routing(RouteSettings settings, env.RouteBuilder builder) {
  log.log('[html] got routing=${settings.name}');

  if (settings.name == 'gotoRoot') {
    // goto web site Root
    return _redirectRoute('/');
  }
  if (settings.name == '/' || settings.name == '/index.html') {
    // show page
    return MaterialPageRoute(builder: (context) => builder(context, query()));
  }
  //redirect to other page
  String url = routeToURL(settings);
  return _redirectRoute(url);
}

/// _redirectRoute redirect to other page
Route<dynamic>? _redirectRoute(String url) {
  redirect(url);
  return MaterialPageRoute(
    builder: (_) => Scaffold(
      body: Container(),
    ),
  );
}


/*
RouteSettings _current;

router() {
  // inject
  routes.path = path;
  routes.key = key;
  routes.query = query;
  return route;
}

String path() {
  return _current.name;
}

String key() {
  var list = _current.name.split('/');
  return list[list.length - 1];
}

Map<String, String> query() {
  return _current.arguments;
}

typedef String Path();


*/
