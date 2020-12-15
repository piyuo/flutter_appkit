import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/src/redux/mock-redux.dart';
import 'package:flutter/widgets.dart';
import 'package:mockito/mockito.dart';

class MockBuildContext extends Mock implements BuildContext {}

void main() {
  setUp(() async {});

  group('[mock-redux]', () {
    test('should record last action', () async {
      MockRedux redux = MockRedux({});
      await redux.dispatch(MockBuildContext(), Increment(1));
      expect(redux.lastAction is Increment, true);
    });
  });
}

class Increment {
  final int value;
  Increment(this.value);
}
