import 'package:flutter/material.dart';

typedef Color ThemeColorBuilder(bool isDark);

typedef Widget ThemeWidgetBuilder(bool isDark);

/// UIBuildContext add color function to BuildContext
///
extension UIBuildContext on BuildContext {
  /// isDark return true if is dark theme
  ///
  bool get isDark {
    return MediaQuery.of(this).platformBrightness == Brightness.dark;
  }

  /// themeColor return right color base on light theme or dark theme
  ///
  Color themeColor(ThemeColorBuilder builder) => builder(isDark);

  /// themeWidget return right widget base on light theme or dark theme
  ///
  Widget themeWidget(ThemeWidgetBuilder builder) => builder(isDark);
}
