import 'package:libcli/log.dart' as log;

/// Event
///
class Event {}

/// Contract need listener do something and call complete() when job is done
///
class Contract extends Event {
  bool _completed = false;
  bool _result = false;

  get isComplete => _completed;

  get OK => _result;

  void complete(bool value) {
    log.log('${this.runtimeType} result=$value');
    _result = value;
    _completed = true;
  }
}

///EmailSupportEvent happen when user click 'Email Us' link
///
class EmailSupportEvent extends Event {
  EmailSupportEvent();
}

/*
import 'dart:async';
  Completer<bool> _completer = new Completer<bool>();

  bool get isCompleted => _completer.isCompleted;

  void complete(bool ok) {
    var text = ok ? 'ok' : 'fail';
    log('contract~${this.runtimeType} $text ');
    _completer.complete(ok);
  }

  Future<bool> get future {
    return _completer.future;
  }

*/
