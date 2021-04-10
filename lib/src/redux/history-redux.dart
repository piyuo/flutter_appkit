import 'package:flutter/foundation.dart';
import 'package:libcli/src/log/log.dart' as log;
import 'package:libcli/redux.dart';
import 'package:flutter/widgets.dart';

/// HistoryRedux implements redux pattern and have ability to undo and redo
///
class HistoryRedux {
  /// history length
  ///
  int historyLength;

  /// _reducer only instance
  ///
  final Reducer _reducer;

  /// _index point to current state in states history
  /// ,
  int _index = 0;

  ///_states is entirely state's history and length is limit to historyLength
  ///
  List<Map> _states = [];

  /// HistoryRedux constructor with default history length, reducer and state
  ///
  ///     HistoryRedux redux =HistoryRedux(reducer, {},historyLength:10);
  ///
  HistoryRedux(this._reducer, Map state, {this.historyLength = 16}) {
    _states.add(state);
  }

  /// _state is current state
  ///
  Map get state => _states[_index];

  /// _setState add states to states history
  ///
  _setState(Map value) {
    if (_index != _states.length - 1) {
      _states.removeRange(_index, _states.length);
    }
    _states.add(value);
    if (_states.length > historyLength) {
      _states.removeAt(0);
      _index--;
    }
    _index++;
  }

  /// hasUndo return true if can undo
  ///
  ///     expect(redux.hasUndo, true);
  ///
  bool get hasUndo => _index > 0;

  /// hasRedo return true if can redo
  ///
  ///     expect(redux.hasRedo, true);
  ///
  bool get hasRedo => _index < _states.length - 1;

  /// undo return to previous state
  ///
  ///     redux.undo();
  ///
  undo() {
    if (hasUndo) {
      if (kReleaseMode) {
        _index--;
      } else {
        var jOld = log.toLogString(state);
        _index--;
        var jNew = log.toLogString(state);
        log.log('${log.COLOR_STATE}undo $jNew ${log.COLOR_END}<= $jOld');
      }
    } else {
      log.log('nothing to undo');
    }
  }

  /// redo return to next state
  ///
  ///     redux.redo();
  ///
  redo() {
    if (hasRedo) {
      if (kReleaseMode) {
        _index++;
      } else {
        var jOld = log.toLogString(state);
        _index++;
        var jNew = log.toLogString(state);
        log.log('${log.COLOR_STATE}redo $jNew ${log.COLOR_END}<= $jOld');
      }
    } else {
      log.log('nothing to undo');
    }
  }

  /// dispatch action and change state
  ///
  ///     redux.dispatch(MockAction.Increment, 1);
  ///
  Future<Map> dispatch(BuildContext ctx, dynamic action) async {
    if (kReleaseMode) {
      _setState(await _reducer(ctx, state, action));
    } else {
      var jOld = log.toLogString(state);
      var newState = await _reducer(ctx, state, action);
      var jNew = log.toLogString(newState);
      var payload = log.toLogString(action);
      log.log('${log.COLOR_STATE}action: ${action.runtimeType}{$payload}, state: $jNew ${log.COLOR_END}<= $jOld');
      _setState(newState);
    }
    return state;
  }
}
