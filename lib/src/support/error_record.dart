import 'package:libcli/log.dart' as log;

class ErrorRecord {
  String id;

  dynamic exception;

  String stackTrace;

  ErrorRecord(this.id, this.exception, StackTrace stack) {
    stackTrace = log.beautyStack(stack);
  }
}
