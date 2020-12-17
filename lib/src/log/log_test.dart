import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/log.dart';
import 'package:libcli/app.dart' as configuration;

void main() {
  group('[log]', () {
    test('should remove color', () {
      String message = COLOR_END + 'set locale=en_US';
      expect(removeColor(message), 'set locale=en_US');
      message = COLOR_RED + 'set locale=en_US';
      expect(removeColor(message), 'set locale=en_US');
      message = COLOR_GREEN + 'set locale=en_US';
      expect(removeColor(message), 'set locale=en_US');
      message = COLOR_YELLOW + 'set locale=en_US';
      expect(removeColor(message), 'set locale=en_US');
      message = COLOR_BLUE + 'set locale=en_US';
      expect(removeColor(message), 'set locale=en_US');
      message = COLOR_MAGENTA + 'set locale=en_US';
      expect(removeColor(message), 'set locale=en_US');
      message = COLOR_CYAN + 'set locale=en_US';
      expect(removeColor(message), 'set locale=en_US');
    });


    test('should log', () async {
      configuration.appID = 'log_test';
      configuration.userID = 'developer';
      log('hi');
    });

    test('should error', () async {
      configuration.appID = 'log_test';
      configuration.userID = 'developer';
      try {
        throw Exception('my error');
      } catch (e, s) {
        error(e, s);
      }
    });

    test('should create head', () {
      configuration.appID = 'piyuo-web-index';
      configuration.userID = '111-222';
      // ignore: invalid_use_of_visible_for_testing_member
      expect(header, '111-222@piyuo-web-index:');
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
      var l = '#0      main.<anonymous closure>.<anonymous closure> (file://libcli/test/log/log_test.dart:34:9)';
      // ignore: invalid_use_of_visible_for_testing_member
      expect(beautyLine(l), 'at main.. (file://libcli/test/log/log_test.dart:34:9)');

      l = 'package:libcli/command.dart 46:15 post.<fn>';
      // ignore: invalid_use_of_visible_for_testing_member
      expect(beautyLine(l), 'at package:libcli/command.dart (46:15_post.<fn>)');
    });

    test('should turn object into string', () async {
      String str = toLogString(MockObject);
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
