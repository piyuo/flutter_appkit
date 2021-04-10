import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/src/redux/redux.dart';
import 'package:libcli/src/module/main.dart';
import 'package:flutter/widgets.dart';
import 'package:libcli/src/test/test.dart';

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
