import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/src/test/test.dart';

void main() {
  setUp(() async {
    TestMode = true;
  });
  tearDown(() async {
    TestMode = false;
  });
  test('should return true in TestMode', () async {
    expect(TestMode, true);
  });
}
