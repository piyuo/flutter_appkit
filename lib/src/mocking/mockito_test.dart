import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class Cat {
  String sound() => "Meow";

  void mew(String route) {
    print('hi');
  }
}

class MockCat extends Mock implements Cat {
  @override
  void mew(String? route) {
    // ignore: invalid_use_of_visible_for_testing_member
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
