// ===============================================
// Test Suite: locale_test.dart
// Description: Unit tests for locale.dart utilities
//
// Test Groups:
//   - Locale Parsing
//   - System Locale Helpers
//   - Locale Resolution Callback
//   - Display Name Maps
// ===============================================

import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:libcli/src/locale.dart';

void main() {
  group('Locale Parsing', () {
    test('Parses language only', () {
      final locale = localeParseString('en');
      expect(locale.languageCode, 'en');
      expect(locale.countryCode, isNull);
    });
    test('Parses language and country', () {
      final locale = localeParseString('en_US');
      expect(locale.languageCode, 'en');
      expect(locale.countryCode, 'US');
    });
  });

  group('System Locale Helpers', () {
    test('localeIsSystem returns true if defaultLocale is null', () {
      final originalDefault = Intl.defaultLocale;
      Intl.defaultLocale = null;
      expect(localeIsSystem, isTrue);
      Intl.defaultLocale = originalDefault;
    });
    test('localeIsSystem returns true if systemLocale == defaultLocale', () {
      final originalDefault = Intl.defaultLocale;
      Intl.defaultLocale = Intl.systemLocale;
      expect(localeIsSystem, isTrue);
      Intl.defaultLocale = originalDefault;
    });
    test('localeIsSystem returns false if systemLocale != defaultLocale', () {
      final originalDefault = Intl.defaultLocale;
      Intl.defaultLocale = 'fr';
      expect(localeIsSystem, isFalse);
      Intl.defaultLocale = originalDefault;
    });
  });

  group('Locale Resolution Callback', () {
    final supported = [
      const Locale('en'),
      const Locale('fr'),
      const Locale('es', 'MX'),
    ];
    test('Returns default en if locale is null', () {
      expect(localeResolutionCallback(null, supported), const Locale('en'));
    });
    test('Returns exact match (lang+country)', () {
      expect(localeResolutionCallback(const Locale('es', 'MX'), supported), const Locale('es', 'MX'));
    });
    test('Returns language-only match', () {
      expect(localeResolutionCallback(const Locale('fr', 'CA'), supported), const Locale('fr'));
    });
    test('Returns default en if no match', () {
      expect(localeResolutionCallback(const Locale('de'), supported), const Locale('en'));
    });
  });

  group('Display Name Maps', () {
    test('localeDisplayLabels contains known keys', () {
      expect(localeDisplayLabels['en'], 'English');
      expect(localeDisplayLabels['zh_CN'], contains('中文'));
    });
    test('localeEngNames contains known keys', () {
      expect(localeEngNames['fr'], 'French');
      expect(localeEngNames['es_MX'], 'Spanish (Mexico)');
    });
  });
}
