import 'package:flutter/widgets.dart';

/// routeToUrl convert RouteSettings to url string
///
///     String url = routeToStr(settings);
///
String routeToStr(RouteSettings settings) {
  Map<String, dynamic> map = settings.arguments as Map<String, dynamic>;
  Uri uri = Uri(path: settings.name, queryParameters: map);
  return uri.toString();
}

/// RouterBuilder used in web to build a route
///
typedef Widget RouteBuilder(BuildContext context, Map<String, String> arguments);

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
import 'package:flutter/material.dart';
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
