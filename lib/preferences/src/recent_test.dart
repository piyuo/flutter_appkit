import 'package:flutter_test/flutter_test.dart';
import 'preferences.dart';
import 'recent.dart';

void main() {
  // ignore: invalid_use_of_visible_for_testing_member
  initForTest({});
  setUp(() async {
    await clear();
  });

  group('[preferences]', () {
    test('addRecent should recent keep recent history', () async {
      await remove('k');
      await addRecent('k', '1', maxLength: 2);
      await addRecent('k', '2', maxLength: 2);
      await addRecent('k', '3', maxLength: 2);
      var result = await getRecent('k');
      expect(result.length, 2);
      expect(result[0], '3');
      expect(result[1], '2');
    });

    test('getRecent should match input', () async {
      await remove('k');
      await addRecent('k', '123', maxLength: 2);
      await addRecent('k', 'abc', maxLength: 2);
      var result = await getRecent('k', input: 'a');
      expect(result.length, 1);
      expect(result[0], 'abc');
    });

    test('getRecent should match max length', () async {
      await remove('k');
      await addRecent('k', '123', maxLength: 2);
      await addRecent('k', 'abc', maxLength: 2);
      var result = await getRecent('k', maxLength: 1);
      expect(result.length, 1);
      expect(result[0], 'abc');
    });
  });
}
