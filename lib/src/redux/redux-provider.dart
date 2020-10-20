import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:libcli/src/redux/async-provider.dart';
import 'package:libcli/src/redux/redux.dart';
import 'package:libcli/log.dart';

/// ReduxProvider implement AsyncProvicer and Redux
///
abstract class ReduxProvider extends AsyncProvider {
  /// _redux instance
  ///
  Redux _redux;

  /// ReduxProvider constructor with default reducer and state
  ///
  ReduxProvider(Reducer reducer, Map state) {
    _redux = Redux(reducer, state);
    reduxStates.add(_redux.state);
  }

  /// dispose remove  redux instances list
  ///
  @override
  void dispose() {
    reduxStates.remove(_redux.state);
    super.dispose();
  }

  /// state return current redux state
  ///
  Map get state => _redux.state;

  /// dispatch action and change state
  ///
  ///     redux.dispatch(context,Increment(1));
  ///
  @mustCallSuper
  Future<Map> dispatch(BuildContext ctx, dynamic action) async {
    await _redux.dispatch(ctx, action);
    notifyListeners();
    return state;
  }
}
