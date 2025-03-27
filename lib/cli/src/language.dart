import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

/// A class that represents a language with its locale and name.
class Language {
  /// the locale of the language.
  final Locale locale;

  /// the name of the language in its native form.
  final String name;

  /// the name of the language in English.
  final String engName;

  /// Creates a [Language] instance.
  Language({required this.locale, required this.name, required this.engName});

  /// Returns the display name of the language in the format "engName - name".
  String get displayName => '$engName - $name';

  /// Returns a list of [Language] instances from the given list of supported locales.
  static List<Language> fromSupportedLocales(List<Locale> supportedLocales) {
    final result = supportedLocales.map((locale) {
      String name = localeNames[locale.toString()] ?? locale.toString();
      String engName = localeEngNames[locale.toString()] ?? locale.toString();
      return Language(locale: locale, name: name, engName: engName);
    }).toList();
    result.sort((a, b) => a.engName.compareTo(b.engName));
    return result;
  }
}

/// parse the locale string to a [Locale] object
Locale parseLocale(String localeString) {
  final parts = localeString.split('_');
  if (parts.length == 2) {
    return Locale(parts[0], parts[1]);
  } else {
    return Locale(localeString);
  }
}

/// return the default locale of the app
Locale? get defaultLocale => Intl.defaultLocale == null ? null : parseLocale(Intl.defaultLocale!);

/// return is using the system locale
bool get isSystemLocale => Intl.defaultLocale == null || Intl.systemLocale == Intl.defaultLocale;

/// A function that returns the locale resolution callback for the app.
Locale? localeResolutionCallback(locale, supportedLocales) {
  if (locale == null) {
    return const Locale('en'); // default to 'en'
  }

  // languageCode + countryCode
  for (var supportedLocale in supportedLocales) {
    if (supportedLocale.languageCode == locale.languageCode && supportedLocale.countryCode == locale.countryCode) {
      return supportedLocale;
    }
  }

  // only languageCode
  for (var supportedLocale in supportedLocales) {
    if (supportedLocale.languageCode == locale.languageCode) {
      return supportedLocale;
    }
  }

  // default 'en'
  return const Locale('en');
}

Map<String, String> localeNames = {
  // A
  'af': 'Afrikaans',
  'am': 'አማርኛ', // Amharic
  'ar': 'العربية', // Arabic
  'ar_AE': 'العربية (الإمارات)', // Arabic (UAE)
  'ar_DZ': 'العربية (الجزائر)', // Arabic (Algeria)
  'ar_EG': 'العربية (مصر)', // Arabic (Egypt)
  'az': 'Azərbaycan', // Azerbaijani

  // B
  'bg': 'Български', // Bulgarian
  'bn': 'বাংলা', // Bengali
  'bn_IN': 'বাংলা (ভারত)', // Bengali (India)

  // C
  'ca': 'Català', // Catalan
  'cs': 'Čeština', // Czech

  // D
  'da': 'Dansk', // Danish
  'de': 'Deutsch', // German
  'de_AT': 'Deutsch (Österreich)', // German (Austria)
  'de_CH': 'Deutsch (Schweiz)', // German (Switzerland)

  // E
  'el': 'Ελληνικά', // Greek
  'en': 'English',
  'en_AU': 'English (Australia)',
  'en_CA': 'English (Canada)',
  'en_GB': 'English (United Kingdom)',
  'en_IN': 'English (India)',
  'es': 'Español', // Spanish
  'es_AR': 'Español (Argentina)',
  'es_CO': 'Español (Colombia)',
  'es_MX': 'Español (México)',
  'et': 'Eesti', // Estonian

  // F
  'fa': 'فارسی', // Persian
  'fi': 'Suomi', // Finnish
  'fr': 'Français', // French
  'fr_BE': 'Français (Belgique)', // French (Belgium)
  'fr_CA': 'Français (Canada)', // French (Canada)
  'fr_CH': 'Français (Suisse)', // French (Switzerland)

  // G
  'gl': 'Galego', // Galician
  'gu': 'ગુજરાતી', // Gujarati

  // H
  'ha': 'Hausa', // Hausa
  'he': 'עברית', // Hebrew
  'hi': 'हिन्दी', // Hindi
  'hr': 'Hrvatski', // Croatian
  'hu': 'Magyar', // Hungarian

  // I
  'id': 'Bahasa Indonesia', // Indonesian
  'it': 'Italiano', // Italian

  // J
  'ja': '日本語', // Japanese

  // K
  'kk': 'Қазақ тілі', // Kazakh
  'ko': '한국어', // Korean
  'ku': 'Kurdî', // Kurdish

  // L
  'ln': 'Lingála', // Lingala
  'lt': 'Lietuvių', // Lithuanian
  'lv': 'Latviešu', // Latvian

  // M
  'ml': 'മലയാളം', // Malayalam
  'mn': 'Монгол', // Mongolian
  'mr': 'मराठी', // Marathi
  'ms': 'Bahasa Melayu', // Malay
  'ms_SG': 'Bahasa Melayu (Singapura)', // Malay (Singapore)
  'my': 'မြန်မာ', // Burmese

  // N
  'nb': 'Norsk bokmål', // Norwegian Bokmål
  'ne': 'नेपाली', // Nepali
  'nl': 'Nederlands', // Dutch
  'nl_BE': 'Nederlands (België)', // Dutch (Belgium)
  'nn': 'Norsk nynorsk', // Norwegian Nynorsk

  // P
  'pl': 'Polski', // Polish
  'ps': 'پښتو', // Pashto
  'pt': 'Português', // Portuguese (Brazil)
  'pt_PT': 'Português (Portugal)',

  // R
  'ro': 'Română', // Romanian
  'ru': 'Русский', // Russian
  'ru_KZ': 'Русский (Казахстан)', // Russian (Kazakhstan)
  'ru_UA': 'Русский (Украина)', // Russian (Ukraine)

  // S
  'si': 'සිංහල', // Sinhala
  'sk': 'Slovenčina', // Slovak
  'sl': 'Slovenščina', // Slovenian
  'sn': 'ChiShona', // Shona
  'sr': 'Српски', // Serbian
  'sv': 'Svenska', // Swedish
  'sw': 'Kiswahili', // Swahili

  // T
  'ta': 'தமிழ்', // Tamil
  'te': 'తెలుగు', // Telugu
  'th': 'ไทย', // Thai
  'tl': 'Tagalog', // Tagalog/Filipino
  'tr': 'Türkçe', // Turkish

  // U
  'uk': 'Українська', // Ukrainian
  'ur': 'اردو', // Urdu
  'ur_IN': 'اردو (بھارت)', // Urdu (India)
  'uz': 'Ozbek', // Uzbek

  // V
  'vi': 'Tiếng Việt', // Vietnamese

  // Z
  'zh': '中文', // Chinese
  'zh_CN': '简体中文 (中国)', // Chinese Simplified (China)
  'zh_HK': '繁體中文 (香港)', // Chinese Traditional (Hong Kong)
  'zh_MO': '繁體中文 (澳門)', // Chinese Traditional (Macau)
  'zh_SG': '简体中文 (新加坡)', // Chinese Simplified (Singapore)
};

Map<String, String> localeEngNames = {
  'af': 'Afrikaans',
  'am': 'Amharic',
  'ar': 'Arabic',
  'ar_AE': 'Arabic (United Arab Emirates)',
  'ar_DZ': 'Arabic (Algeria)',
  'ar_EG': 'Arabic (Egypt)',
  'az': 'Azerbaijani',
  'bg': 'Bulgarian',
  'bn': 'Bengali',
  'bn_IN': 'Bengali (India)',
  'ca': 'Catalan',
  'cs': 'Czech',
  'da': 'Danish',
  'de': 'German',
  'de_AT': 'German (Austria)',
  'de_CH': 'German (Switzerland)',
  'el': 'Greek',
  'en': 'English',
  'en_AU': 'English (Australia)',
  'en_CA': 'English (Canada)',
  'en_GB': 'English (United Kingdom)',
  'en_IN': 'English (India)',
  'es': 'Spanish',
  'es_AR': 'Spanish (Argentina)',
  'es_CO': 'Spanish (Colombia)',
  'es_MX': 'Spanish (Mexico)',
  'et': 'Estonian',
  'fa': 'Persian',
  'fi': 'Finnish',
  'fr': 'French',
  'fr_BE': 'French (Belgium)',
  'fr_CA': 'French (Canada)',
  'fr_CH': 'French (Switzerland)',
  'gl': 'Galician',
  'gu': 'Gujarati',
  'ha': 'Hausa',
  'he': 'Hebrew',
  'hi': 'Hindi',
  'hr': 'Croatian',
  'hu': 'Hungarian',
  'id': 'Indonesian',
  'it': 'Italian',
  'ja': 'Japanese',
  'kk': 'Kazakh',
  'ko': 'Korean',
  'ku': 'Kurdish',
  'ln': 'Lingala',
  'lt': 'Lithuanian',
  'lv': 'Latvian',
  'ml': 'Malayalam',
  'mn': 'Mongolian',
  'mr': 'Marathi',
  'ms': 'Malay',
  'ms_SG': 'Malay (Singapore)',
  'my': 'Burmese',
  'nb': 'Norwegian Bokmål',
  'ne': 'Nepali',
  'nl': 'Dutch',
  'nl_BE': 'Dutch (Belgium)',
  'nn': 'Norwegian Nynorsk',
  'pl': 'Polish',
  'ps': 'Pashto',
  'pt': 'Portuguese',
  'pt_PT': 'Portuguese (Portugal)',
  'ro': 'Romanian',
  'ru': 'Russian',
  'ru_KZ': 'Russian (Kazakhstan)',
  'ru_UA': 'Russian (Ukraine)',
  'si': 'Sinhala',
  'sk': 'Slovak',
  'sl': 'Slovenian',
  'sn': 'Shona',
  'sr': 'Serbian',
  'sv': 'Swedish',
  'sw': 'Swahili',
  'ta': 'Tamil',
  'te': 'Telugu',
  'th': 'Thai',
  'tl': 'Tagalog',
  'tr': 'Turkish',
  'uk': 'Ukrainian',
  'ur': 'Urdu',
  'ur_IN': 'Urdu (India)',
  'uz': 'Uzbek',
  'vi': 'Vietnamese',
  'zh': 'Chinese',
  'zh_CN': 'Chinese (Simplified)',
  'zh_HK': 'Chinese (Hong Kong)',
  'zh_MO': 'Chinese (Macau)',
  'zh_SG': 'Chinese (Singapore)',
};
