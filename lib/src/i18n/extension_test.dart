import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/delta.dart' as delta;
import 'package:libcli/asset.dart' as asset;
import 'package:libcli/testing.dart' as testing;
import 'package:intl/date_symbol_data_local.dart';
import 'package:libcli/src/pb/google/google.dart' as google;
import 'package:libcli/src/i18n/i18n.dart';
import 'package:libcli/src/i18n/extensions.dart';
import 'package:libcli/src/i18n/i18n-provider.dart';

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
      expect(LocaleWidget.value, 'A');
      expect(LocaleWidget.i18nValue, 'A');
      expect(LocaleWidget._i18nValue, 'OK');
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

      setLocale(testing.Context(), const Locale('en', 'US'));
      expect(t.localDateString, 'Jan 2, 2021');
      expect(t.localTimeString, '11:30 PM');
      expect(t.localDateTimeString, 'Jan 2, 2021 11:30 PM');

      setLocale(testing.Context(), const Locale('zh', 'CN'));
      expect(t.localDateString, '2021年1月2日');
      expect(t.localTimeString, '下午11:30');
      expect(t.localDateTimeString, '2021年1月2日 下午11:30');
    });
  });
}

class LocaleWidget extends StatelessWidget {
  static String value = '';
  static String i18nValue = '';
  static String _i18nValue = '';

  const LocaleWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    value = 'a'.i18n(context);
    i18nValue = i18n(context, 'a');
    _i18nValue = i18n_('ok');
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
                child: const LocaleWidget(),
              )),
    );
  }
}
