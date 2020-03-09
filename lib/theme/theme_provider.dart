import 'dart:async';
import 'package:libcli/pattern/redux_provider.dart';
import 'package:libcli/theme/theme_reducer.dart';
import 'package:libcli/theme/theme_state.dart';

class ThemeProvider extends ReduxProvider<ThemeState, ThemeAction> {
  ThemeProvider() : super(reducer, ThemeState());

  @override
  Future<void> load() async {
    state = await readState();
  }
}
