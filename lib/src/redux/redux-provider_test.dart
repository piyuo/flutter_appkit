import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/redux.dart';
import 'package:flutter/material.dart';
import 'package:libcli/log.dart';

void main() {
  group('[redux_provider]', () {
    test('should set reduxNewState when use from()', () async {
      reduxNewState = null;
      Map state = Map();
      Map newState = from(state);
      expect(reduxNewState, newState);

      ReduxProvider provider = ReduxProvider(Redux(reducer, {'value': 0}));
      await provider.dispatch(null, Increment(1));
      expect(reduxNewState, isNull);
      reduxNewState = null;
    });

    test('should add/remove redux to state', () async {
      reduxStates.clear();
      expect(reduxStates.length, 0);
      ReduxProvider provider = ReduxProvider(Redux(reducer, {'value': 0}));
      expect(reduxStates.length, 1);
      provider.dispose();
      expect(reduxStates.length, 0);
    });

    test('should dispatch reducer', () async {
      ReduxProvider provider = ReduxProvider(Redux(reducer, {'value': 0}));
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
