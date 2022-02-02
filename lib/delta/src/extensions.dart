import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

/// DeltaBuildContext add color function to BuildContext
///
extension DeltaBuildContext on BuildContext {
  /// isDark return true if is dark theme
  ///
  bool get isDark {
    return MediaQuery.of(this).platformBrightness == Brightness.dark;
  }

  /// themeColor return right color base on light theme or dark theme
  ///
  ///     context.themeColor(dark:Colors.red,light:COlors.blue);
  ///
  Color themeColor({
    Color dark = Colors.white,
    Color light = Colors.black,
  }) =>
      isDark ? dark : light;

  /// invertColor return white on dark, black on light
  ///
  ///     context.invertColor();
  ///
  Color get invertColor => isDark ? Colors.white : Colors.black;

  /// invertColor return white on light, black on dark
  ///
  ///     context.sameColor();
  ///
  Color get sameColor => isDark ? Colors.black : Colors.white;
}

/// isMobileDevice return true if is on ios or android
bool isMobileDevice(BuildContext context) {
  if (kIsWeb) {
    return false;
  }
  var platform = Theme.of(context).platform;
  return platform == TargetPlatform.iOS || platform == TargetPlatform.android;
}
