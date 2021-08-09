import 'package:flutter/material.dart';

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
  Color themeColor({
    required Color dark,
    required Color light,
  }) {
    return isDark ? dark : light;
  }

  /// themeWidget return right widget base on light theme or dark theme
  ///
  Widget themeWidget({
    required Widget dark,
    required Widget light,
  }) {
    return isDark ? dark : light;
  }

  /// themeShadow return right shadow base on light theme or dark theme
  ///
  BoxShadow themeShadow({
    required BoxShadow dark,
    required BoxShadow light,
  }) {
    return isDark ? dark : light;
  }
}
