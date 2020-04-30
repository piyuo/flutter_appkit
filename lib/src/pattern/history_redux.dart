import 'package:flutter/foundation.dart';
import 'package:libcli/log.dart';
import 'package:libcli/src/pattern/redux.dart';
import 'package:flutter/material.dart';

const _here = 'history_redux';

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

  ///_states is entiry state's hisotry and length is limit to historyLength
  ///
  List<Map> _states = List<Map>();

  /// HistoryRedux constructor with default hisotry length, reducer and state
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
        var jOld = toString(state);
        _index--;
        var jNew = toString(state);
        debugPrint('$_here~${STATE}undo $jNew $END<= $jOld');
      }
    } else {
      debugPrint('$_here~nothing to undo');
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
        var jOld = toString(state);
        _index++;
        var jNew = toString(state);
        debugPrint('$_here~${STATE}redo $jNew $END<= $jOld');
      }
    } else {
      debugPrint('$_here~nothing to undo');
    }
  }

  /// dispatch action and change state
  ///
  ///     redux.dispatch(MockAction.Increment, 1);
  ///
  Future<Map> dispatch(BuildContext ctx, dynamic action) async {
    assert(_reducer != null, '${runtimeType} must set reducer before use');
    if (kReleaseMode) {
      _setState(await _reducer(ctx, state, action));
    } else {
      var jOld = toString(state);
      var newState = await _reducer(ctx, state, action);
      var jNew = toString(newState);
      debugPrint('$_here~${STATE}${action.runtimeType} $jNew $END<= $jOld');
      _setState(newState);
    }
    return state;
  }
}
