import 'package:flutter_test/flutter_test.dart';
import 'simple/types.dart' as types;
import 'util.dart';

void main() {
  group('[util]', () {
    test('should able test PbOK', () {
      expect(isOK(types.Error()), false);
      expect(isOK(types.OK()), true);
    });

    test('should able test error', () {
      expect(
          isError(
            types.Error()..code = 'a',
            'a',
          ),
          true);
      expect(
          isError(
            types.Error()..code = 'b',
            'a',
          ),
          false);
      expect(isError(types.OK(), 'a'), false);
    });

    test('should able test PbString', () {
      expect(
          isString(
            types.String()..value = 'a',
            'a',
          ),
          true);
      expect(
          isString(
            types.String()..value = 'b',
            'a',
          ),
          false);
      expect(isString(types.OK(), 'a'), false);
    });

    test('should able test PbBool', () {
      expect(
          isBool(
            types.Bool()..value = true,
            true,
          ),
          true);
      expect(
          isBool(
            types.Bool()..value = false,
            true,
          ),
          false);
      expect(isBool(types.OK(), false), false);
    });

    test('should able test PbInt', () {
      expect(
          isNumber(
            types.Number()..value = 12,
            12,
          ),
          true);
      expect(
          isNumber(
            types.Number()..value = 12,
            11,
          ),
          false);
      expect(isNumber(types.OK(), 11), false);
    });
  });
}
