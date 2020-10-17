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

  /// dispatch action,return true if state changed. return false if state not change
  ///
  ///     redux.dispatch(context, Increment(1));
  ///
  dispatch(BuildContext context, dynamic action) async {
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
      _state = newState;
      return;
    }
    _state = await _reducer(context, state, action);
    return;
  }
}

String diffState(Map newState, Map oldState) {
  String text = '';
  for (final key in newState.keys) {
    var newValue = newState[key];
    var oldValue = oldState[key];
    if (newValue is Map) {
      text += diffState(newValue, oldValue);
    } else {
      if (newValue != oldValue) {
        text += '$RED$key=$newValue$END<-$oldValue, ';
      }
    }
  }
  return text;
}
