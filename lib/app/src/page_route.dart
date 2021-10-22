import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:libcli/log/log.dart' as log;
import 'package:universal_html/html.dart' as html;

const openBy = 'by';
const redirect = 'rdt'; // redirect from current window
const newTab = 'tab'; // open by new window

Map<String, String> _args = {};

/// listenRoute route change and return correct route name
String listenRoute(RouteSettings settings) {
  if (kIsWeb && settings.name == '/' && html.window.location.href.contains('?')) {
    return '';
  }

  String path = settings.name ?? '/';
  if (kIsWeb && path.contains('?')) {
    // from url
    final uri = Uri.parse(path);
    _args = uri.queryParameters;
    log.debug('[page_route] listened $path, go ${uri.path}');
    return uri.path;
  }

  if (settings.arguments == null) {
    _args = {};
  } else {
    assert(settings.arguments is Map<String, String>, 'page route arguments must be Map<String, String>');
    _args = settings.arguments as Map<String, String>;
  }
  log.debug('[page_route] listened $path');
  return path;
}

/// args return listened route settings args
Map<String, String> get args => _args;

/// canPop return true if open by is not null
bool get canPop => _args[openBy] != null;

/// openByRedirect is current route open by redirect
bool get openByRedirect => _args[openBy] == redirect;

/// openByRedirect is current route open by new tab
bool get openByNewTab => _args[openBy] == newTab;

/// push a new route in native app, redirect or open new tab in browser
void push(
  BuildContext context,
  String routeName, {
  bool openNewTab = false,
  required Map<String, String> args,
}) {
  if (kIsWeb) {
    args[openBy] = openNewTab ? newTab : redirect;
    Uri uri = Uri(path: routeName, queryParameters: args);
    log.debug('[page_route] ${args[openBy]} ${uri.toString()}');
    html.window.open(uri.toString(), openNewTab ? '_blank' : '_self');
    return;
  }
  log.debug('[page_route] push $routeName');
  Navigator.pushNamed(context, routeName, arguments: args);
}

/// pop route in native app, go back history or close tab in browser
void pop(
  BuildContext context, {
  String? result,
}) async {
  if (kIsWeb) {
    if (openByRedirect) {
      log.debug('[page_route] history back');
      html.window.history.back();
      return;
    }
    if (openByNewTab) {
      log.debug('[page_route] close tab');
      html.window.close();
      return;
    }
  }
  if (Navigator.canPop(context)) {
    log.debug('[page_route] pop route');
    Navigator.pop(context);
  }
}
