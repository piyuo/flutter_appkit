import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/redux.dart';
import 'package:libcli/module.dart';
import 'package:flutter/widgets.dart';
import 'package:libcli/test.dart';

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
      await provider.dispatch(MockBuildContext(), Increment(1));
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
