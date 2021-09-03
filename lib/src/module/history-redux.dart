import 'package:flutter/widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:libcli/log.dart' as log;
import 'redux.dart';

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
        var jOld = log.toString(state);
        _index--;
        var jNew = log.toString(state);
        log.log('[redux] undo $jNew <= $jOld');
      }
    } else {
      log.log('[redux] nothing to undo');
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
        var jOld = log.toString(state);
        _index++;
        var jNew = log.toString(state);
        log.log('[redux] redo $jNew <= $jOld');
      }
    } else {
      log.log('[redux] nothing to undo');
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
      var jOld = log.toString(state);
      var newState = await _reducer(ctx, state, action);
      var jNew = log.toString(newState);
      var payload = log.toString(action);
      log.log('[redux] action: ${action.runtimeType}{$payload}, state: $jNew <= $jOld');
      _setState(newState);
    }
    return state;
  }
}
