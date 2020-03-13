import 'dart:async';
import 'package:libcli/log/log.dart';
import 'package:meta/meta.dart';

/// Contract need listener do something and need callback when job is done
///
class Contract {
  Completer<bool> _completer = new Completer<bool>();

  bool get isCompleted => _completer.isCompleted;

  void complete(bool ok) {
    var text = ok ? 'ok' : 'fail';
    'contract|${this.runtimeType} $text '.log;
    _completer.complete(ok);
  }

  Future<bool> get future {
    return _completer.future;
  }
}

/// latestContract is used for testing purpose
///
@visibleForTesting
Contract latestContract;

/// latestEvent is used for testing purpose
///
@visibleForTesting
dynamic latestEvent;
