import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/src/util/delay-run.dart';

void main() {
  group('[utils/delay-run]', () {
    test('should delay run', () async {
      DelayedRun delayRun = DelayedRun();

      var result = 0;
      delayRun.run(() async {
        result++;
      });
      delayRun.run(() async {
        result++;
      });
      expect(result, 0);
      await Future.delayed(const Duration(milliseconds: 900));
      expect(result, 1); // only 1, cause fist run was canceled
    });
  });
}
