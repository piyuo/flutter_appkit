import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/pattern.dart';
import 'package:flutter/material.dart';
import 'package:libcli/log.dart';

void main() {
  group('[redux_provider]', () {
    test('should add/remove redux to instances', () async {
      reduxStates.clear();
      expect(reduxStates.length, 0);
      MockReduxProvider provider = MockReduxProvider();
      expect(reduxStates.length, 1);
      provider.dispose();
      expect(reduxStates.length, 0);
    });

    test('should dispatch reducer', () async {
      MockReduxProvider provider = MockReduxProvider();
      expect(provider.state['value'], 0);
      await provider.dispatch(null, Increment(1));
      expect(provider.state['value'], 1);
      provider.dispose();
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

class MockReduxProvider extends ReduxProvider {
  MockReduxProvider() : super(reducer, {'value': 0});
}
