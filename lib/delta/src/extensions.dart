import 'package:flutter/material.dart';

/// DeltaBuildContext add color function to BuildContext
extension DeltaBuildContext on BuildContext {
  /// isDark return true if is dark theme
  /// ```dart
  /// context.isDark;
  /// ```
  bool get isDark => MediaQuery.of(this).platformBrightness == Brightness.dark;

  /// themeColor return right color base on light theme or dark theme
  /// ```dart
  /// context.themeColor(light:Colors.blue,dark:Colors.red);
  /// ```
  Color themeColor({
    Color dark = Colors.white,
    Color light = Colors.black,
  }) =>
      isDark ? dark : light;

  /// invertColor return white on dark, black on light
  /// ```dart
  /// context.invertedColor;
  /// ```
  Color get invertedColor => isDark ? Colors.white : Colors.black;

  /// invertColor return white on light, black on dark
  /// ```dart
  /// context.sameColor;
  /// ```
  Color get sameColor => isDark ? Colors.black : Colors.white;

  /// isTouchSupported is true if is on ios or android
  /// ```dart
  /// context.isTouchSupported;
  /// ```
  bool get isTouchSupported {
    var platform = Theme.of(this).platform;
    return platform == TargetPlatform.iOS || platform == TargetPlatform.android;
  }
}
