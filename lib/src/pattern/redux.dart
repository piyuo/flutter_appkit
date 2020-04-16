import 'dart:convert';
import 'package:libcli/log.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

const _here = 'redux';

/// Redux reducer implementation
///
typedef Future<S> Reducer<S, A>(
    BuildContext ctx, S state, A action, dynamic payload);

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
      debugPrint('$_here~${STATE}set state=$s');
    }
    _state = value;
  }

  /// dispatch action and change state
  ///
  ///     redux.dispatch(MockAction.Increment, 1);
  ///
  Future<S> dispatch(BuildContext ctx, A action, dynamic payload) async {
    assert(_reducer != null, '${runtimeType} must set reducer before use');
    if (kReleaseMode) {
      _state = await _reducer(ctx, state, action, payload);
    } else {
      var jOld = toString(state);
      var newState = await _reducer(ctx, state, action, payload);
      var jNew = toString(newState);
      var jAction = toString(action);
      var jPayload = toString(payload);
      debugPrint('$_here~${STATE}$jOld => $jAction $jPayload => $jNew');
      _state = newState;
    }
    return state;
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
