import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/src/test/mockito.dart';
import 'package:mockito/mockito.dart';

class MockCat extends Mock implements Cat {
  @override
  void mew(String? route) {
    super.noSuchMethod(Invocation.method(#mew, [route]));
  }
}

void main() {
  setUp(() async {});

  test('should test cat', () async {
    // Create mock object.
    var cat = MockCat(); // Interact with the mock object.

    cat.mew('hello');

    // Verify the interaction.
    verify(cat.mew(any));
  });
}
