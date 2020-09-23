import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/pattern.dart';
import 'package:flutter/material.dart';

void main() {
  setUp(() async {});

  group('[history-redux]', () {
    test('should dispatch', () async {
      HistoryRedux redux =
          HistoryRedux(reducer, {'value': 0}, historyLength: 2);
      expect(redux.state['value'], 0);
      await redux.dispatch(null, Increment(1));
      expect(redux.state['value'], 1);
    });

    test('should undo', () async {
      HistoryRedux redux =
          HistoryRedux(reducer, {'value': 0}, historyLength: 3);
      await redux.dispatch(null, Increment(1));
      await redux.dispatch(null, Increment(1));
      expect(redux.state['value'], 2);
      expect(redux.hasUndo, true);
      redux.undo();
      expect(redux.state['value'], 1);
      redux.undo();
      expect(redux.state['value'], 0);
      //nothing to undo
      redux.undo();
      expect(redux.state['value'], 0);
    });

    test('should redo', () async {
      HistoryRedux redux =
          HistoryRedux(reducer, {'value': 0}, historyLength: 3);
      await redux.dispatch(null, Increment(1));
      await redux.dispatch(null, Increment(1));
      redux.undo();
      expect(redux.state['value'], 1);
      expect(redux.hasRedo, true);
      redux.redo();
      expect(redux.state['value'], 2);
      //nothing to redo
      redux.redo();
      expect(redux.state['value'], 2);
    });
  });
}

class Increment {
  final int value;
  Increment(this.value);
}

Future<Map> reducer(BuildContext context, Map old, dynamic action) async {
  if (action is Increment) {
    var state = Map.from(old);
    state['value'] += action.value;
    return state;
  }
  return old;
}
