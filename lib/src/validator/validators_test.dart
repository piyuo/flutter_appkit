import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/validator.dart' as validator;

void main() {
  setUp(() async {});

  group('[validators]', () {
    test('should check input is required', () async {
      //show error on null input
      String? error = validator.requiredValidator(input: null, label: 'title');
      expect(error, isNotEmpty);

      //show error on empty input
      error = validator.requiredValidator(input: '', label: 'title');
      expect(error, isNotEmpty);

      //show error on input no have min length
      error = validator.requiredValidator(input: '1', label: 'title', minLength: 3);
      expect(error, isNotEmpty);

      //show error on input over max length
      error = validator.requiredValidator(input: '1234', label: 'title', maxLength: 3);
      expect(error, isNotEmpty);

      //no error
      error = validator.requiredValidator(input: '1234', label: 'title', minLength: 3, maxLength: 5);
      expect(error, isNull);
    });

    test('should validate using regex', () async {
      RegExp regexp = RegExp(r"^[A-Za-z]");
      String? error = validator.regexpValidator(input: '1', regexp: regexp, label: 'title', example: 'A-z');
      expect(error, isNotEmpty);
      error = validator.regexpValidator(input: 'A', regexp: regexp, label: 'title', example: 'A-z');
      expect(error, isNull);
    });

    test('should validate email', () async {
      String? error = validator.emailValidator('1');
      expect(error, isNotEmpty);
      error = validator.emailValidator('johndoe@domain.com');
      expect(error, isNull);
    });

    test('should validate domain name', () async {
      String? error = validator.domainNameValidator('a');
      expect(error, isNotEmpty);
      error = validator.domainNameValidator('www.g.com');
      expect(error, isNull);
    });

    test('should validate sub domain name', () async {
      String? error = validator.subDomainNameValidator('a');
      expect(error, isNull);
      error = validator.subDomainNameValidator('ab-cde');
      expect(error, isNull);
      error = validator.subDomainNameValidator('ab_cde');
      expect(error, isNotEmpty);
      error = validator.subDomainNameValidator('www.g.com');
      expect(error, isNotEmpty);
      error = validator.subDomainNameValidator('a@');
      expect(error, isNotEmpty);
      error = validator.subDomainNameValidator('a.');
      expect(error, isNotEmpty);
      error = validator.subDomainNameValidator('中');
      expect(error, isNotEmpty);
      error = validator.subDomainNameValidator('123');
      expect(error, isNull);
    });

    test('should validate name', () async {
      String? error = validator.noSymbolValidator('abcde');
      expect(error, isNull);
      error = validator.noSymbolValidator('ab cde');
      expect(error, isNull);
      error = validator.noSymbolValidator('中文');
      expect(error, isNull);
      error = validator.noSymbolValidator('!abcde');
      expect(error, isNotEmpty);
      error = validator.noSymbolValidator('www.g.com');
      expect(error, isNotEmpty);
      error = validator.noSymbolValidator('a@');
      expect(error, isNotEmpty);
      error = validator.noSymbolValidator('中1');
      expect(error, isNull);
      error = validator.noSymbolValidator('123');
      expect(error, isNull);
      error = validator.noSymbolValidator('-');
      expect(error, isNotEmpty);
      error = validator.noSymbolValidator('=');
      expect(error, isNotEmpty);
      error = validator.noSymbolValidator('_');
      expect(error, isNotEmpty);
      error = validator.noSymbolValidator('+');
      expect(error, isNotEmpty);
      error = validator.noSymbolValidator('/');
      expect(error, isNotEmpty);
    });

    test('should validate url', () async {
      String? error = validator.urlValidator('www.g.com');
      expect(error, isNotEmpty);
      error = validator.urlValidator('http://www.ggg.com');
      expect(error, isNull);
    });
  });
}
