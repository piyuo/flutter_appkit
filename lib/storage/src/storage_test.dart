// ignore_for_file: invalid_use_of_visible_for_testing_member
import 'package:libcli/meta/sample/sample.dart' as sample;
import 'package:flutter_test/flutter_test.dart';
import 'storage.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    await clear();
  });

  group('[storage]', () {
    test('should set/get object', () async {
      final person = sample.Person(name: '123');
      await set('p', person);
      var p = await get<sample.Person>('p', () => sample.Person());
      expect(p, isNotNull);
      expect(p!.name, person.name);
      await delete('p');
      var p2 = await get<sample.Person>('p', () => sample.Person());
      expect(p2, isNull);
    });

    test('should set/get JSON', () async {
      await setJSON('item1', {'cleaning': 'done'});
      var item1 = await getJSON('item1');
      expect(item1!['cleaning'], 'done');
      await delete('item1');
      var item2 = await getJSON('item1');
      expect(item2, isNull);
      await clear();
    });
  });
}
