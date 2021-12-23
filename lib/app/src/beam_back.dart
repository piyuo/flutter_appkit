import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:libcli/log/log.dart' as log;
import 'package:universal_html/html.dart' as html;

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

/// beamerBack need put in app entry Scaffold.appBar
Widget? beamBack(BuildContext context) {
  if (kIsWeb && isRootCanPop(context)) {
    return IconButton(
      icon: Icon(html.window.history.length == 0 ? Icons.close : Icons.arrow_back_ios_new),
      onPressed: () => rootPop(context),
    );
  }
  return null;
}
