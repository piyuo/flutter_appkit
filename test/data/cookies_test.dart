import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/data/cookies.dart' as cookies;
import 'package:shared_preferences/shared_preferences.dart'; // rememeber to import shared_preferences: ^0.5.4+8

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});
/*
  const Map<String, dynamic> kTestValues = <String, dynamic>{
    'flutter.String': 'hello world',
    'flutter.bool': true,
    'flutter.int': 42,
    'flutter.double': 3.14159,
    'flutter.List': <String>['foo', 'bar'],
  };

  SharedPreferences preferences;

  setUp(() async {
    preferences = await SharedPreferences.getInstance();
  });

  tearDown(() async {
    await preferences.clear();
  });
  */
  //SharedPreferences.setMockInitialValues(Map < String, dynamic > values);
  group('[cookies]', () {
    test('should set/get', () async {
//      expect(preferences.get('String'), kTestValues['flutter.String']);
      await cookies.set('mock');
      var result = await cookies.get();
      expect(result, 'mock');
    });
  });
}
