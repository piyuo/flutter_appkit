import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/link.dart';
import 'package:beamer/beamer.dart';
import 'package:universal_html/html.dart' as html;

class BeamerLink extends StatelessWidget {
  const BeamerLink({
    required this.child,
    required this.appName,
    this.newTab = false,
    required this.queryParameters,
    Key? key,
  }) : super(key: key);

  final Widget child;

  final String appName;

  final bool newTab;

  final Map<String, dynamic> queryParameters;

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      final l = html.window.location;
      return Link(
        uri: Uri.parse('${l.protocol}//${l.host}$appName').replace(queryParameters: {'back': '1', ...queryParameters}),
        target: newTab ? LinkTarget.blank : LinkTarget.self,
        builder: (_, followLink) {
          return InkWell(
            child: child,
            onTap: followLink,
          );
        },
      );
    }

    return InkWell(
      child: child,
      onTap: () => Beamer.of(context).beamToNamed(appName),
    );
  }
}

/*
/// gotoApp go to another app, redirect to new app page in web, beamToNamed in native
void gotoApp(
  BuildContext context,
  String appName, {
  bool newTab = false,
  required Map<String, String> args,
}) {
  log.debug('[app] redirect to $appName, newTab=$newTab');
  if (kIsWeb) {
    args[by] = newTab ? byNewTab : byRedirect;
    Uri uri = Uri(path: appName, queryParameters: args);
    html.window.open(uri.toString(), newTab ? '_blank' : '_self');
    return;
  }
  Beamer.of(context).beamToNamed(appName);
}
*/