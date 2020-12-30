import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/src/test/test.dart';

void main() {
  setUp(() async {});

  test('should create MockBuildContext', () async {
    MockBuildContext context = MockBuildContext();
    expect(context.toString(), isNotEmpty);
  });
}
