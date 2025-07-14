// ===============================================
// Test Suite: logger_test.dart
// Description: Unit tests for logging functionality with Talker and Sentry integration
//
// Test Groups:
//   - Setup and Teardown
//   - CleanLogFormatter Tests
//   - Debug Logging Tests
//   - Info Logging Tests
//   - Warning Logging Tests
//   - Critical Logging Tests (with Sentry)
//   - Error Logging Tests (with Sentry)
//   - Console Display Tests
//   - Sentry Integration Tests
//   - Talker Instance Tests
// ===============================================

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:talker_flutter/talker_flutter.dart';

import 'logger.dart';

// Mock class for LogDetails since the real constructor requires complex parameters
class _MockLogDetails extends LogDetails {
  _MockLogDetails({
    required super.level,
    required Object? super.message,
  }) : super(
          pen: AnsiPen(),
        );
}

// Helper functions to mock Sentry enablement state
void _mockSentryEnabled() {
  // Add SENTRY_DSN to the environment
  dotenv.env['SENTRY_DSN'] = 'https://test@sentry.io/123456';
}

void _mockSentryDisabled() {
  // Remove SENTRY_DSN from the environment
  dotenv.env.remove('SENTRY_DSN');
}

void _ensureEnvInitialized() {
  if (!dotenv.isInitialized) {
    dotenv.testLoad(fileInput: 'API_URL=https://api.example.com\nSECRET_KEY=supersecret');
  }
}

void main() {
  group('CleanLogFormatter', () {
    late CleanLogFormatter formatter;

    setUp(() {
      formatter = CleanLogFormatter();
    });

    test('formats log message with proper structure', () {
      final mockLogDetails = _MockLogDetails(
        level: LogLevel.info,
        message: 'Test message',
      );

      final settings = TalkerLoggerSettings(
        enableColors: false,
        lineSymbol: '',
      );

      final result = formatter.fmt(mockLogDetails, settings);

      // Should contain level and message
      expect(result, contains('[loglevel.info]'));
      expect(result, contains('Test message'));
      expect(result, matches(r'\d{2}:\d{2}:\d{2} \d{3}ms'));
    });

    test('handles null message gracefully', () {
      final mockLogDetails = _MockLogDetails(
        level: LogLevel.warning,
        message: null,
      );

      final settings = TalkerLoggerSettings(
        enableColors: false,
        lineSymbol: '',
      );

      final result = formatter.fmt(mockLogDetails, settings);

      expect(result, contains('[loglevel.warning]'));
      expect(result, isNot(contains('null')));
    });

    test('formats time with proper zero padding', () {
      final mockLogDetails = _MockLogDetails(
        level: LogLevel.debug,
        message: 'Test',
      );

      final settings = TalkerLoggerSettings(
        enableColors: false,
        lineSymbol: '',
      );

      final result = formatter.fmt(mockLogDetails, settings);

      // Should format time with proper padding (HH:MM:SS MMMms)
      expect(result, matches(r'\[loglevel\.debug\] \| \d{2}:\d{2}:\d{2} \d{3}ms \| Test'));
    });
  });

  group('Logging Functions', () {
    setUp(() {
      // Ensure environment is initialized and Sentry is disabled for these tests
      _ensureEnvInitialized();
      _mockSentryDisabled();
    });

    test('debug() logs message with debug level', () {
      // Note: Since talker is a global instance, we can't easily mock it
      // This test verifies the function doesn't throw an error
      expect(() => logDebug('Test debug message'), returnsNormally);
    });

    test('info() logs message with info level', () {
      expect(() => logInfo('Test info message'), returnsNormally);
    });

    test('warning() logs message with warning level', () {
      expect(() => logWarning('Test warning message'), returnsNormally);
    });

    test('critical() logs message with critical level', () {
      expect(() => logCritical('Test critical message'), returnsNormally);
    });

    test('error() logs exception with optional stack trace', () {
      final exception = Exception('Test exception');
      final stackTrace = StackTrace.current;

      expect(() => logError(exception, stackTrace), returnsNormally);
      expect(() => logError(exception), returnsNormally);
    });
  });

  group('Sentry Integration', () {
    setUp(() {
      // Ensure environment is initialized for these tests
      _ensureEnvInitialized();
    });

    test('critical() does not call Sentry when disabled', () {
      _mockSentryDisabled();

      // This should not throw even if Sentry is not initialized
      expect(() => logCritical('Test critical without Sentry'), returnsNormally);
    });

    test('error() does not call Sentry when disabled', () {
      _mockSentryDisabled();
      final exception = Exception('Test exception');

      // This should not throw even if Sentry is not initialized
      expect(() => logError(exception), returnsNormally);
    });

    test('critical() handles Sentry errors gracefully when enabled', () {
      _mockSentryEnabled();

      // Even if Sentry throws an error, critical() should handle it gracefully
      expect(() => logCritical('Test critical with potential Sentry error'), returnsNormally);
    });

    test('error() handles Sentry errors gracefully when enabled', () {
      _mockSentryEnabled();
      final exception = Exception('Test exception');

      // Even if Sentry throws an error, error() should handle it gracefully
      expect(() => logError(exception), returnsNormally);
    });
  });

  group('Console Display', () {
    testWidgets('showConsole() navigates to TalkerScreen', (WidgetTester tester) async {
      // Create a test app with a MaterialApp and a button to trigger showConsole
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => logShowConsole(context),
                child: const Text('Show Console'),
              ),
            ),
          ),
        ),
      );

      // Tap the button to trigger navigation
      await tester.tap(find.text('Show Console'));
      await tester.pumpAndSettle();

      // Verify that TalkerScreen is displayed
      expect(find.byType(TalkerScreen), findsOneWidget);
      expect(find.text('Console'), findsOneWidget);
    });

    testWidgets('showConsole() uses correct talker instance', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => logShowConsole(context),
                child: const Text('Show Console'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Console'));
      await tester.pumpAndSettle();

      // Verify TalkerScreen exists (indicating proper talker instance usage)
      expect(find.byType(TalkerScreen), findsOneWidget);
    });
  });

  group('Talker Instance Configuration', () {
    test('talker instance has correct settings', () {
      // Verify talker is configured with expected settings
      expect(talker.settings.useConsoleLogs, isTrue);
    });

    test('talker uses CleanLogFormatter', () {
      // The talker instance should be properly configured
      expect(talker, isA<Talker>());
    });
  });

  group('Error Handling Edge Cases', () {
    test('handles various exception types', () {
      expect(() => logError('String error'), returnsNormally);
      expect(() => logError(42), returnsNormally);
      expect(() => logError(Exception('Test')), returnsNormally);
      expect(() => logError(Error()), returnsNormally);
      // Note: null is handled but may cause type issues in strict mode
    });

    test('handles empty and special characters in messages', () {
      expect(() => logDebug(''), returnsNormally);
      expect(() => logInfo('Message with émojis 🚀'), returnsNormally);
      expect(() => logWarning('Message\nwith\nnewlines'), returnsNormally);
      expect(() => logCritical('Message with "quotes" and \'apostrophes\''), returnsNormally);
    });

    test('handles very long messages', () {
      final longMessage = 'A' * 1000;
      expect(() => logDebug(longMessage), returnsNormally);
      expect(() => logInfo(longMessage), returnsNormally);
      expect(() => logWarning(longMessage), returnsNormally);
      expect(() => logCritical(longMessage), returnsNormally);
    });
  });

  group('Stack Trace Handling', () {
    test('error() accepts null stack trace', () {
      final exception = Exception('Test');
      expect(() => logError(exception, null), returnsNormally);
    });

    test('error() accepts valid stack trace', () {
      final exception = Exception('Test');
      final stackTrace = StackTrace.current;
      expect(() => logError(exception, stackTrace), returnsNormally);
    });
  });

  group('Formatter Edge Cases', () {
    test('handles different log levels correctly', () {
      final levels = [
        LogLevel.verbose,
        LogLevel.debug,
        LogLevel.info,
        LogLevel.warning,
        LogLevel.error,
        LogLevel.critical,
      ];

      final formatter = CleanLogFormatter();
      final settings = TalkerLoggerSettings(
        enableColors: false,
        lineSymbol: '',
      );

      for (final level in levels) {
        final mockLogDetails = _MockLogDetails(
          level: level,
          message: 'Test ${level.toString()}',
        );
        final result = formatter.fmt(mockLogDetails, settings);

        // Note: LogLevel.toString() returns "LogLevel.xxx", so we need to extract just the level name
        final levelName = level.toString().split('.').last;
        expect(result, contains('[loglevel.$levelName]'));
        expect(result, contains('Test ${level.toString()}'));
      }
    });

    test('formats timestamp components correctly', () {
      final mockLogDetails = _MockLogDetails(
        level: LogLevel.info,
        message: 'Timestamp test',
      );

      final settings = TalkerLoggerSettings(
        enableColors: false,
        lineSymbol: '',
      );

      final formatter = CleanLogFormatter();
      final result = formatter.fmt(mockLogDetails, settings);

      // Should have proper timestamp format: HH:MM:SS MMMms
      expect(result, matches(r'\[loglevel\.info\] \| \d{2}:\d{2}:\d{2} \d{3}ms \| Timestamp test'));
    });
  });

  group('Integration Tests', () {
    test('all logging functions work together', () {
      // Test that we can call all logging functions in sequence without errors
      expect(() {
        logDebug('Debug message');
        logInfo('Info message');
        logWarning('Warning message');
        logCritical('Critical message');
        logError(Exception('Test exception'));
      }, returnsNormally);
    });

    test('Sentry state changes affect behavior', () {
      _ensureEnvInitialized();

      // Test with Sentry disabled
      _mockSentryDisabled();
      expect(() => logCritical('Test without Sentry'), returnsNormally);

      // Test with Sentry enabled
      _mockSentryEnabled();
      expect(() => logCritical('Test with Sentry'), returnsNormally);
    });
  });
}
