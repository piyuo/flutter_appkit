import 'package:universal_io/io.dart';

/// isTestMode return true if is in test mode
bool get isTestMode => Platform.environment.containsKey('FLUTTER_TEST');
