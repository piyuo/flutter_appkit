import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/validator.dart' as validator;

void main() {
  setUp(() async {});

  group('[validator_validators]', () {
    test('should validate string is empty', () async {
      String error = validator.requiredValidator('', 'title');
      expect(error, isNotNull);
      error = validator.requiredValidator('has value', 'title');
      expect(error, isNull);
    });

    test('should validate using regex', () async {
      RegExp regexp = RegExp(r"^[A-Za-z]");
      String error = validator.regexpValidator('1', regexp, 'title', 'A-z');
      expect(error, isNotNull);
      error = validator.regexpValidator('A', regexp, 'title', 'A-z');
      expect(error, isNull);
    });

    test('should validate email', () async {
      String error = validator.emailValidator('1');
      expect(error, isNotNull);
      error = validator.emailValidator('johndoe@domain.com');
      expect(error, isNull);
    });

    test('should validate domain name', () async {
      String error = validator.domainNameValidator('a');
      expect(error, isNotNull);
      error = validator.domainNameValidator('www.g.com');
      expect(error, isNull);
    });

    test('should validate sub domain name', () async {
      String error = validator.subDomainNameValidator('abcde');
      expect(error, isNull);
      error = validator.subDomainNameValidator('ab-cde');
      expect(error, isNull);
      error = validator.subDomainNameValidator('ab_cde');
      expect(error, isNotNull);
      error = validator.subDomainNameValidator('www.g.com');
      expect(error, isNotNull);
      error = validator.subDomainNameValidator('a@');
      expect(error, isNotNull);
      error = validator.subDomainNameValidator('a.');
      expect(error, isNotNull);
      error = validator.subDomainNameValidator('中');
      expect(error, isNotNull);
      error = validator.subDomainNameValidator('123');
      expect(error, isNotNull);
    });

    test('should validate name', () async {
      String error = validator.noSymbolValidator('abcde');
      expect(error, isNull);
      error = validator.noSymbolValidator('ab cde');
      expect(error, isNull);
      error = validator.noSymbolValidator('中文');
      expect(error, isNull);
      error = validator.noSymbolValidator('!abcde');
      expect(error, isNotNull);
      error = validator.noSymbolValidator('www.g.com');
      expect(error, isNotNull);
      error = validator.noSymbolValidator('a@');
      expect(error, isNotNull);
      error = validator.noSymbolValidator('中1');
      expect(error, isNull);
      error = validator.noSymbolValidator('123');
      expect(error, isNull);
      error = validator.noSymbolValidator('-');
      expect(error, isNotNull);
      error = validator.noSymbolValidator('=');
      expect(error, isNotNull);
      error = validator.noSymbolValidator('_');
      expect(error, isNotNull);
      error = validator.noSymbolValidator('+');
      expect(error, isNotNull);
      error = validator.noSymbolValidator('/');
      expect(error, isNotNull);
    });

    test('should validate url', () async {
      String error = validator.urlValidator('www.g.com');
      expect(error, isNotNull);
      error = validator.urlValidator('http://www.ggg.com');
      expect(error, isNull);
    });
  });
}
