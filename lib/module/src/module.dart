import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:libcli/delta/delta.dart' as delta;
import 'redux.dart';

/// return [Module] from context
Module of(BuildContext context) {
  return Provider.of<Module>(context, listen: false);
}

/// Module provide redux and services
///
class Module {
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

/// switch to new view
void switchView(
  BuildContext context,
  Widget widget, {
  bool replacement = false,
}) {
  final moduleProvider = Provider.of<Module>(context, listen: false);
  var newWidget = Provider.value(
    value: moduleProvider,
    builder: (context, child) => widget,
  );

  delta.pushRoute(context, newWidget, replacement: replacement);
}
