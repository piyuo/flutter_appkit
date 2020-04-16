import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/validator.dart' as validator;

void main() {
  setUp(() async {});

  group('[validator_validators]', () {
    test('should validate string is empty', () async {
      String error = validator.requiredValidator(null, '', 'title');
      expect(error, isNotNull);
      error = validator.requiredValidator(null, 'has value', 'title');
      expect(error, isNull);
    });

    test('should validate using regex', () async {
      RegExp regexp = RegExp(r"^[A-Za-z]");
      String error =
          validator.regexpValidator(null, '1', regexp, 'title', 'A-z');
      expect(error, isNotNull);
      error = validator.regexpValidator(null, 'A', regexp, 'title', 'A-z');
      expect(error, isNull);
    });

    test('should validate email', () async {
      String error = validator.emailValidator(null, '1');
      expect(error, isNotNull);
      error = validator.emailValidator(null, 'johndoe@domain.com');
      expect(error, isNull);
    });

    test('should validate domain name', () async {
      String error = validator.domainNameValidator(null, 'a');
      expect(error, isNotNull);
      error = validator.domainNameValidator(null, 'www.g.com');
      expect(error, isNull);
    });

    test('should validate url', () async {
      String error = validator.urlValidator(null, 'www.g.com');
      expect(error, isNotNull);
      error = validator.urlValidator(null, 'http://www.ggg.com');
      expect(error, isNull);
    });
  });
}
