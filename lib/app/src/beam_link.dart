import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/link.dart';
import 'package:beamer/beamer.dart';
import 'package:universal_html/html.dart' as html;

class BeamLink extends StatelessWidget {
  const BeamLink({
    required this.child,
    required this.path,
    this.newTab = false,
    this.beamBack = false,
    Key? key,
  }) : super(key: key);

  final Widget child;

  final String path;

  final bool newTab;

  final bool beamBack;

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      final l = html.window.location;
      var uri = Uri.parse('${l.protocol}//${l.host}$path');
      if (beamBack) {
        // beamBack is true let target app show back button
        uri = uri.replace(queryParameters: {'back': '1'});
      }
      return Link(
        uri: uri,
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
      onTap: () => Beamer.of(context).beamToNamed(path),
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