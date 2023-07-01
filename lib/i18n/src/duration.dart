import 'package:duration/duration.dart';
import 'package:duration/locale.dart';
import 'i18n.dart';

/// DurationHelpers define duration helpers
extension DurationHelpers on Duration {
  /// formattedPretty convert duration to pretty local string
  /// ```dart
  /// expect(dur.formatted, '5 days 23 hours 59 minutes 59 seconds');
  /// ```
  String get formattedPretty {
    final l = locale;
    DurationLocale? dl;
    if (localeKey == 'zh_TW') {
      dl = chineseTraditionalLocale;
    } else {
      dl = DurationLocale.fromLanguageCode(l.languageCode);
      dl ??= englishLocale;
    }
    return prettyDuration(this, locale: dl);
  }
}
