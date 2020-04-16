/// EContactUs happen when there is [unknow error] and we can't log it. the only way to solve this is contact us
///
class EContactUs {
  var e;
  var s;
  EContactUs(this.e, this.s);
}

/// EError happen when there is [a  error and we already logged]. prompt user with error id to let them track issue
///
class EError {
  String errId;
  EError(this.errId);
}
