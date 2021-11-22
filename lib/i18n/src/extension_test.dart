import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/assets/assets.dart' as asset;
import 'package:intl/date_symbol_data_local.dart';
import 'package:libcli/pb/google.dart' as google;
import 'i18n.dart';
import 'extensions.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    // ignore: invalid_use_of_visible_for_testing_member
    asset.mock('{"a": "A"}');
  });

  tearDown(() async {
    // ignore: invalid_use_of_visible_for_testing_member
    asset.mockDone();
  });

  group('[i18n-extension]', () {
    test('should get local date', () async {
      var date = DateTime.utc(2021, 1, 2, 23, 30);
      var localDate = date.toLocal();
      google.Timestamp t = google.Timestamp.fromDateTime(date);
      expect(localDate, t.local);
    });

    test('should set local date', () async {
      var d = DateTime(2021, 1, 2, 23, 30);
      var t = timestamp();
      t.local = d;
      expect(t.local, d);
    });

    test('should create utc TimeStamp', () async {
      var date = DateTime(2021, 1, 2, 23, 30);
      google.Timestamp t = timestamp(datetime: date);
      expect(date, t.local);
    });

    test('should convert to local string', () async {
      await initializeDateFormatting('en_US', null);
      var date = DateTime(2021, 1, 2, 23, 30);
      google.Timestamp t = timestamp(datetime: date);

      setLocale('en_US');
      expect(t.localDateString, 'January 2, 2021');
      expect(t.localTimeString, '11:30 PM');
      expect(t.localDateTimeString, 'January 2, 2021 11:30 PM');

      setLocale('zh_CN');
      expect(t.localDateString, '2021年1月2日');
      expect(t.localTimeString, '下午11:30');
      expect(t.localDateTimeString, '2021年1月2日 下午11:30');
    });
  });
}

class L10nWidget extends StatelessWidget {
  static String value = '';

  const L10nWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    value = context.i18n.okButtonText;
    return Text(value);
  }
}
