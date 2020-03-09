import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/pattern/history_redux.dart';

void main() {
  setUp(() async {});

  group('[history_redux]', () {
    test('should dispatch', () async {
      HistoryRedux redux =
          HistoryRedux<MockState, MockAction>(2, reducer, MockState());
      expect(redux.state.value, 0);
      await redux.dispatch(MockAction.Increment, 1);
      expect(redux.state.value, 1);
    });

    test('should undo', () async {
      HistoryRedux redux =
          HistoryRedux<MockState, MockAction>(3, reducer, MockState());
      await redux.dispatch(MockAction.Increment, 1);
      await redux.dispatch(MockAction.Increment, 1);
      expect(redux.state.value, 2);
      expect(redux.hasUndo, true);
      redux.undo();
      expect(redux.state.value, 1);
      redux.undo();
      expect(redux.state.value, 0);
      //nothing to undo
      redux.undo();
      expect(redux.state.value, 0);
    });

    test('should redo', () async {
      HistoryRedux redux =
          HistoryRedux<MockState, MockAction>(3, reducer, MockState());
      await redux.dispatch(MockAction.Increment, 1);
      await redux.dispatch(MockAction.Increment, 1);
      redux.undo();
      expect(redux.state.value, 1);
      expect(redux.hasRedo, true);
      redux.redo();
      expect(redux.state.value, 2);
      //nothing to redo
      redux.redo();
      expect(redux.state.value, 2);
    });
  });
}

class MockState {
  int value = 0;
  Map toJson() {
    return {'value': value};
  }
}

enum MockAction { Increment }

MockState reducer(MockState state, MockAction action, dynamic payload) {
  switch (action) {
    case MockAction.Increment:
      return MockState()..value = state.value + payload;
  }
  return state;
}
