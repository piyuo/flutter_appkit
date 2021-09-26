import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/src/pb/simple/error.pb.dart';

void main() {
  group('[object]', () {
    test('should return JSON', () {
      final obj = Error()..code = 'hi';
      expect(obj.jsonString, isNotEmpty);
    });

    test('should to json', () {
      final obj = Error()..code = 'hi';
      final jText = obj.toJson();
      expect(jText, isNotEmpty);

      final obj2 = Error.fromJson(jText);
      expect(obj2.code, 'hi');
    });
  });
}
