import 'package:flutter/material.dart';

/// UIBuildContext add color function to BuildContext
///
extension UIBuildContext on BuildContext {
  /// themeColor return right color base on light theme or dark theme
  ///
  Color themeColor({
    required Color light,
    required Color dark,
  }) {
    return MediaQuery.of(this).platformBrightness == Brightness.dark ? dark : light;
  }
}
