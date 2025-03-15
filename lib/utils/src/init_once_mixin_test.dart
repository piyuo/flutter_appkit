// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';

import 'init_once_mixin.dart';

class TestClass with InitOnceMixin {
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
      expect(testClass.initialized, false);

      await testClass.init();
      expect(testClass.initFutureCalled, true);
      expect(testClass.initialized, true);
    });
  });
}
