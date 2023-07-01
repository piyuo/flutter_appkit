// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:flutter_test/flutter_test.dart';
import 'datetime.dart';
import 'duration.dart';

void main() {
  group('[i18n.duration]', () {
    test('should format duration', () async {
      await changeDateFormatting('en_US');
      const dur = Duration(
        days: 5,
        hours: 23,
        minutes: 59,
        seconds: 59,
        milliseconds: 999,
        microseconds: 999,
      );
      const min12sec35 = Duration(
        minutes: 12,
        seconds: 35,
      );
      expect(dur.formattedPretty, '5 days 23 hours 59 minutes 59 seconds');
      expect(min12sec35.formattedPretty, '12 minutes 35 seconds');

      await changeDateFormatting('zh_CN');
      expect(dur.formattedPretty, '5日 23小时 59分 59秒');
      expect(min12sec35.formattedPretty, '12分 35秒');

      await changeDateFormatting('zh_TW');
      expect(dur.formattedPretty, '5日 23小時 59分鐘 59秒');
      expect(min12sec35.formattedPretty, '12分鐘 35秒');
    });
  });
}
