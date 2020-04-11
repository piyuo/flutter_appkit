import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/tools.dart';

void main() {
  setUp(() async {});

  group('[validators]', () {
    test('should validate string is empty', () async {
      String error = requiredValidator(null, '', 'title');
      expect(error, isNotNull);
      error = requiredValidator(null, 'has value', 'title');
      expect(error, isNull);
    });

    test('should validate using regex', () async {
      RegExp regexp = RegExp(r"^[A-Za-z]");
      String error = regexpValidator(null, '1', regexp, 'title', 'A-z');
      expect(error, isNotNull);
      error = regexpValidator(null, 'A', regexp, 'title', 'A-z');
      expect(error, isNull);
    });

    test('should validate email', () async {
      String error = emailValidator(null, '1');
      expect(error, isNotNull);
      error = emailValidator(null, 'johndoe@domain.com');
      expect(error, isNull);
    });

    test('should validate domain name', () async {
      String error = domainNameValidator(null, 'a');
      expect(error, isNotNull);
      error = domainNameValidator(null, 'www.g.com');
      expect(error, isNull);
    });

    test('should validate url', () async {
      String error = urlValidator(null, 'www.g.com');
      expect(error, isNotNull);
      error = urlValidator(null, 'http://www.ggg.com');
      expect(error, isNull);
    });
  });
}
