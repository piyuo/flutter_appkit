// ignore_for_file: invalid_use_of_visible_for_testing_member

// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/testing/testing.dart' as testing;

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
      String? error = regexpValidator(testing.Context(), input: '1', regexp: regexp, label: 'title', example: 'A-z');
      expect(error, isNotEmpty);
      error = regexpValidator(testing.Context(), input: 'A', regexp: regexp, label: 'title', example: 'A-z');
      expect(error, isNull);
    });

    test('should validate email', () async {
      String? error = emailValidator(testing.Context(), '1');
      expect(error, isNotEmpty);
      error = emailValidator(testing.Context(), 'johndoe@domain.com');
      expect(error, isNull);
    });

    test('should validate domain name', () async {
      String? error = domainNameValidator(testing.Context(), 'a');
      expect(error, isNotEmpty);
      error = domainNameValidator(testing.Context(), 'www.g.com');
      expect(error, isNull);
    });

    test('should validate sub domain name', () async {
      String? error = subDomainNameValidator(testing.Context(), 'a');
      expect(error, isNull);
      error = subDomainNameValidator(testing.Context(), 'ab-cde');
      expect(error, isNull);
      error = subDomainNameValidator(testing.Context(), 'ab_cde');
      expect(error, isNotEmpty);
      error = subDomainNameValidator(testing.Context(), 'www.g.com');
      expect(error, isNotEmpty);
      error = subDomainNameValidator(testing.Context(), 'a@');
      expect(error, isNotEmpty);
      error = subDomainNameValidator(testing.Context(), 'a.');
      expect(error, isNotEmpty);
      error = subDomainNameValidator(testing.Context(), '中');
      expect(error, isNotEmpty);
      error = subDomainNameValidator(testing.Context(), '123');
      expect(error, isNull);
    });
/*
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
*/
    test('should validate url', () async {
      String? error = urlValidator(testing.Context(), 'www.g.com');
      expect(error, isNotEmpty);
      error = urlValidator(testing.Context(), 'http://www.ggg.com');
      expect(error, isNull);
    });

    test('should check chinese or japanese character', () async {
      final r = chineseOrJapaneseRegexp;
      expect(r.hasMatch('abc'), false);
      expect(r.hasMatch('ab中文c'), true);
      expect(r.hasMatch('abバッテリーc'), true);
    });

    test('should check ip address', () async {
      final r = ipAddressRegexp;
      expect(r.hasMatch('1.1.1.1'), true);
      expect(r.hasMatch('abc'), false);
      expect(r.hasMatch('192.168.1.1'), true);
      expect(r.hasMatch('192.168.1.a'), false);
    });
  });
}
