// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/testing/testing.dart' as testing;
import 'test.dart';

void main() {
  setUp(() async {});

  group('[mock-redux]', () {
    test('should record last action', () async {
      MockRedux redux = MockRedux({});
      await redux.dispatch(testing.Context(), Increment(1));
      expect(redux.lastAction is Increment, true);
    });
  });
}

class Increment {
  final int value;
  Increment(this.value);
}
