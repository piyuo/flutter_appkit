import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:libcli/log.dart';

const _here = 'redux';

/// Redux reducer implementation
///
typedef Future<Map> Reducer(BuildContext context, Map state, dynamic action);

/// Redux implements redux pattern
///
class Redux {
  /// _reducer only instance
  ///
  final Reducer _reducer;

  /// _state is current state
  ///
  Map _state;

  /// Redux constructor with default reducer and state
  ///
  ///     Redux redux = Redux(reducer, {'value':1});
  ///
  Redux(this._reducer, this._state) {}

  /// state get current state
  ///
  Map get state => _state;

  /// set current state
  ///
  set state(Map value) {
    if (!kReleaseMode) {
      var s = toString(value);
      debugPrint('$_here~${STATE}set state=$s');
    }
    _state = value;
  }

  /// dispatch action and change state
  ///
  ///     redux.dispatch(context, Increment(1));
  ///
  Future<Map> dispatch(BuildContext context, dynamic action) async {
    assert(_reducer != null, '${runtimeType} must set reducer before use');
    if (kReleaseMode) {
      _state = await _reducer(context, state, action);
    } else {
      var jOld = toString(state);
      var newState = await _reducer(context, state, action);
      var jNew = toString(newState);
      debugPrint('$_here~${STATE}${action.runtimeType} $jNew $END<= $jOld');
      _state = newState;
    }
    return state;
  }
}
