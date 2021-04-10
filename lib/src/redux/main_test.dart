import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/src/redux/main.dart';
import 'package:libcli/src/redux/map.dart';
import 'package:flutter/widgets.dart';
import 'package:libcli/src/mocking/mocking.dart' as mocking;

void main() {
  setUp(() async {});

  group('[redux]', () {
    test('should dispatch and return true because state change', () async {
      Redux redux = Redux(reducer, {'value': 0});
      expect(redux.state['value'], 0);
      await redux.dispatch(mocking.MockBuildContext(), Increment(1));
      expect(redux.state['value'], 1);
    });

    test('should convert states to string', () {
      var result = stateToStr({'a': 0, 'b': 1});
      expect(result, '{a: 0, b: 1}');
    });

    test('should return false cause state not change', () async {
      Redux redux = Redux(reducer, {'value': 0});
      await redux.dispatch(mocking.MockBuildContext(), DoNothing());
      expect(redux.state['value'], 0);
    });

    test('should diff nest state', () async {
      Redux redux = Redux(reducer, {
        'value': 0,
        'child': {'text': 'hi'}
      });
      await redux.dispatch(mocking.MockBuildContext(), Change());
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
