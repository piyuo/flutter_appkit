import 'package:flutter/foundation.dart';
import 'package:libcli/src/pattern/async_provider.dart';
import 'package:libcli/src/pattern/redux.dart';
import 'package:flutter/material.dart';

/// ReduxProvider implement AsyncProvicer and Redux
abstract class ReduxProvider<S, A> extends AsyncProvider {
  /// _redux instance
  ///
  Redux<S, A> _redux;

  /// ReduxProvider constructor with default reducer and state
  ///
  ///     MockRedux() : super(reducer, MockState());
  ///
  ReduxProvider(Reducer<S, A> reducer, S state) {
    _redux = Redux<S, A>(reducer, state);
  }

  /// state return current redux state
  ///
  S get state => _redux.state;

  /// state set current redux state
  ///
  set state(S value) => _redux.state = value;

  /// dispatch action and change state
  ///
  ///     redux.dispatch(MockAction.Increment, 1);
  ///
  @mustCallSuper
  Future<S> dispatch(BuildContext ctx, A action, dynamic payload) async {
    await _redux.dispatch(ctx, action, payload);
    await onDispatch(ctx, action, payload);
    notifyListeners();
    return state;
  }

  /// onDIspatch happen after dispatch
  ///
  Future<void> onDispatch(BuildContext ctx, A action, dynamic payload) async {}
}
