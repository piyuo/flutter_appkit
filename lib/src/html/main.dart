import 'package:flutter/material.dart';
import 'dart:html' as html;
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
  log.debug('redirect: $url');
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
  html.window..history.back();
}

/// routeToUrl convert RouteSettings to url string
///
///     String url = routeToURL(settings);
///
String routeToURL(RouteSettings settings) {
  Map<String, dynamic>? map = null;
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
  if (settings.name != '/') {
    String url = routeToURL(settings);
    redirect(url);
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        body: Container(),
      ),
    );
  }
  return MaterialPageRoute(builder: (context) => builder(context, query()));
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

/// path return current path
///
///   /js/tryit?filename=tryjs
///   current.path(); //
Path path;

// /js/tryit.asp

//tryit
typedef String Name();
Name name;

//filename=tryjs_loc_href
typedef Map<String, String> Arguments();
Arguments arguments;

import 'package:piyuo/src/path.dart' as routes;
import 'package:piyuo/src/dialog/playground/dialog-playground.dart';
import 'package:piyuo/src/services/playground/services-playground.dart';
import 'package:piyuo/src/routes/current.dart' as current;
//import 'package:piyuo/src/view/logo_view.dart';
import 'package:piyuo/src/pages/signup/signup.dart';
import 'package:piyuo/src/pages/signup/play/signup-play.dart';

//import 'package:piyuo/src/admin/products/list_page.dart';
///import 'package:piyuo/src/admin/products/item_page.dart';

RouteSettings _setting;

void setCurrent(RouteSettings setting) {
  _setting = setting;
  current.name = () => _setting.name;

  routes.key = key;
  routes.query = query;
  return route;
}

String _name() {
  return _current.name;
}

String key() {
  var list = _current.name.split('/');
  return list[list.length - 1];
}

Map<String, String> query() {
  return _current.arguments;
}

*/
