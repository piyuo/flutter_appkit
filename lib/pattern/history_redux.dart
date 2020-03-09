import 'package:flutter/foundation.dart';
import 'package:libcli/log/log.dart';
import 'package:libcli/pattern/redux.dart';

const _here = 'history_redux';

/// HistoryRedux implements redux pattern and have ability to undo and redo
///
class HistoryRedux<S, A> {
  /// history length
  ///
  final int _historyLength;

  /// _reducer only instance
  ///
  final Reducer<S, A> _reducer;

  /// _index point to current state in states history
  /// ,
  int _index = 0;

  ///_states is entiry state's hisotry and length is limit to _historyLength
  ///
  List<S> _states = List<S>();

  /// HistoryRedux constructor with default hisotry length, reducer and state
  ///
  ///     HistoryRedux redux =HistoryRedux<MockState, MockAction>(20, reducer, MockState());
  ///
  HistoryRedux(this._historyLength, this._reducer, S state) {
    _states.add(state);
  }

  /// _state is current state
  ///
  S get state => _states[_index];

  /// _setState add states to states history
  ///
  _setState(S value) {
    if (_index != _states.length - 1) {
      _states.removeRange(_index, _states.length);
    }
    _states.add(value);
    if (_states.length > _historyLength) {
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
        '$_here|undo $NOUN$jOld $END=> $NOUN2$jNew'.print;
      }
    } else {
      '$_here|nothing to undo'.print;
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
        '$_here|redo $NOUN$jOld $END=> $NOUN2$jNew'.print;
      }
    } else {
      '$_here|nothing to undo'.print;
    }
  }

  /// dispatch action and change state
  ///
  ///     redux.dispatch(MockAction.Increment, 1);
  ///
  Future<void> dispatch(A action, dynamic payload) async {
    assert(_reducer != null, '${runtimeType} must set reducer before use');
    if (kReleaseMode) {
      _setState(_reducer(state, action, payload));
    } else {
      var jOld = toString(state);
      var newState = _reducer(state, action, payload);
      var jNew = toString(newState);
      var jAction = toString(action);
      var jPayload = toString(payload);
      '$_here|$jOld => $VERB$jAction $NOUN$jPayload $END=> $NOUN2$jNew'.print;
      _setState(newState);
    }
  }
}
