import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/pattern.dart';
import 'package:flutter/material.dart';

void main() {
  MockRedux provider = MockRedux();
  group('[redux_provider]', () {
    test('should dispatch reducer', () async {
      expect(provider.state['value'], 0);
      await provider.dispatch(null, Increment(1));
      expect(provider.state['value'], 1);
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

class MockRedux extends ReduxProvider {
  MockRedux() : super(reducer, {'value': 0});
}
