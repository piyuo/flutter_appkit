import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/log/log.dart' as log;
import 'package:libcli/app/app.dart' as app;

const HERE = 'log_test';

void main() {
  group('log', () {
    test('should print info', () {
      app.piyuoid = 'piyuo-web-index';
      app.identity = '111-222';
      log.debug('log_test', 'hi');
      log.debugWarning('log_test', 'hi');
      log.debugAlert('log_test', 'hi');
    });

    test('should create head', () {
      app.piyuoid = 'piyuo-web-index';
      app.identity = '111-222';
      expect(log.head(HERE), '111-222@piyuo-web-index/log_test: ');
    });

    test('should log', () async {
      app.piyuoid = 'log_test';
      app.identity = 'developer';
      app.branch = app.Branch.test;
      log.info(HERE, 'flutter info');
      log.warning(HERE, 'flutter warning');
      log.alert(HERE, 'flutter alert');
    });

    test('should beautify stack trace', () async {
      try {
        throw Exception('hi');
      } catch (e, s) {
        String text = log.beautyStack(s);
        expect(text.length, greaterThan(0));
      }
    });

    test('should beautify stack line', () async {
      var l =
          '#0      main.<anonymous closure>.<anonymous closure> (file://libcli/test/log/log_test.dart:34:9)';
      expect(log.beautyLine(l),
          'at main.. (file://libcli/test/log/log_test.dart:34:9)');

      l = 'package:libcli/command/command_http.dart 46:15 post.<fn>';
      expect(log.beautyLine(l),
          'at package:libcli/command/command_http.dart (46:15_post.<fn>)');
    });

    test('should error', () async {
      app.piyuoid = 'log_test';
      app.identity = 'developer';
      app.branch = app.Branch.test;
      try {
        throw Exception('my error');
      } catch (e, s) {
        log.error(HERE, e, s);
      }
    });
  });
}
