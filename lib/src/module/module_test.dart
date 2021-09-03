import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/testing.dart' as testing;
import 'module.dart';
import 'redux.dart';

void main() {
  group('[module]', () {
    test('should dispatch reducer', () async {
      Module provider = Module(
        redux: Redux(
          reducer,
          {'value': 0},
        ),
      );
      expect(provider.state['value'], 0);
      await provider.dispatch(testing.Context(), Increment(1));
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
