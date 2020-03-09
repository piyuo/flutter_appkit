import 'dart:async';
import 'package:flutter/material.dart';
import 'package:libcli/provider-redux/async_provider.dart';

class ThemeController extends AsyncProvider {
  static const fonts = ['system', 'kuaile'];

  int fontIndex;

  ThemeController() {}

  ThemeData theme = ThemeData(
    brightness: Brightness.light,
  );

  ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
  );

  @override
  Future<void> load() async {}
}
