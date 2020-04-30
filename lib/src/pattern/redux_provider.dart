import 'package:flutter/foundation.dart';
import 'package:libcli/src/pattern/async_provider.dart';
import 'package:libcli/src/pattern/redux.dart';
import 'package:flutter/material.dart';

/// ReduxProvider implement AsyncProvicer and Redux
abstract class ReduxProvider extends AsyncProvider {
  /// _redux instance
  ///
  Redux _redux;

  /// ReduxProvider constructor with default reducer and state
  ///
  ReduxProvider(Reducer reducer, Map state) {
    _redux = Redux(reducer, state);
  }

  /// state return current redux state
  ///
  Map get state => _redux.state;

  /// state set current redux state
  ///
  set state(Map value) => _redux.state = value;

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
