// ============================================================================
// Table of Contents
// ============================================================================
// 1. Imports
// 2. Test Setup & Teardown
// 3. Environment Variable Tests
// ============================================================================

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';

import 'env.dart';

void main() {
  const testEnvFile = '.env.test';

  setUpAll(() async {
    // A test .env file is already placed in the root directory. Since dotenv loads from assets, we ensure a test .env file exists for these tests.
    //await File(testEnvFile).writeAsString(testEnvContent);
  });

  tearDownAll(() async {
    // Reset dotenv for other tests. There is no public API to reset isInitialized, so tests must be run in isolation.
    if (dotenv.isInitialized) {
      dotenv.env.clear();
      // No public API to reset isInitialized flag.
    }
  });

  group('env.dart', () {
    test('envInit loads variables from file', () async {
      await envInit(fileName: testEnvFile);
      expect(dotenv.env['API_URL'], 'https://api.example.com');
      expect(dotenv.env['SECRET_KEY'], 'supersecret');
    });

    test('envGet returns correct value and default', () async {
      await envInit(fileName: testEnvFile);
      expect(envGet('API_URL'), 'https://api.example.com');
      expect(envGet('NOT_EXIST', defaultValue: 'default'), 'default');
      expect(envGet('NOT_EXIST'), '');
    });

    test('envIsInitialized returns true after init', () async {
      await envInit(fileName: testEnvFile);
      expect(envIsInitialized(), isTrue);
    });

    test('envGetAllVars returns all variables', () async {
      await envInit(fileName: testEnvFile);
      final vars = envGetAllVars();
      expect(vars['API_URL'], 'https://api.example.com');
      expect(vars['SECRET_KEY'], 'supersecret');
    });

    test('envHasVar returns true if key exists', () async {
      await envInit(fileName: testEnvFile);
      expect(envHasVar('API_URL'), isTrue);
      expect(envHasVar('NOT_EXIST'), isFalse);
    });
  });
}
