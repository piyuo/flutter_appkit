import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/delta/delta.dart' as delta;
import 'package:libcli/asset.dart' as asset;
import 'package:intl/date_symbol_data_local.dart';
import 'package:libcli/pb/google.dart' as google;
import 'i18n.dart';
import 'extensions.dart';
import 'i18n_provider.dart';

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
    testWidgets('should translate', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: TestWidget(),
      ));
      await tester.pumpAndSettle();
//      expect(LocaleWidget.value, 'A');
//      expect(LocaleWidget.i18nValue, 'A');
      expect(L10nWidget.value, 'OK');
    });

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
    value = 'ok'.i18n_;
    return Text(value);
  }
}

class TestWidget extends StatelessWidget {
  const TestWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<I18nProvider>(
          create: (context) => I18nProvider(fileName: 'mock'),
        ),
      ],
      child: Consumer<I18nProvider>(
          builder: (context, i18n, child) => delta.Await(
                [i18n],
                child: const L10nWidget(),
              )),
    );
  }
}
