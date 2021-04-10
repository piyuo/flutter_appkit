import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/src/mocking/context.dart';

void main() {
  setUp(() async {});

  group('[test]', () {
    test('should create mock BuildContext', () async {
      Context ctx = Context();
      expect(ctx, isNotNull);
    });
  });
}
