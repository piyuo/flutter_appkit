// ===============================================
// Test Suite: locale_notifier_test.dart
// Description: Unit tests for LocaleNotifier
//
// Test Groups:
//   - Initialization
//   - Setting Locale
//   - Persistence
// ===============================================

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'locale.dart';
import 'locale_notifier.dart';
import 'preferences.dart' as preferences;

void main() {
  group('LocaleNotifier', () {
    late LocaleNotifier notifier;
    late ProviderContainer container;

    setUp(() {
      preferences.initForTest({});
      container = ProviderContainer();
      notifier = container.read(localeProvider.notifier);
    });

    tearDown(() {
      container.dispose();
    });

    test('initial state is null before loading', () async {
      // Wait for async _load() to complete with a longer delay
      await Future.delayed(Duration(milliseconds: 10));
      expect(container.read(localeProvider), isNull);
    });

    test('loads saved locale from preferences on initialization', () async {
      // Setup preferences with saved locale
      await preferences.prefSetString(kLanguageCodeInPreferences, 'es');
      await preferences.prefSetString(kCountryCodeInPreferences, 'MX');

      // Create new container to trigger loading
      final newContainer = ProviderContainer();
      // Access the notifier to trigger initialization
      newContainer.read(localeProvider.notifier);

      // Wait for async loading to complete
      await Future.delayed(Duration(milliseconds: 10));

      expect(newContainer.read(localeProvider), Locale('es', 'MX'));
      newContainer.dispose();
    });

    test('set() updates state regardless of preferences behavior', () async {
      // Test with a locale that's definitely non-system
      final japaneseLocale = Locale('ja', 'JP');
      await notifier.set(japaneseLocale);

      expect(container.read(localeProvider), japaneseLocale);
      expect(await preferences.prefGetString(kLanguageCodeInPreferences), 'ja');
      expect(await preferences.prefGetString(kCountryCodeInPreferences), 'JP');
    });
    test('set() preserves state even when preferences are cleared due to system locale match', () async {
      // This test verifies the fix for the race condition bug where _load()
      // could overwrite state set by set() method
      final locale = Locale('en', 'US');
      await notifier.set(locale);

      // State should be preserved regardless of preferences behavior
      expect(container.read(localeProvider), locale);

      // Preferences may be cleared if locale matches system locale (this is expected behavior)
      // We don't assert on preferences here since that depends on system locale
    });

    test('set() with only language code saves only language', () async {
      final locale = Locale('fr');
      await notifier.set(locale);

      await Future.delayed(Duration.zero);

      expect(container.read(localeProvider), locale);
      expect(await preferences.prefGetString(kLanguageCodeInPreferences), 'fr');
      expect(await preferences.prefGetString(kCountryCodeInPreferences), isNull);
    });

    test('set(null) clears preferences', () async {
      // First set a locale
      await notifier.set(Locale('fr', 'CA'));
      expect(await preferences.prefGetString(kLanguageCodeInPreferences), 'fr');
      expect(await preferences.prefGetString(kCountryCodeInPreferences), 'CA');

      // Then clear it
      await notifier.set(null);
      await Future.delayed(Duration.zero);

      expect(container.read(localeProvider), isNull);
      expect(await preferences.prefGetString(kLanguageCodeInPreferences), isNull);
      expect(await preferences.prefGetString(kCountryCodeInPreferences), isNull);
    });

    test('set() with whitespace-only languageCode clears preferences', () async {
      // First set a valid locale
      await notifier.set(Locale('de', 'DE'));
      expect(await preferences.prefGetString(kLanguageCodeInPreferences), 'de');

      // Then set locale with whitespace-only language code
      await notifier.set(Locale('   ', 'DE'));

      expect(container.read(localeProvider), Locale('   ', 'DE'));
      expect(await preferences.prefGetString(kLanguageCodeInPreferences), isNull);
      expect(await preferences.prefGetString(kCountryCodeInPreferences), isNull);
    });
  });
}
