import 'package:flutter_test/flutter_test.dart';
import 'validator.dart';

void main() {
  setUp(() async {});

  group('[validators]', () {
/*
    test('should check input is required', () async {
      //show error on null input
      String? error = requiredValidator(input: null, label: 'title');
      expect(error, isNotEmpty);

      //show error on empty input
      error = requiredValidator(input: '', label: 'title');
      expect(error, isNotEmpty);

      //show error on input no have min length
      error = requiredValidator(input: '1', label: 'title', minLength: 3);
      expect(error, isNotEmpty);

      //show error on input over max length
      error = requiredValidator(input: '1234', label: 'title', maxLength: 3);
      expect(error, isNotEmpty);

      //no error
      error = requiredValidator(input: '1234', label: 'title', minLength: 3, maxLength: 5);
      expect(error, isNull);
    });
*/
    test('should validate using regex', () async {
      RegExp regexp = RegExp(r"^[A-Za-z]");
      String? error = regexpValidator(input: '1', regexp: regexp, label: 'title', example: 'A-z');
      expect(error, isNotEmpty);
      error = regexpValidator(input: 'A', regexp: regexp, label: 'title', example: 'A-z');
      expect(error, isNull);
    });

    test('should validate email', () async {
      String? error = emailValidator('1');
      expect(error, isNotEmpty);
      error = emailValidator('johndoe@domain.com');
      expect(error, isNull);
    });

    test('should validate domain name', () async {
      String? error = domainNameValidator('a');
      expect(error, isNotEmpty);
      error = domainNameValidator('www.g.com');
      expect(error, isNull);
    });

    test('should validate sub domain name', () async {
      String? error = subDomainNameValidator('a');
      expect(error, isNull);
      error = subDomainNameValidator('ab-cde');
      expect(error, isNull);
      error = subDomainNameValidator('ab_cde');
      expect(error, isNotEmpty);
      error = subDomainNameValidator('www.g.com');
      expect(error, isNotEmpty);
      error = subDomainNameValidator('a@');
      expect(error, isNotEmpty);
      error = subDomainNameValidator('a.');
      expect(error, isNotEmpty);
      error = subDomainNameValidator('中');
      expect(error, isNotEmpty);
      error = subDomainNameValidator('123');
      expect(error, isNull);
    });

    test('should validate name', () async {
      String? error = noSymbolValidator('abcde');
      expect(error, isNull);
      error = noSymbolValidator('ab cde');
      expect(error, isNull);
      error = noSymbolValidator('中文');
      expect(error, isNull);
      error = noSymbolValidator('!abcde');
      expect(error, isNotEmpty);
      error = noSymbolValidator('www.g.com');
      expect(error, isNotEmpty);
      error = noSymbolValidator('a@');
      expect(error, isNotEmpty);
      error = noSymbolValidator('中1');
      expect(error, isNull);
      error = noSymbolValidator('123');
      expect(error, isNull);
      error = noSymbolValidator('-');
      expect(error, isNotEmpty);
      error = noSymbolValidator('=');
      expect(error, isNotEmpty);
      error = noSymbolValidator('_');
      expect(error, isNotEmpty);
      error = noSymbolValidator('+');
      expect(error, isNotEmpty);
      error = noSymbolValidator('/');
      expect(error, isNotEmpty);
    });

    test('should validate url', () async {
      String? error = urlValidator('www.g.com');
      expect(error, isNotEmpty);
      error = urlValidator('http://www.ggg.com');
      expect(error, isNull);
    });

    test('should check chinese or japanese character', () async {
      final r = chineseOrJapaneseRegexp();
      expect(r.hasMatch('abc'), false);
      expect(r.hasMatch('ab中文c'), true);
      expect(r.hasMatch('abバッテリーc'), true);
    });
  });
}
