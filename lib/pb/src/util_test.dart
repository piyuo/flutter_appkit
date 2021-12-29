import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/pb/src/simple/simple.dart' as simple;
import 'util.dart';

void main() {
  group('[util]', () {
    test('should able test PbOK', () {
      expect(isOK(simple.Error()), false);
      expect(isOK(simple.OK()), true);
    });

    test('should able test error', () {
      expect(
          isError(
            simple.Error()..code = 'a',
            'a',
          ),
          true);
      expect(
          isError(
            simple.Error()..code = 'b',
            'a',
          ),
          false);
      expect(isError(simple.OK(), 'a'), false);
    });

    test('should able test PbString', () {
      expect(
          isString(
            simple.String()..value = 'a',
            'a',
          ),
          true);
      expect(
          isString(
            simple.String()..value = 'b',
            'a',
          ),
          false);
      expect(isString(simple.OK(), 'a'), false);
    });

    test('should able test PbBool', () {
      expect(
          isBool(
            simple.Bool()..value = true,
            true,
          ),
          true);
      expect(
          isBool(
            simple.Bool()..value = false,
            true,
          ),
          false);
      expect(isBool(simple.OK(), false), false);
    });

    test('should able test PbInt', () {
      expect(
          isNumber(
            simple.Number()..value = 12,
            12,
          ),
          true);
      expect(
          isNumber(
            simple.Number()..value = 12,
            11,
          ),
          false);
      expect(isNumber(simple.OK(), 11), false);
    });
  });
}
