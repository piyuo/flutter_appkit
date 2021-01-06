import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/src/test/test.dart';

void main() {
  setUp(() async {});

  test('should return true when using testMode', () async {
    expect(testMode, true);
  });
}
