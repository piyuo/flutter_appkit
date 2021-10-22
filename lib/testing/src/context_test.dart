import 'package:flutter_test/flutter_test.dart';
import 'context.dart';

void main() {
  setUp(() async {});

  group('[testing.context]', () {
    test('should create mock BuildContext', () async {
      Context ctx = Context();
      expect(ctx, isNotNull);
    });

    testWidgets('should scale down test font', (WidgetTester tester) async {
      useTestFont(tester);
    });
  });
}
