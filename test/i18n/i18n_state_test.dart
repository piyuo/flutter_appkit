import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/i18n.dart';
import 'package:flutter/material.dart';

void main() {
  mockI18n(Locale('en', 'US'), '{"a": "A"}');

  setUp(() async {});

  group('[i18n_state]', () {
    test('should getTranslationFromLib', () async {
      var translation = await getTranslationFromLib('en', 'US');
      expect(translation, isNotNull);
      expect(translation['a'], 'A');
    });

    test('should getTranslationFromAsset', () async {
      var translation = await getTranslationFromAsset('any', 'en', 'US');
      expect(translation, isNotNull);
      expect(translation.translate('a'), 'A');
    });

    test('should getTranslation', () async {
      var translation = await getTranslation('any');
      expect(translation, isNotNull);
      expect(translation.translate('a'), 'A');
    });
  });
}
