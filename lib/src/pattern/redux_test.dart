import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/pattern.dart';
import 'package:flutter/material.dart';

void main() {
  setUp(() async {});

  group('[redux]', () {
    test('should dispatch and return true because state change', () async {
      Redux redux = Redux(reducer, {'value': 0});
      expect(redux.state['value'], 0);
      redux.dispatch(null, Increment(1));
      expect(redux.state['value'], 1);
    });

    test('should return false cause state not change', () async {
      Redux redux = Redux(reducer, {'value': 0});
      redux.dispatch(null, DoNothing());
      expect(redux.state['value'], 0);
    });

    test('should diff nest state', () async {
      Redux redux = Redux(reducer, {
        'value': 0,
        'child': {'text': 'hi'}
      });
      redux.dispatch(null, Change());
      expect(redux.state['value'], 2);
    });
  });
}

class Increment {
  final int value;
  Increment(this.value);
}

class Change {}

class DoNothing {}

Future<Map> reducer(BuildContext context, Map oldState, dynamic action) async {
  var newState = oldState.deepCopy();
  if (action is Increment) {
    newState['value'] += action.value;
    return newState;
  }
  if (action is Change) {
    newState['value'] = 2;
    newState['child']['text'] = '';
    return newState;
  }
  return oldState;
}
