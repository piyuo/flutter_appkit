// ===============================================
// Module: run.dart
// Description: Core initialization function for LibCLI with comprehensive error handling
//
// Sections:
//   - Global State Variables
//   - Main run() Function
//   - Error Handler Setup
//   - Error Catching and Processing
//
// Features:
//   - Sentry integration (optional)
//   - Riverpod state management setup
//   - Multi-layer error handling
//   - Talker logging integration
//   - Error dialog management
// ===============================================

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:talker_riverpod_logger/talker_riverpod_logger_observer.dart';

import 'env.dart';
import 'global_context.dart';
import 'logger.dart';
import 'show_error.dart';

/// A flag to indicate if an error dialog is currently being shown
var _isErrorShowing = false;

/// A flag to indicate if Sentry is enabled
bool isSentryEnabled = false;

/// Initializes and runs a Flutter app with comprehensive error handling.
///
/// The [suspect] function should return the root widget of your application.
/// Sentry crash reporting is automatically enabled when SENTRY_DSN environment
/// variable is configured.
///
/// Features:
/// - Catches all unhandled exceptions
/// - Optional Sentry integration for crash reporting
/// - Prevents multiple error dialogs
/// - Logs errors using Talker
/// - Riverpod state management setup
///
/// Example:
/// ```dart
/// await run(() => MyApp());
/// ```
Future<void> run(Widget Function() suspect) async {
  runZonedGuarded<Future<void>>(
    () async {
      // Load environment variables from .env file
      await initEnv();
      String sentryDSN = getEnv('SENTRY_DSN');

      final appContent = ProviderScope(observers: [
        TalkerRiverpodObserver(talker: talker),
      ], child: GlobalContext(child: suspect()));

      isSentryEnabled = sentryDSN.isNotEmpty;

      if (isSentryEnabled) {
        await SentryFlutter.init(
          (options) {
            options.dsn = sentryDSN;
            options.sendDefaultPii = true;
            // Reduce debug noise in console
            options.debug = false;
            // Optional: Set log level to reduce warnings
            options.diagnosticLevel = SentryLevel.error;
          },
          appRunner: () => runApp(SentryWidget(child: appContent)),
        );
        _setupErrorHandlers();
        info('Sentry is enabled, unhandled exceptions will be sent to Sentry.');
        return;
      }

      // No Sentry configured, run the app with basic error handling
      _setupErrorHandlers();
      info('Sentry is not enabled, if you want to use Sentry, please provide a valid DSN in run().');
      runApp(appContent);
    },
    (Object e, StackTrace stack) => catched(e, stack),
  );
}

void _setupErrorHandlers() {
  final originalOnError = FlutterError.onError;
  FlutterError.onError = (FlutterErrorDetails details) async {
    await catched(details.exception, details.stack);
    originalOnError?.call(details);
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    catched(error, stack);
    return true;
  };
}

@visibleForTesting
Future<void> catched(dynamic e, StackTrace? stack) async {
  if (e is AssertionError) {
    // Don't handle assertion errors - they only occur in development
    return;
  }

  error(e, stack);

  if (_isErrorShowing) {
    // only one error dialog at a time
    return;
  }

  _isErrorShowing = true;
  try {
    await showError(e, stack);
  } catch (ex) {
    // ignore error in showError, just print to console, showError is unlikely to throw an error, but if it does, we don't want to crash the app
    debugPrint('Error dialog display failed: $ex');
  } finally {
    _isErrorShowing = false;
  }
}
