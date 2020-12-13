import 'package:flutter/foundation.dart';
import 'package:libcli/redux.dart';
import 'package:libcli/log.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

/// ModuleProvider provide redux and services
///
class ModuleProvider extends ChangeNotifier {
  static ModuleProvider of(BuildContext context) {
    return Provider.of<ModuleProvider>(context, listen: false);
  }

  /// redux instance
  ///
  final Redux redux;

  final Map services;

  ModuleProvider({
    required this.redux,
    required this.services,
  }) {
    reduxStates.add(redux.state);
  }

  /// dispose remove  redux instances list
  ///
  @override
  void dispose() {
    reduxStates.remove(redux.state);
    super.dispose();
  }

  /// state return current redux state
  ///
  Map get state {
    return redux.state;
  }

  /// dispatch action and change state
  ///
  ///     provider.dispatch(context,Increment(1));
  ///
  Future<Map> dispatch(BuildContext context, dynamic action) async {
    await redux.dispatch(context, action);
    return redux.state;
  }
}

void switchView(
  BuildContext context,
  Widget widget, {
  bool replace = false,
}) {
  final moduleProvider = Provider.of<ModuleProvider>(context, listen: false);
  var navigator = Navigator.of(context);
  final route = MaterialPageRoute(
    builder: (ctx) => Provider.value(
      value: moduleProvider,
      builder: (context, child) => widget,
    ),
  );
  if (replace) {
    navigator.pushReplacement(route);
    return;
  }
  navigator.push(route);
}
