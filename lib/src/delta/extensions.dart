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
