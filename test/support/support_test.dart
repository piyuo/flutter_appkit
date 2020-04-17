import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/support.dart' as support;

void main() {
  setUp(() async {});

  group('[support]', () {
    test('should build error email', () async {
      support.ErrorEmailBuilder builder = support.ErrorEmailBuilder();
      try {
        throw 'mockError';
      } catch (e, s) {
        var record = support.ErrorRecord('1', e, s);
        builder.add(record);
      }
      expect(builder.to, isNotEmpty);
      expect(builder.subject, isNotEmpty);
      expect(builder.body, isNotEmpty);

      try {
        throw 'mockError2';
      } catch (e, s) {
        var record = support.ErrorRecord('2', e, s);
        builder.add(record);
      }

      expect(builder.to, isNotEmpty);
      expect(builder.subject, isNotEmpty);
      expect(builder.body, isNotEmpty);
      expect(builder.linkMailTo, isNotEmpty);
    });
  });
}
