import 'package:libcli/src/log/log.dart';

///ErrorReport save error detail let user write emamil to us
///
class ErrorReport {
  String analyticID;

  dynamic exception;

  String stackTrace;

  ErrorReport(this.analyticID, this.exception, StackTrace stack) {
    stackTrace = beautyStack(stack);
  }
}
