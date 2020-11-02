import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:libcli/log.dart';

const _here = 'redux';

/// Redux reducer implementation
///
typedef Future<Map<String, dynamic>> Reducer(BuildContext context, Map<String, dynamic> state, dynamic action);

Map from(Map state) {
  reduxNewState = Map.from(state);
  return reduxNewState;
}

/// Redux implements redux pattern
///
class Redux {
  /// _reducer only instance
  ///
  final Reducer _reducer;

  /// _state is current state
  ///
  Map<String, dynamic> _state;

  /// Redux constructor with default reducer and state
  ///
  ///     Redux redux = Redux(reducer, {'value':1});
  ///
  Redux(this._reducer, this._state) {}

  /// state get current state
  ///
  Map<String, dynamic> get state => _state;

  /// dispatch action,return true if state changed. return false if state not change
  ///
  ///     await redux.dispatch(context, Increment(1));
  ///
  void dispatch(BuildContext context, dynamic action) async {
    assert(_reducer != null, '${runtimeType} must set reducer before use');
    if (!kReleaseMode) {
      var newState = await _reducer(context, state, action);
      var payload = toString(action);
      var diff = diffState(newState, _state);
      if (diff != '') {
        debugPrint('$_here~${action.runtimeType}{$payload} $diff');
      } else {
        debugPrint('$_here~${action.runtimeType}{$payload}$RED state not change');
      }
      assert(newState != null, 'state can not be null');
      _state = newState;
      reduxNewState = null;
      return;
    }
    var newState = await _reducer(context, state, action);
    assert(newState != null, 'state can not be null');
    _state = newState;
    reduxNewState = null;
    return;
  }
}

String diffState(Map<String, dynamic> newState, Map<String, dynamic> oldState) {
  String text = '';
  for (final key in newState.keys) {
    var newValue = newState[key];
    var oldValue = oldState[key];
    if (newValue is Map) {
      text += diffState(newValue, oldValue);
    } else {
      if (newValue != oldValue) {
        text += '$RED$key=$newValue$END < $oldValue, ';
      }
    }
  }
  return text;
}
