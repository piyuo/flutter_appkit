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

// Cache the DSN validation result
bool? _sentryEnabledCache;

bool get isSentryEnabled {
  // In test mode, don't use cache to allow for environment changes
  if (kDebugMode) {
    final dsn = getEnv('SENTRY_DSN');
    return dsn.isNotEmpty && _isValidSentryDSN(dsn);
  }

  if (_sentryEnabledCache != null) return _sentryEnabledCache!;

  final dsn = getEnv('SENTRY_DSN');
  _sentryEnabledCache = dsn.isNotEmpty && _isValidSentryDSN(dsn);
  return _sentryEnabledCache!;
}

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
      final appContent = ProviderScope(observers: [
        TalkerRiverpodObserver(talker: talker),
      ], child: GlobalContext(child: suspect()));

      _setupErrorHandlers();

      if (isSentryEnabled) {
        await _initWithSentry(appContent);
      } else {
        _initWithoutSentry(appContent);
      }
    },
    (Object e, StackTrace stack) => catched(e, stack),
  );
}

/// Initializes the app with Sentry integration
Future<void> _initWithSentry(Widget appContent) async {
  final sentryDSN = getEnv('SENTRY_DSN');

  try {
    await SentryFlutter.init(
      (options) {
        options.dsn = sentryDSN;
        options.sendDefaultPii = true;
        // Reduce debug noise in console
        options.debug = false;
        // Optional: Set log level to reduce warnings
        options.diagnosticLevel = SentryLevel.error;
        // Add environment detection
        options.environment = kDebugMode ? 'development' : 'production';
      },
      appRunner: () => runApp(SentryWidget(child: appContent)),
    );
    info('Sentry is enabled, unhandled exceptions will be sent to Sentry.');
  } catch (e) {
    warning('Failed to initialize Sentry: $e. Falling back to basic error handling.');
    _initWithoutSentry(appContent);
  }
}

/// Initializes the app without Sentry
void _initWithoutSentry(Widget appContent) {
  info('Sentry is not enabled. To use Sentry, provide a valid DSN in the SENTRY_DSN environment variable.');
  runApp(appContent);
}

/// Validates if the provided DSN is a valid Sentry DSN format
bool _isValidSentryDSN(String dsn) {
  if (dsn.isEmpty) return false;

  try {
    final uri = Uri.parse(dsn);
    // Enhanced validation for Sentry DSN format
    // Sentry DSNs typically follow: https://public_key@organization.ingest.sentry.io/project_id
    return uri.hasScheme &&
        uri.hasAuthority &&
        uri.pathSegments.isNotEmpty &&
        (uri.scheme == 'http' || uri.scheme == 'https') &&
        uri.host.contains('sentry.io'); // More specific Sentry validation
  } catch (e) {
    return false;
  }
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
  // Ignore assertion errors in development mode
  if (e is AssertionError) {
    return;
  }

  // Handle null exceptions gracefully
  if (e == null) {
    error('Null exception caught', stack);
    return;
  }

  error(e, stack);

  try {
    await showError(e, stack);
  } catch (ex) {
    // Log the error and also print to console for debugging
    error('Error dialog display failed: $ex');
    debugPrint('Error dialog display failed: $ex');
  }
}
