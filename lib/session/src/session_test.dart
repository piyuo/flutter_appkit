// ignore_for_file: invalid_use_of_visible_for_testing_member
import 'package:libcli/meta/sample/sample.dart' as sample;
import 'package:flutter_test/flutter_test.dart';
import 'session.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {});

  group('[storage]', () {
    test('should set/get object', () async {
      /*final person = sample.Person(name: '123');
      await set('p', person);
      var p = await get<sample.Person>('p', () => sample.Person());
      expect(p, isNotNull);
      expect(p!.name, person.name);
      await delete('p');
      var p2 = await get<sample.Person>('p', () => sample.Person());
      expect(p2, isNull);*/
    });
  });
}
