import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:beamer/beamer.dart';
import 'package:universal_html/html.dart' as html;

/// redirect to other section of app, it open route in native mode, redirect to web url in web mode
void redirect(
  BuildContext context,
  String path,
) {
  if (kIsWeb) {
    final l = html.window.location;
    l.href = ('${l.protocol}//${l.host}$path');
    return;
  }
  Beamer.of(context).beamToNamed(path);
}

/// goHome go to home page
void goHome(BuildContext context) => redirect(context, '/');

/// goBack go to previous page
void goBack(BuildContext context) {
  if (kIsWeb) {
    html.window.history.back();
    return;
  }
  Beamer.of(context).beamBack();
}

/// buildBackButton put back button in app entry Scaffold.appBar
Widget? buildBackButton() {
  if (kIsWeb && html.window.location.pathname != '/' && html.window.history.length > 1) {
    return IconButton(
      icon: const Icon(Icons.arrow_back_ios_new),
      onPressed: () => html.window.history.back(),
    );
  }
  return null;
}

/// buildTitle will return text widget for app bar title and set html title if in web mode
Widget? buildTitle(String? title) {
  if (title == null) {
    return null;
  }
  if (kIsWeb) {
    html.document.title = title;
  }
  return Text(title);
}
/*
/// isRootCanPop return true if root page still can go back to previous page
bool isRootCanPop(BuildContext context) {
  return html.window.location.pathname == '/' && html.window.location.href.contains('back=1');
}

/// rootPop go back to previous page
void rootPop(BuildContext context) {
  if (html.window.history.length > 0) {
    log.debug('[app] back history');
    html.window.history.back();
  }
  log.debug('[app] close tab');
  html.window.close();
}

 */