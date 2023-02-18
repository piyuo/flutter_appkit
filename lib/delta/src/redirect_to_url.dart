import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:universal_platform/universal_platform.dart';
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
  if (UniversalPlatform.isIOS || UniversalPlatform.isAndroid) {
    final controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(url));

    await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => Scaffold(
              appBar: AppBar(
                title: caption != null ? Text(caption) : null,
              ),
              body: SafeArea(
                child: WebViewWidget(
                  controller: controller,
                ),
              )),
        ));
    return;
  }

  // mac os use launch browser
  final uri = Uri.parse(url);
  await launchUrl(uri);
}
