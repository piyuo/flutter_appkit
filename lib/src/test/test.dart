import 'package:flutter/foundation.dart';
import 'dart:io';

/// testMode return true if code in running in test
///
bool get testMode {
  if (!kReleaseMode && Platform.environment.containsKey('FLUTTER_TEST')) {
    return true;
  }
  return false;
}
