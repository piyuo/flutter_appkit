import 'package:flutter/foundation.dart';
import 'package:libcli/pattern/async_provider.dart';
import 'package:libcli/pattern/redux.dart';

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
  Future<void> dispatch(A action, dynamic payload) async {
    await _redux.dispatch(action, payload);
    await onDispatch(action, payload);
    notifyListeners();
  }

  /// onDIspatch happen after dispatch
  ///
  Future<void> onDispatch(A action, dynamic payload) async {}
}
