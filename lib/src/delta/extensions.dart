import 'package:flutter/material.dart';

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
  ///     context.themeColor(dark:Colors.red,light:COlors.blue);
  ///
  Color themeColor({
    Color dark = Colors.white,
    Color light: Colors.black,
  }) =>
      isDark ? dark : light;

  /// themeWidget return right widget base on light theme or dark theme
  ///
  ///Widget themeWidget(ThemeWidgetBuilder builder) => builder(isDark);
}
