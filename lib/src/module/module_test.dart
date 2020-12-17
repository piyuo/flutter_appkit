import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/redux.dart';
import 'package:libcli/module.dart';
import 'package:flutter/widgets.dart';
import 'package:libcli/log.dart';
import 'package:mockito/mockito.dart';

class MockBuildContext extends Mock implements BuildContext {}

void main() {
  group('[module_provider]', () {
    test('should dispatch reducer', () async {
      Module provider = Module(
        redux: Redux(
          reducer,
          {'value': 0},
        ),
        services: {},
      );
      expect(provider.state['value'], 0);
      await provider.dispatch(MockBuildContext(), Increment(1));
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
