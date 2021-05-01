import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/src/redux/mock-redux.dart';
import 'package:libcli/mocking.dart' as mocking;

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
