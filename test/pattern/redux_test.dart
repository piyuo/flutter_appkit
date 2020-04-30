import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/pattern.dart';
import 'package:flutter/material.dart';

void main() {
  setUp(() async {});

  group('[redux]', () {
    test('should dispatch', () async {
      Redux redux = Redux(reducer, {'value': 0});
      expect(redux.state['value'], 0);
      await redux.dispatch(null, Increment(1));
      expect(redux.state['value'], 1);
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
