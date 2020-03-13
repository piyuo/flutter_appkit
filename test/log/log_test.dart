import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/log/log.dart';
import 'package:libcli/hook/vars.dart' as vars;

void main() {
  group('[log]', () {
    test('should print', () {
      vars.AppID = 'piyuo-web-index';
      vars.UserID = '111-222';
      'here|mock ${VERB}test'.print;
    });

    test('should log', () async {
      vars.AppID = 'log_test';
      vars.UserID = 'developer';
      vars.Branch = vars.Branches.test;
      'here|thing ${VERB}log ${NOUN}here'.log;
      'here|thing ${VERB}warning ${NOUN}here'.warning;
      'here|thing ${VERB}alert ${NOUN}here'.alert;
    });

    test('should alert no head', () async {
      try {
        'no head'.print;
      } catch (e) {
        expect(e, isNotNull);
      }
    });

    test('should error', () async {
      vars.AppID = 'log_test';
      vars.UserID = 'developer';
      vars.Branch = vars.Branches.test;
      try {
        throw Exception('my error');
      } catch (e, s) {
        'here'.error(e, s);
      }
    });

    test('should create head', () {
      vars.AppID = 'piyuo-web-index';
      vars.UserID = '111-222';
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

      l = 'package:libcli/command/command_http.dart 46:15 post.<fn>';
      expect(beautyLine(l),
          'at package:libcli/command/command_http.dart (46:15_post.<fn>)');
    });
  });
}
