import 'package:libcli/theme/theme_state.dart';

enum ThemeAction { None }

Future<ThemeState> reducer(
    ThemeState state, dynamic action, dynamic payload) async {
  switch (action) {
    case ThemeAction.None:
      break;
  }
  return state;
}
