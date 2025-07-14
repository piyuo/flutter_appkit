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

import 'package:flutter/foundation.dart'; // Import for kReleaseMode
import 'package:flutter/material.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:talker_flutter/talker_flutter.dart';

import 'app.dart'; // Import to access isSentryEnabled

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

/// Custom log formatter for Talker that outputs clean, borderless log lines.
///
/// Format: [level] | HH:mm:ss SSSms | message
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

/// Opens the Talker console screen as a modal route for in-app log viewing.
///
/// [context] - The BuildContext to use for navigation.
void logShowConsole(BuildContext context) {
  Navigator.of(context).push(MaterialPageRoute(
    builder: (context) => TalkerScreen(talker: talker, appBarTitle: 'Console'),
  ));
}

/// Log a debug-level message for development and troubleshooting.
///
/// [message] - The message to log at debug level.
void logDebug(String message) {
  if (!kReleaseMode) {
    talker.debug(message);
  }
}

/// Log an info-level message for general application flow and status updates.
///
/// [message] - The message to log at info level.
void logInfo(String message) {
  talker.info(message);
}

/// Log a warning-level message for potential issues that do not stop execution.
///
/// [message] - The warning message to log.
void logWarning(String message) {
  talker.warning(message);
}

/// Log a critical-level message for serious issues, and send to Sentry if enabled.
///
/// [message] - The critical message to log and report.
///
/// If Sentry is enabled, this will also send the message as a fatal event.
void logCritical(String message) {
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

/// Log an error or exception, optionally with a stack trace, and send to Sentry if enabled.
///
/// [exception] - The error or exception object to log.
/// [stackTrace] - Optional stack trace for context.
///
/// If Sentry is enabled, this will also report the exception and stack trace.
void logError(dynamic exception, [StackTrace? stackTrace]) {
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
