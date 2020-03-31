import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/data/prefs.dart' as prefs;
import 'package:libcli/mock/mock.dart';

void main() {
  prefs.mockInit({});
  setUp(() async {});

  group('[prefs]', () {
    testWidgets('should get/set bool', (WidgetTester tester) async {
      await tester.inWidget((ctx) async {
        await prefs.setBool(ctx, 'k', true);
        var result = await prefs.getBool('k');
        expect(result, true);

        await prefs.setBool(ctx, 'k', false);
        result = await prefs.getBool('k');
        expect(result, false);
      });
    });

    test('should get false when no data', () async {
      var result = await prefs.getBool('na');
      expect(result, false);
    });

    testWidgets('should get/set Int', (WidgetTester tester) async {
      await tester.inWidget((ctx) async {
        await prefs.setInt(ctx, 'k', 1);
        var result = await prefs.getInt('k');
        expect(result, 1);
      });
    });

    test('should get 0 when no data', () async {
      var result = await prefs.getInt('na');
      expect(result, 0);
    });

    testWidgets('should get/set double', (WidgetTester tester) async {
      await tester.inWidget((ctx) async {
        await prefs.setDouble(ctx, 'k', 1.1);
        var result = await prefs.getDouble('k');
        expect(result, 1.1);
      });
    });

    test('should get 0 when no data', () async {
      var result = await prefs.getDouble('na');
      expect(result, 0);
    });

    testWidgets('should get/set string', (WidgetTester tester) async {
      await tester.inWidget((ctx) async {
        await prefs.setString(ctx, 'k', 'a');
        var result = await prefs.getString('k');
        expect(result, 'a');
      });
    });

    testWidgets('should get/set datetime', (WidgetTester tester) async {
      await tester.inWidget((ctx) async {
        var now = DateTime.now();
        var short = now.toString().toString().substring(0, 16);
        await prefs.setDateTime(ctx, 'k', now);
        var result = await prefs.getDateTime('k');
        expect(result.toString().substring(0, 16), short);
      });
    });

    test('should get empty string when no data', () async {
      var result = await prefs.getString('na');
      expect(result, '');
    });

    testWidgets('should get/set string list', (WidgetTester tester) async {
      await tester.inWidget((ctx) async {
        var list = ['a', 'b', 'c'];
        await prefs.setStringList(ctx, 'k', list);
        var result = await prefs.getStringList('k');
        expect(result[1], 'b');
      });
    });

    test('should get empty list when no data', () async {
      var result = await prefs.getStringList('na');
      expect(result, []);
    });

    testWidgets('should get/set map', (WidgetTester tester) async {
      await tester.inWidget((ctx) async {
        Map<String, dynamic> map = Map<String, dynamic>();
        map['a'] = 1;
        map['b'] = 2;

        await prefs.setMap(ctx, 'k', map);
        var result = await prefs.getMap('k');
        expect(result['b'], 2);
      });
    });
  });
}
