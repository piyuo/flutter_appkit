import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/pattern/redux.dart';

void main() {
  setUp(() async {});

  group('[redux]', () {
    test('should dispatch', () async {
      Redux redux = Redux<MockState, MockAction>(reducer, MockState());
      expect(redux.state.value, 0);
      await redux.dispatch(MockAction.Increment, 1);
      expect(redux.state.value, 1);
    });

    test('should turn object into string', () async {
      String str = toString(MockState);
      expect(str.length, greaterThan(0));
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
      return state..value = state.value + payload;
  }
  return state;
}
