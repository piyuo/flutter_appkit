// ============================================================================
// Table of Contents
// ============================================================================
// 1. Imports
// 2. Environment Initialization
// 3. Environment Variable Access
// 4. Utility Functions
// ============================================================================

import 'package:flutter_dotenv/flutter_dotenv.dart';

// ============================================================================
// 2. Environment Initialization
// ============================================================================

/// Initializes the environment variables by loading from a .env file.
///
/// By default, loads from ".env" file in the project root.
/// Can be customized to load from different files.
///
/// Example:
/// ```dart
/// await initEnv(); // loads from .env
/// await initEnv(fileName: '.env.dev'); // loads from .env.dev
/// ```
///
/// Throws [FileSystemException] if the .env file cannot be found or read.
/// Returns normally if the file loads successfully or if dotenv is already initialized.
Future<void> envInit({String fileName = '.env'}) async {
  try {
    if (!dotenv.isInitialized) {
      await dotenv.load(fileName: fileName);
    }
  } catch (e) {
    // Re-throw with more context
    throw Exception('Failed to load environment file "$fileName": $e');
  }
}

// ============================================================================
// 3. Environment Variable Access
// ============================================================================

/// Retrieves an environment variable by key.
///
/// If the environment is not initialized or the key doesn't exist,
/// returns the [defaultValue] (empty string by default).
///
/// Example:
/// ```dart
/// String apiUrl = envGet('API_URL', defaultValue: 'https://localhost:3000');
/// String secret = envGet('SECRET_KEY'); // returns empty string if not found
/// ```
///
/// Parameters:
/// - [key]: The environment variable key to retrieve
/// - [defaultValue]: Value to return if key is not found (default: empty string)
///
/// Returns the environment variable value or default value.
String envGet(String key, {String defaultValue = ''}) {
  if (!dotenv.isInitialized) {
    return defaultValue;
  }
  return dotenv.env[key] ?? defaultValue;
}

// ============================================================================
// 4. Utility Functions
// ============================================================================

/// Checks if the environment is properly initialized.
///
/// Returns true if dotenv has been initialized and is ready to use.
bool envIsInitialized() {
  return dotenv.isInitialized;
}

/// Gets all environment variables as a map.
///
/// Returns an empty map if the environment is not initialized.
/// This is useful for debugging or when you need to iterate over all variables.
///
/// Example:
/// ```dart
/// Map<String, String> allVars = envGetAllVars();
/// for (var entry in allVars.entries) {
///   print('${entry.key}: ${entry.value}');
/// }
/// ```
Map<String, String> envGetAllVars() {
  if (!dotenv.isInitialized) {
    return {};
  }
  return Map<String, String>.from(dotenv.env);
}

/// Checks if a specific environment variable exists.
///
/// Returns true if the key exists in the loaded environment variables,
/// false otherwise (including when environment is not initialized).
///
/// Example:
/// ```dart
/// if (envHasVar('API_KEY')) {
///   String apiKey = envGet('API_KEY');
///   // use api key
/// }
/// ```
bool envHasVar(String key) {
  if (!dotenv.isInitialized) {
    return false;
  }
  return dotenv.env.containsKey(key);
}
