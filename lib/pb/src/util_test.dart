import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/pb/src/common/common.dart' as common;
import 'util.dart';

void main() {
  group('[util]', () {
    test('should able test PbOK', () {
      expect(isOK(common.Error()), false);
      expect(isOK(common.OK()), true);
    });

    test('should able test error', () {
      expect(
          isError(
            common.Error()..code = 'a',
            'a',
          ),
          true);
      expect(
          isError(
            common.Error()..code = 'b',
            'a',
          ),
          false);
      expect(isError(common.OK(), 'a'), false);
    });

    test('should able test PbString', () {
      expect(
          isString(
            common.String()..value = 'a',
            'a',
          ),
          true);
      expect(
          isString(
            common.String()..value = 'b',
            'a',
          ),
          false);
      expect(isString(common.OK(), 'a'), false);
    });

    test('should able test PbBool', () {
      expect(
          isBool(
            common.Bool()..value = true,
            true,
          ),
          true);
      expect(
          isBool(
            common.Bool()..value = false,
            true,
          ),
          false);
      expect(isBool(common.OK(), false), false);
    });

    test('should able test PbInt', () {
      expect(
          isNumber(
            common.Number()..value = 12,
            12,
          ),
          true);
      expect(
          isNumber(
            common.Number()..value = 12,
            11,
          ),
          false);
      expect(isNumber(common.OK(), 11), false);
    });
  });
}
