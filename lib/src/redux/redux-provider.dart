import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:libcli/src/redux/async-provider.dart';
import 'package:libcli/src/redux/redux.dart';
import 'package:libcli/log.dart';

/// ReduxProvider implement AsyncProvicer and Redux
///
abstract class ReduxProvider extends AsyncProvider {
  /// redux instance
  ///
  Redux redux;

  /// ReduxProvider constructor with default reducer and state
  ///
  ReduxProvider(this.redux) {
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
  Map get state => redux.state;

  /// dispatch action and change state
  ///
  ///     redux.dispatch(context,Increment(1));
  ///
  @mustCallSuper
  void dispatch(BuildContext ctx, dynamic action) async {
    await redux.dispatch(ctx, action);
    notifyListeners();
  }
}
