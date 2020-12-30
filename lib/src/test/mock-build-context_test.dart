import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/src/test/mock-navigator.dart';

void main() {
  setUp(() async {});

  group('[test]', () {
    test('should create MockBuildContext', () async {
      MockNavigator mno = MockNavigator();
      expect(mno.toString(), isNotEmpty);
    });
  });
}
