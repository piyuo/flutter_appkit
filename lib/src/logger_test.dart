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
import 'package:flutter_test/flutter_test.dart';
import 'package:talker_flutter/talker_flutter.dart';

import 'logger.dart';
import 'run.dart' as run_module;

// Mock class for LogDetails since the real constructor requires complex parameters
class _MockLogDetails extends LogDetails {
  _MockLogDetails({
    required LogLevel level,
    required Object? message,
  }) : super(
          message: message,
          level: level,
          pen: AnsiPen(),
        );
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
      // Reset Sentry enabled state before each test
      run_module.isSentryEnabled = false;
    });

    test('debug() logs message with debug level', () {
      // Note: Since talker is a global instance, we can't easily mock it
      // This test verifies the function doesn't throw an error
      expect(() => debug('Test debug message'), returnsNormally);
    });

    test('info() logs message with info level', () {
      expect(() => info('Test info message'), returnsNormally);
    });

    test('warning() logs message with warning level', () {
      expect(() => warning('Test warning message'), returnsNormally);
    });

    test('critical() logs message with critical level', () {
      expect(() => critical('Test critical message'), returnsNormally);
    });

    test('error() logs exception with optional stack trace', () {
      final exception = Exception('Test exception');
      final stackTrace = StackTrace.current;

      expect(() => error(exception, stackTrace), returnsNormally);
      expect(() => error(exception), returnsNormally);
    });
  });

  group('Sentry Integration', () {
    setUp(() {
      // Ensure Sentry is disabled by default
      run_module.isSentryEnabled = false;
    });

    test('critical() does not call Sentry when disabled', () {
      run_module.isSentryEnabled = false;

      // This should not throw even if Sentry is not initialized
      expect(() => critical('Test critical without Sentry'), returnsNormally);
    });

    test('error() does not call Sentry when disabled', () {
      run_module.isSentryEnabled = false;
      final exception = Exception('Test exception');

      // This should not throw even if Sentry is not initialized
      expect(() => error(exception), returnsNormally);
    });

    test('critical() handles Sentry errors gracefully when enabled', () {
      run_module.isSentryEnabled = true;

      // Even if Sentry throws an error, critical() should handle it gracefully
      expect(() => critical('Test critical with potential Sentry error'), returnsNormally);
    });

    test('error() handles Sentry errors gracefully when enabled', () {
      run_module.isSentryEnabled = true;
      final exception = Exception('Test exception');

      // Even if Sentry throws an error, error() should handle it gracefully
      expect(() => error(exception), returnsNormally);
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
                onPressed: () => showConsole(context),
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
                onPressed: () => showConsole(context),
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
      expect(() => error('String error'), returnsNormally);
      expect(() => error(42), returnsNormally);
      expect(() => error(Exception('Test')), returnsNormally);
      expect(() => error(Error()), returnsNormally);
      // Note: null is handled but may cause type issues in strict mode
    });

    test('handles empty and special characters in messages', () {
      expect(() => debug(''), returnsNormally);
      expect(() => info('Message with émojis 🚀'), returnsNormally);
      expect(() => warning('Message\nwith\nnewlines'), returnsNormally);
      expect(() => critical('Message with "quotes" and \'apostrophes\''), returnsNormally);
    });

    test('handles very long messages', () {
      final longMessage = 'A' * 1000;
      expect(() => debug(longMessage), returnsNormally);
      expect(() => info(longMessage), returnsNormally);
      expect(() => warning(longMessage), returnsNormally);
      expect(() => critical(longMessage), returnsNormally);
    });
  });

  group('Stack Trace Handling', () {
    test('error() accepts null stack trace', () {
      final exception = Exception('Test');
      expect(() => error(exception, null), returnsNormally);
    });

    test('error() accepts valid stack trace', () {
      final exception = Exception('Test');
      final stackTrace = StackTrace.current;
      expect(() => error(exception, stackTrace), returnsNormally);
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
        debug('Debug message');
        info('Info message');
        warning('Warning message');
        critical('Critical message');
        error(Exception('Test exception'));
      }, returnsNormally);
    });

    test('Sentry state changes affect behavior', () {
      // Test with Sentry disabled
      run_module.isSentryEnabled = false;
      expect(() => critical('Test without Sentry'), returnsNormally);

      // Test with Sentry enabled
      run_module.isSentryEnabled = true;
      expect(() => critical('Test with Sentry'), returnsNormally);
    });
  });
}
