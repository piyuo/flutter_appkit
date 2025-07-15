// =============================================================
// Test Suite: preferences_test.dart
// Description: Unit tests for Shared Preferences utility functions
//
// Test Groups:
//   - Setup and Teardown
//   - Key Existence and Removal
//   - Primitive Types (bool, int, double, string)
//   - Expiration Logic
//   - DateTime
//   - List and Map
// =============================================================

import 'package:flutter_appkit/src/preferences.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';

void main() {
  // Initializes mock preferences for each test run.
  // ignore: invalid_use_of_visible_for_testing_member
  initForTest({});
  setUp(() async {});

  group('[preferences] Key Existence and Removal', () {
    test('clear() removes all keys', () async {
      await prefSetBool('k', true);
      expect(await prefContainsKey('k'), true);
      await prefClear();
      expect(await prefContainsKey('k'), false);
    });

    test('containsKey() reflects key presence', () async {
      expect(await prefContainsKey('k'), false);
      await prefSetBool('k', true);
      expect(await prefContainsKey('k'), true);
      await prefRemoveKey('k');
      expect(await prefContainsKey('k'), false);
    });

    test('remove() deletes a key', () async {
      await prefSetBool('k', true);
      expect(await prefGetBool('k'), true);
      await prefRemoveKey('k');
      expect(await prefGetBool('k'), null);
    });
  });

  group('[preferences] Primitive Types', () {
    test('get/set bool', () async {
      await prefSetBool('k', true);
      expect(await prefGetBool('k'), true);
      await prefSetBool('k', false);
      expect(await prefGetBool('k'), false);
      await prefRemoveKey('k');
      expect(await prefGetBool('k'), null);
      await prefSetBool('k', false);
      await prefSetBool('k', null);
      expect(await prefGetBool('k'), null);
    });

    test('get/set int', () async {
      await prefSetInt('k', 1);
      expect(await prefGetInt('k'), 1);
      await prefRemoveKey('k');
      expect(await prefGetInt('k'), null);
      await prefSetInt('k', 1);
      await prefSetInt('k', null);
      expect(await prefGetInt('k'), null);
    });

    test('get/set double', () async {
      await prefSetDouble('k', 1.1);
      expect(await prefGetDouble('k'), 1.1);
      await prefRemoveKey('k');
      expect(await prefGetDouble('k'), null);
      await prefSetDouble('k', 1.1);
      await prefSetDouble('k', null);
      expect(await prefGetDouble('k'), null);
    });

    test('get/set string', () async {
      await prefSetString('k', 'a');
      expect(await prefGetString('k'), 'a');
      await prefRemoveKey('k');
      expect(await prefGetString('k'), null);
      await prefSetString('k', 'a');
      await prefSetString('k', null);
      expect(await prefGetString('k'), null);
    });
  });

  group('[preferences] Expiration Logic', () {
    test('get/set string with expiration', () async {
      var now = DateTime.now();
      var exp =
          DateTime(now.year, now.month, now.day, now.hour, now.minute, now.second).add(const Duration(seconds: 1));
      await prefSetStringWithExp('k', 'a', exp);
      expect(await prefGetDateTime('k$expirationExt'), exp);
      expect(await prefGetStringWithExp('k'), 'a');
      expect(await prefContainsKey('k'), true);
      expect(await prefContainsKey('k$expirationExt'), true);
      await Future.delayed(const Duration(seconds: 1));
      expect(await prefGetStringWithExp('k'), null);
      expect(await prefContainsKey('k'), false);
      expect(await prefContainsKey('k$expirationExt'), false);
    });
  });

  group('[preferences] DateTime', () {
    test('get/set DateTime', () async {
      var now = DateTime.now();
      var shortStr = now.toString().substring(0, 19);
      final value = DateTime(now.year, now.month, now.day, now.hour, now.minute, now.second);
      await prefSetDateTime('k', value);
      var result = await prefGetDateTime('k');
      expect(result.toString().substring(0, 19), shortStr);
      expect(result, value);
      await prefRemoveKey('k');
      expect(await prefGetDateTime('k'), null);
      await prefSetDateTime('k', value);
      await prefSetDateTime('k', null);
      expect(await prefGetDateTime('k'), null);
    });
  });

  group('[preferences] List and Map', () {
    test('get/set string list', () async {
      var list = ['a', 'b', 'c'];
      await prefSetStringList('k', list);
      var result = await prefGetStringList('k');
      expect(result![1], 'b');
      await prefRemoveKey('k');
      expect(await prefGetStringList('k'), null);
    });

    test('get/set map', () async {
      Map<String, dynamic> map = {'a': 1, 'b': 2};
      await prefSetMap('k', map);
      var result = await prefGetMap('k');
      expect(result!['b'], 2);
      await prefRemoveKey('k');
      expect(await prefGetMap('k'), null);
    });

    test('get/set map list', () async {
      Map<String, dynamic> map1 = {'a': 1, 'b': 2};
      Map<String, dynamic> map2 = {'a': 'a', 'b': 'b'};
      var list = [map1, map2];
      await prefSetMapList('k', list);
      var result = await prefGetMapList('k');
      expect(result![0]['a'], 1);
      expect(result[1]['a'], 'a');
      expect(result[0]['b'], 2);
      expect(result[1]['b'], 'b');
      await prefRemoveKey('k');
      expect(await prefGetMapList('k'), null);
    });
  });
}
