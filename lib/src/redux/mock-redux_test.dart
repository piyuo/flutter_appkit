import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/mocking.dart' as mocking;
import 'package:flutter/widgets.dart';
import 'package:libcli/src/redux/redux.dart';

void main() {
  setUp(() async {});

  group('[mock-redux]', () {
    test('should record last action', () async {
      MockRedux redux = MockRedux({});
      await redux.dispatch(mocking.Context(), Increment(1));
      expect(redux.lastAction is Increment, true);
    });
  });
}

class Increment {
  final int value;
  Increment(this.value);
}

Future<Map> _mock_reducers(BuildContext context, Map oldState, dynamic action) async {
  return oldState;
}

/// MockRedux extends redux to do test
///
class MockRedux extends Redux {
  dynamic lastAction;

  dynamic previousAction;

  /// MockRedux constructor with default state
  ///
  MockRedux(Map state) : super(_mock_reducers, state);

  /// logInitState no log in mock
  ///
  @override
  void logInitState() {}

  Future<void> dispatch(BuildContext context, dynamic action) async {
    previousAction = lastAction;
    lastAction = action;
  }
}
