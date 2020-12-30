import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/src/test/navigator-observer.dart';

void main() {
  setUp(() async {});

  group('[test]', () {
    test('should create MockBuildContext', () async {
      MockNavigatorObserver mno = MockNavigatorObserver();
      expect(mno.toString(), isNotEmpty);
    });
  });
}
