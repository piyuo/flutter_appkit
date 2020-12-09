import 'package:libcli/src/log/log.dart';

///ErrorReport save error detail let user write emamil to us
///
class ErrorReport {
  final String analyticID;

  final dynamic exception;

  final String stackTrace;

  ErrorReport({
    required this.analyticID,
    required this.exception,
    required this.stackTrace,
  });
}
