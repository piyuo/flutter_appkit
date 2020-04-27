import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/i18n.dart' as i18n;
import 'package:flutter/material.dart';

void main() {
  i18n.mockI18n(Locale('en', 'US'), '{"a": "A"}');

  setUp(() async {});

  group('[i18n_state]', () {
    test('should getTranslationFromLib', () async {
      var translation = await i18n.getTranslationFromLib('en', 'US');
      expect(translation, isNotNull);
      expect(translation['a'], 'A');
    });

    test('should getTranslationFromAsset', () async {
      var translation = await i18n.getTranslationFromAsset('any', 'en', 'US');
      expect(translation, isNotNull);
      expect(translation.translate('a'), 'A');
      expect(i18n.global('a'), 'A');
    });

    test('should getTranslation', () async {
      var translation = await i18n.getTranslation('any');
      expect(translation, isNotNull);
      expect(translation.translate('a'), 'A');
    });
  });
}
