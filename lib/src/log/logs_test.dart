import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/src/log/logs.dart';
import 'package:libcli/log.dart';

void main() {
  setUp(() async {});

  group('[logs]', () {
    test('should add log', () {
      expect(logs.length, 0);
      addLog(message: 'hi', level: 2);
      expect(logs.length, 1);
    });
  });
}
