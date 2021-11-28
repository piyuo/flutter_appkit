import 'dart:io' show Platform;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:universal_html/html.dart' as html;
import 'package:url_launcher/url_launcher.dart';

/// redirectToURL open web view in iOS/Android, redirect in web mode
Future<void> redirectToURL(
  BuildContext context,
  String url, {
  String? caption,
}) async {
  if (kIsWeb) {
    html.window.open(url, '_self');
    return;
  }

  // use webview in ios and android
  if (Platform.isIOS || Platform.isAndroid) {
    await Navigator.push<Uint8List?>(
        context,
        MaterialPageRoute(
          builder: (_) => Scaffold(
              appBar: AppBar(
                title: caption != null ? Text(caption) : null,
              ),
              body: SafeArea(
                  child: WebView(
                initialUrl: url,
              ))),
        ));
  }

  // mac os use launch browser
  await launch(
    url,
    forceSafariVC: false,
  );
}
