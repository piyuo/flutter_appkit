import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/src/env.dart';

void main() {
  const testEnvFile = '.env.test';

  setUpAll(() async {
    // a test .env file already put in root directory, cause dotenv will load from assets, so we need create a test .env file first.
    //await File(testEnvFile).writeAsString(testEnvContent);
  });

  tearDownAll(() async {
    // Reset dotenv for other tests
    if (dotenv.isInitialized) {
      dotenv.env.clear();
      // There's no public API to reset isInitialized, so tests must be run in isolation
    }
  });

  group('env_support.dart', () {
    test('initEnv loads variables from file', () async {
      await initEnv(fileName: testEnvFile);
      expect(dotenv.env['API_URL'], 'https://api.example.com');
      expect(dotenv.env['SECRET_KEY'], 'supersecret');
    });

    test('getEnv returns correct value and default', () async {
      await initEnv(fileName: testEnvFile);
      expect(getEnv('API_URL'), 'https://api.example.com');
      expect(getEnv('NOT_EXIST', defaultValue: 'default'), 'default');
      expect(getEnv('NOT_EXIST'), '');
    });

    test('isEnvInitialized returns true after init', () async {
      await initEnv(fileName: testEnvFile);
      expect(isEnvInitialized(), isTrue);
    });

    test('getAllEnvVars returns all variables', () async {
      await initEnv(fileName: testEnvFile);
      final vars = getAllEnvVars();
      expect(vars['API_URL'], 'https://api.example.com');
      expect(vars['SECRET_KEY'], 'supersecret');
    });

    test('hasEnvVar returns true if key exists', () async {
      await initEnv(fileName: testEnvFile);
      expect(hasEnvVar('API_URL'), isTrue);
      expect(hasEnvVar('NOT_EXIST'), isFalse);
    });
  });
}
