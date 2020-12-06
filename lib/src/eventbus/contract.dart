import 'package:libcli/log.dart';

/// Contract need listener do something and call complete() when job is done
///
class Contract {
  bool? completed;

  void complete(bool value) {
    log('contract~${this.runtimeType} completed=$value');
    completed = value;
  }
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
