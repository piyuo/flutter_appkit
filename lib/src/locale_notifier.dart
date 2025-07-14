// ===============================================
// File: locale_notifier.dart
// Overview: StateNotifier for managing app locale
//
// Sections:
//   - Imports
//   - Provider Declaration
//   - LocaleNotifier Class
//     - Initialization & Loading
//     - Preference Persistence
//     - State Management
// ===============================================

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'locale.dart';
import 'preferences.dart';

/// Provides the current [Locale] and allows updating it.
final localeProvider = StateNotifierProvider<LocaleNotifier, Locale?>((ref) {
  return LocaleNotifier();
});

/// StateNotifier for managing the app's locale.
///
/// Loads the locale from preferences on initialization, allows updating,
/// and persists changes. Also updates [Intl.defaultLocale].
class LocaleNotifier extends StateNotifier<Locale?> {
  bool _hasBeenExplicitlySet = false;

  LocaleNotifier() : super(null) {
    _load();
  }

  /// Loads the locale from preferences asynchronously.
  /// Returns null if no locale is saved.
  Future<Locale?> _loadFromPref() async {
    final languageCode = await prefGetString(kLanguageCodeInPreferences);
    final countryCode = await prefGetString(kCountryCodeInPreferences);
    if (languageCode != null && languageCode.trim().isNotEmpty) {
      return Locale(languageCode, countryCode?.isNotEmpty == true ? countryCode : null);
    }
    return null;
  }

  /// Loads the locale and updates state and Intl.defaultLocale.
  /// Only updates state if it hasn't been explicitly set by the user.
  void _load() async {
    final locale = await _loadFromPref();
    // Only set state from preferences if it hasn't been explicitly set
    if (!_hasBeenExplicitlySet) {
      state = locale;
      Intl.defaultLocale = locale?.toString();
    }
  }

  /// Saves the locale to preferences. Removes keys if locale is null or matches system locale.
  Future<void> _saveToPref(Locale? locale) async {
    if (locale == null || locale.languageCode.trim().isEmpty || locale.toString() == Intl.systemLocale) {
      await prefRemoveKey(kLanguageCodeInPreferences);
      await prefRemoveKey(kCountryCodeInPreferences);
    } else {
      await prefSetString(kLanguageCodeInPreferences, locale.languageCode);
      if (locale.countryCode != null && locale.countryCode!.isNotEmpty) {
        await prefSetString(kCountryCodeInPreferences, locale.countryCode!);
      } else {
        await prefRemoveKey(kCountryCodeInPreferences);
      }
    }
  }

  /// Sets a new locale, updates state, Intl.defaultLocale, and persists the change.
  Future<void> set(Locale? newLocale) async {
    _hasBeenExplicitlySet = true;
    state = newLocale;
    Intl.defaultLocale = newLocale?.toString();
    await _saveToPref(newLocale);
  }
}
