import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:libcli/redux.dart';
import 'package:libcli/widgets.dart';

/// Module provide redux and services
///
class Module {
  static Module of(BuildContext context) {
    return Provider.of<Module>(context, listen: false);
  }

  /// redux instance
  ///
  final Redux redux;

  Module({
    required this.redux,
  });

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
  var navigator = Navigator.of(context);
  final moduleProvider = Provider.of<Module>(context, listen: false);
  var newWidget = Provider.value(
    value: moduleProvider,
    builder: (context, child) => widget,
  );

  var route = safeTestMaterialRoute(newWidget);
  if (replace) {
    navigator.pushReplacement(route);
    return;
  }
  navigator.push(route);
}
