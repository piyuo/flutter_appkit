import 'package:libcli/theme/theme_state.dart';
import 'package:flutter/material.dart';

enum ThemeAction { None }

Future<ThemeState> reducer(
    BuildContext ctx, ThemeState state, dynamic action, dynamic payload) async {
  switch (action) {
    case ThemeAction.None:
      break;
  }
  return state;
}
