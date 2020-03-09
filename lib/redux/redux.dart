import 'dart:convert';
import 'package:libcli/log/log.dart';
import 'package:flutter/foundation.dart';

const _here = 'redux';

/// Redux reducer implementation
///
typedef S Reducer<S, A>(S state, A action, dynamic payload);

/// Redux implements redux pattern
///
class Redux<S, A> {
  /// _reducer only instance
  ///
  final Reducer<S, A> _reducer;

  /// _state is current state
  ///
  S _state;

  /// Redux constructor with default reducer and state
  ///
  ///     Redux redux = Redux<MockState, MockAction>(reducer, MockState());
  ///
  Redux(this._reducer, this._state) {}

  /// state get current state
  ///
  S get state => _state;

  /// set current state
  ///
  set state(S value) {
    if (!kReleaseMode) {
      var s = toString(value);
      '$_here|set state=$s'.print;
    }
    _state = value;
  }

  /// dispatch action and change state
  ///
  ///     redux.dispatch(MockAction.Increment, 1);
  ///
  Future<void> dispatch(A action, dynamic payload) async {
    assert(_reducer != null, '${runtimeType} must set reducer before use');
    if (kReleaseMode) {
      _state = _reducer(state, action, payload);
    } else {
      var jOld = toString(state);
      var newState = _reducer(state, action, payload);
      var jNew = toString(newState);
      var jAction = toString(action);
      var jPayload = toString(payload);
      '$_here|$jOld => $VERB$jAction $NOUN$jPayload $END=> $NOUN2$jNew'.print;
      _state = newState;
    }
  }
}

/// toString encode object to string
///
///     toString(state);
///
String toString(dynamic d) {
  try {
    return json.encode(d);
  } catch (_) {}
  return '${d.toString()}';
}
