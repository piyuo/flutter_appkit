import 'dart:async';
import 'package:flutter/material.dart';

const fonts = ['system', 'kuaile'];

class ThemeState {
  int fontIndex = 0;

  ThemeData theme = ThemeData(
    brightness: Brightness.light,
  );

  ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
  );

  Map toJson() {
    return {'fontIndex': fontIndex};
  }
}

Future<ThemeState> readState() async {
  return ThemeState()..fontIndex = 0;
}
