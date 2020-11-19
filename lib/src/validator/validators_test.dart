import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/validator.dart' as validator;

void main() {
  setUp(() async {});

  group('[validators]', () {
    test('should return null if input is null', () async {
      String? error = validator.requiredValidator(null, 'title');
      expect(error, isNull);
    });

    test('should validate string is empty', () async {
      String? error = validator.requiredValidator('', 'title');
      expect(error, isNotEmpty);
      error = validator.requiredValidator('has value', 'title');
      expect(error, isEmpty);
    });

    test('should validate using regex', () async {
      RegExp regexp = RegExp(r"^[A-Za-z]");
      String? error = validator.regexpValidator('1', regexp, 'title', 'A-z');
      expect(error, isNotEmpty);
      error = validator.regexpValidator('A', regexp, 'title', 'A-z');
      expect(error, isEmpty);
    });

    test('should validate email', () async {
      String? error = validator.emailValidator('1');
      expect(error, isNotEmpty);
      error = validator.emailValidator('johndoe@domain.com');
      expect(error, isEmpty);
    });

    test('should validate domain name', () async {
      String? error = validator.domainNameValidator('a');
      expect(error, isNotEmpty);
      error = validator.domainNameValidator('www.g.com');
      expect(error, isEmpty);
    });

    test('should validate sub domain name', () async {
      String? error = validator.subDomainNameValidator('a');
      expect(error, isEmpty);
      error = validator.subDomainNameValidator('ab-cde');
      expect(error, isEmpty);
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
      expect(error, isEmpty);
    });

    test('should validate name', () async {
      String? error = validator.noSymbolValidator('abcde');
      expect(error, isEmpty);
      error = validator.noSymbolValidator('ab cde');
      expect(error, isEmpty);
      error = validator.noSymbolValidator('中文');
      expect(error, isEmpty);
      error = validator.noSymbolValidator('!abcde');
      expect(error, isNotEmpty);
      error = validator.noSymbolValidator('www.g.com');
      expect(error, isNotEmpty);
      error = validator.noSymbolValidator('a@');
      expect(error, isNotEmpty);
      error = validator.noSymbolValidator('中1');
      expect(error, isEmpty);
      error = validator.noSymbolValidator('123');
      expect(error, isEmpty);
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
      expect(error, isEmpty);
    });
  });
}
