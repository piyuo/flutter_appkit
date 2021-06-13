import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/src/pb/simple/error.pb.dart';

void main() {
  group('[object]', () {
    test('should return JSON', () {
      final obj = Error()..code = 'hi';
      expect(obj.jsonString, isNotEmpty);
    });
  });
}
