import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/src/log/logs.dart';
import 'package:libcli/log.dart';

void main() {
  setUp(() async {});

  group('[logs]', () {
    test('should push log', () {
      logs.clear();
      pushLog(message: 'hi');
      expect(logs.length, 1);
    });

    test('should push log', () {
      logs.clear();
      for (int i = 0; i <= 51; i++) {
        pushLog(message: 'hi');
      }
      expect(logs.length, 50);
      logs.clear();
    });

    test('should print logs', () {
      logs.clear();
      pushLog(message: 'first message');
      pushLog(message: 'second message', stacktrace: 'stacktrace', states: 'states');
      String text = printLogs();
      expect(text.isNotEmpty, true);
      logs.clear();
    });
  });
}
