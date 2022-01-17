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
  });
}
