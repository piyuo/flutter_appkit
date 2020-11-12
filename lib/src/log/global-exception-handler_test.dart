import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/log.dart';
import 'package:libcli/src/log/global-exception-handler.dart';
import 'package:mockito/mockito.dart';

class MockBuildContext extends Mock implements BuildContext {}

void main() {
  debugPrint = overrideDebugPrint;

  group('[global-exception-handler]', () {
    test('should sendToGlobalExceptionHanlder', () {
      globalExceptionHandler = (BuildContext context, dynamic e, StackTrace s) {
        expect(e, 'mock');
        expect(s, isNotNull);
      };

      try {
        throw 'mock';
      } catch (e, s) {
        sendToGlobalExceptionHanlder(MockBuildContext(), e, s);
      }
    });
  });
}
