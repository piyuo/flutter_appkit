import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/src/test/context.dart';

void main() {
  setUp(() async {});

  group('[mocking]', () {
    test('should create mock BuildContext', () async {
      Context ctx = Context();
      expect(ctx, isNotNull);
    });

    testWidgets('should scale down test font', (WidgetTester tester) async {
      useTestFont(tester);
    });
  });
}
