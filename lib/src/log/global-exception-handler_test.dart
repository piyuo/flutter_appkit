import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/log.dart';
import 'package:libcli/src/log/global-exception-handler.dart';

void main() {
  debugPrint = overrideDebugPrint;

  group('[global-exception-handler]', () {
    test('should sendToGlobalExceptionHanlder', () {
      globalExceptionHandler =
          (BuildContext context, dynamic e, StackTrace stackTrace,
              {String errorCode}) {
        expect(e, 'mock');
        expect(stackTrace, isNotNull);
        expect(errorCode, 'Mock Error');
      };

      try {
        throw 'mock';
      } catch (e, s) {
        sendToGlobalExceptionHanlder(null, e, s, errorCode: 'Mock Error');
      }
    });
  });
}
