import 'package:flutter/material.dart';

/// ThemeColor use with context.themeColor, it will return color base on theme
class ThemeColor {
  ThemeColor({
    required this.dark,
    required this.light,
  });

  final Color dark;

  final Color light;
}

///typedef Widget ThemeWidgetBuilder(bool isDark);

/// UIBuildContext add color function to BuildContext
///
extension DeltaBuildContext on BuildContext {
  /// isDark return true if is dark theme
  ///
  bool get isDark {
    return MediaQuery.of(this).platformBrightness == Brightness.dark;
  }

  /// themeColor return right color base on light theme or dark theme
  ///
  ///     context.themeColor(ThemeColor(dark:Colors.red,light:COlors.blue));
  ///
  Color themeColor(ThemeColor tc) => isDark ? tc.dark : tc.light;

  /// themeWidget return right widget base on light theme or dark theme
  ///
  ///Widget themeWidget(ThemeWidgetBuilder builder) => builder(isDark);
}
