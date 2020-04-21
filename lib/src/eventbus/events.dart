/// ContactUsErrorEvent happen when there is a [known error] and we can't log it. the only way to solve this is contact us
///
class ContactUsErrorEvent {
  var e;
  var s;
  ContactUsErrorEvent(this.e, this.s);
}

/// UnknownErrorEvent happen when there is a [unknown error happen], usually trigger by log.error or catchAndBroadcast
///
/// set errorID if error already log to server, error handler will prompt user with error id to let them track issue
///
class UnknownErrorEvent {
  final String errorID;

  UnknownErrorEvent(this.errorID);
}
