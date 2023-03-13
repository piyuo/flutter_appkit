import 'package:flutter_test/flutter_test.dart';
import 'need_initialize_mixin.dart';

class TestClass with NeedInitializeMixin {
  bool initFutureCalled = false;
  TestClass() {
    initFuture = () async {
      initFutureCalled = true;
    };
  }
}

void main() {
  setUp(() async {});

  group('[types.need_initialize_mixin]', () {
    test('should call initFuture', () async {
      final testClass = TestClass();
      expect(testClass.initFutureCalled, false);
      expect(testClass.isReady, false);

      await testClass.init();
      expect(testClass.initFutureCalled, true);
      expect(testClass.isReady, true);
    });
  });
}
