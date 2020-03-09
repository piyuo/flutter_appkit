import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/pattern/redux_provider.dart';

void main() {
  MockRedux provider = MockRedux();
  group('[redux_provider]', () {
    test('should dispatch reducer', () async {
      expect(provider.state.value, 0);
      provider.dispatch(MockAction.Increment, 1);
      expect(provider.state.value, 1);
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
      state.value += payload;
      return state;
  }
  return state;
}

class MockRedux extends ReduxProvider<MockState, MockAction> {
  MockRedux() : super(reducer, MockState());
}
