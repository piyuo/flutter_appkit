import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:libcli/log.dart' as log;

/// Redux reducer implementation
///
typedef Future<Map> Reducer(BuildContext context, Map state, dynamic action);

Map from(Map state) {
  return Map.from(state);
}

/// readReduxStates print all redux states to string
///
String stateToStr(Map state) {
  return log.toString(state);
}

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
  Redux(this._reducer, this._state) {
    logInitState();
  }

  /// logInitState
  ///
  @protected
  void logInitState() {
    log.log('[redux] init ${stateToStr(_state)}');
  }

  /// state get current state
  ///
  Map get state => _state;

  /// dispatch action,return true if state changed. return false if state not change
  ///
  ///     await redux.dispatch(context, Increment(1));
  ///
  Future<void> dispatch(BuildContext context, dynamic action) async {
    var newState = await _reducer(context, state, action);
    var payload = log.toString(action);
    var diff = diffState(newState, _state);
    if (diff.isEmpty) {
      diff = 'state not change';
    } else {
      //remove extra ,
      diff = diff.substring(0, diff.length - 1);
    }
    log.log('[redux] dispatch ${action.runtimeType} {$payload} $diff');
    _state = newState;
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
        text += '$key=$newValue($oldValue), ';
      }
    }
  }
  return text.replaceAll('\n', '');
}
