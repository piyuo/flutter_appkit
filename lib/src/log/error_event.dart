/// ERROR_UNHANDLE_EXCEPTION happen when global exception handler catch an exception
///
const ERROR_UNHANDLE_EXCEPTION = 'Unhandle Exception';

/// ERROR_SERVER_INTERNAL_ERROR happen execute command get server return 500 Server internal error
///
const ERROR_SERVER_INTERNAL_ERROR = 'Internal Server Error';

/// ErrorEvent happen when there is a [unknown error happen], usually trigger by log.error or catchAndBroadcast
///
/// set errorID if error already log to server, error handler will prompt user with error id to let them track issue
///
class ErrorEvent {
  /// errorCode is error code define in errors
  ///
  final String errorCode;

  /// exception is exception has been throw
  ///
  final dynamic exception;

  /// stackTrace where exeception happen
  ///
  final StackTrace stackTrace;

  ErrorEvent({this.errorCode, this.exception, this.stackTrace});
}

/// NetworkErrorEvent happen when [SocketException] is thrown
///
class NetworkErrorEvent {}

/// NetworkSlowEvent happen when command [execute longer than usual]
///
class NetworkSlowEvent {}

/// NetworkDeadlineExceedEvent  happen when [service meet context deadline exceed], listener let user know they can try again later or contact us with errId to get solution
///
class NetworkDeadlineExceedEvent {
  final String errorID;
  NetworkDeadlineExceedEvent(this.errorID);
}

/// NetworkTimeoutEvent happen when [TimeoutException] is thrown
///
class NetworkTimeoutEvent {}

/// DiskError happen when there is a [disk error], usually trigger by preference
///
class DiskErrorException implements Exception {}

/// DiskErrorEvent happen when DiskErrorException is thrown
///
class DiskErrorEvent {}
