import 'package:flutter/foundation.dart';
import 'package:beamer/beamer.dart';
import 'package:universal_html/html.dart' as html;

extension BeamerExt on BeamerDelegate {
  /// goHome go to home page
  void goHome() => goTo('/');

  /// goBack go to previous page
  void goBack() {
    if (kIsWeb) {
      html.window.history.back();
      return;
    }
    beamBack();
  }

  /// goTo to other section of app, it open route in app mode, redirect to url path in web mode
  void goTo(String path) {
    if (kIsWeb) {
      final l = html.window.location;
      l.href = ('${l.protocol}//${l.host}$path');
      return;
    }
    beamToNamed(path);
  }

  /// goSignIn go to sign in page
  void goSignIn() {
    goTo('/signin');
  }
}
