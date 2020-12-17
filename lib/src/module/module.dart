import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:libcli/redux.dart';
import 'package:libcli/log.dart';
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

  final Map services;

  Module({
    required this.redux,
    required this.services,
  }) {
    reduxStates.add(redux.state);
  }

  /// dispose remove redux instances list, must call this method at provider dispose
  ///
  void dispose() {
    reduxStates.remove(redux.state);
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
  final moduleProvider = Provider.of<Module>(context, listen: false);
  final route = MaterialPageRoute(
    builder: (ctx) => Provider.value(
      value: moduleProvider,
      builder: (context, child) => widget,
    ),
  );

/*
  final route = NoAnimRouteBuilder(Provider.value(
    value: moduleProvider,
    builder: (context, child) => widget,
  ));
*/
  var navigator = Navigator.of(context);
  if (replace) {
    navigator.pushReplacement(route);
    return;
  }
  navigator.push(route);
}
