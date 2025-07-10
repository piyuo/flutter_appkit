// ===============================================
// Module: logger.dart
// Description: Logging utilities with Talker integration and Sentry reporting
//
// Sections:
//   - Imports and Talker Instance
//   - Console Display Function
//   - Logging Utility Functions
//     - debug(String) - Debug level logging
//     - info(String) - Info level logging
//     - warning(String) - Warning level logging
//     - critical(String) - Critical level logging with Sentry
//     - error(dynamic, StackTrace?) - Error logging with Sentry
// ===============================================

import 'package:flutter/material.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:talker_flutter/talker_flutter.dart';

import 'run.dart'; // Import to access isSentryEnabled

final talker = Talker(
  settings: TalkerSettings(
    useConsoleLogs: true,
  ),
  logger: TalkerLogger(
    settings: TalkerLoggerSettings(
      enableColors: false,
      lineSymbol: '',
    ),
    formatter: CleanLogFormatter(),
  ),
);

/// Custom formatter that removes borders and provides clean output
class CleanLogFormatter extends LoggerFormatter {
  @override
  String fmt(LogDetails details, TalkerLoggerSettings settings) {
    final time = DateTime.now();
    final level = details.level.toString().toLowerCase();
    final message = details.message?.toString() ?? '';

    final timeStr = '${time.hour.toString().padLeft(2, '0')}:'
        '${time.minute.toString().padLeft(2, '0')}:'
        '${time.second.toString().padLeft(2, '0')} '
        '${time.millisecond.toString().padLeft(3, '0')}ms';

    return '[$level] | $timeStr | $message';
  }
}

void showConsole(BuildContext context) {
  Navigator.of(context).push(MaterialPageRoute(
    builder: (context) => TalkerScreen(talker: talker, appBarTitle: 'Console'),
  ));
}

/// Logs a debug message using Talker.
/// Debug messages are typically used for development and troubleshooting.
void debug(String message) {
  talker.debug(message);
}

/// Logs an info message using Talker.
/// Info messages provide general information about application flow.
void info(String message) {
  talker.info(message);
}

/// Logs a warning message using Talker.
/// Warning messages indicate potential issues that don't prevent execution.
void warning(String message) {
  talker.warning(message);
}

/// Logs a critical message using Talker and sends to Sentry if enabled.
/// Critical messages indicate serious issues that require immediate attention.
void critical(String message) {
  talker.critical(message);

  if (isSentryEnabled) {
    try {
      Sentry.captureMessage(message, level: SentryLevel.fatal);
    } catch (ex) {
      // Ignore Sentry errors to prevent cascading failures
      debugPrint('Sentry critical message reporting failed: $ex');
    }
  }
}

/// Logs an error with optional stack trace using Talker and sends to Sentry if enabled.
/// This function handles exceptions and errors with full context.
void error(dynamic exception, [StackTrace? stackTrace]) {
  talker.handle(exception, stackTrace);

  if (isSentryEnabled) {
    try {
      Sentry.captureException(exception, stackTrace: stackTrace);
    } catch (ex) {
      // Ignore Sentry errors to prevent cascading failures
      debugPrint('Sentry error reporting failed: $ex');
    }
  }
}
