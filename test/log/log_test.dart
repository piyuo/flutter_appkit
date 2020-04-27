import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/log.dart';
import 'package:libcli/configuration.dart' as configuration;

void main() {
  debugPrint = overrideDebugPrint;

  group('[log]', () {
    test('should debugPrint', () {
      configuration.appID = 'piyuo-web-index';
      configuration.userID = '111-222';
      debugPrint('here~mock test');
    });

    test('should log', () async {
      configuration.appID = 'log_test';
      configuration.userID = 'developer';
      configuration.branch = configuration.Branches.test;
      log('here~thing log here');
      warning('here~thing warning here');
      alert('here~thing alert here');
    });

    test('should alert no head', () async {
      try {
        debugPrint('no head');
      } catch (e) {
        expect(e, isNotNull);
      }
    });

    test('should error', () async {
      configuration.appID = 'log_test';
      configuration.userID = 'developer';
      configuration.branch = configuration.Branches.test;
      try {
        throw Exception('my error');
      } catch (e, s) {
        error('here', e, s);
      }
    });

    test('should create head', () {
      configuration.appID = 'piyuo-web-index';
      configuration.userID = '111-222';
      expect(head('here'), '111-222@piyuo-web-index/here: ');
    });

    test('should beautify stack trace', () async {
      try {
        throw Exception('hi');
      } catch (e, s) {
        String text = beautyStack(s);
        expect(text.length, greaterThan(0));
      }
    });

    test('should beautify stack line', () async {
      var l =
          '#0      main.<anonymous closure>.<anonymous closure> (file://libcli/test/log/log_test.dart:34:9)';
      expect(beautyLine(l),
          'at main.. (file://libcli/test/log/log_test.dart:34:9)');

      l = 'package:libcli/command.dart 46:15 post.<fn>';
      expect(beautyLine(l), 'at package:libcli/command.dart (46:15_post.<fn>)');
    });

    test('should turn object into string', () async {
      String str = toString(MockObject);
      expect(str.length, greaterThan(0));
    });
  });
}

class MockObject {
  int value = 0;
  Map toJson() {
    return {'value': value};
  }
}
