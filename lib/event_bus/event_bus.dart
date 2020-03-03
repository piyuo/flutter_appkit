import 'dart:async';
import 'package:libcli/log/log.dart' as log;

const _here = 'eventbus';

/// Contract need listener do something and need callback when job is done
///
class Contract {
  Completer<bool> _completer = new Completer<bool>();

  void complete(bool ok) {
    var text = ok ? '\u001b[32mok' : '\u001b[31mfailed';
    log.debug(_here, '${this.runtimeType} $text');
    _completer.complete(ok);
  }

  Future<bool> get future {
    return _completer.future;
  }
}

StreamController _streamController = StreamController.broadcast(sync: false);

/// Listens for events of Type [T] and its subtypes.
///
listen<T>(Function(dynamic) func) {
  log.debug(_here, ' \u001b[36mlisten to \u001b[0m$T');

  Stream stream;
  if (T == dynamic) {
    stream = _streamController.stream;
  } else {
    stream = _streamController.stream.where((event) => event is T).cast<T>();
  }
  stream.listen((event) {
    try {
      func(event);
    } catch (e, s) {
      // handle unexpect error
      log.error(_here, e, s);
      if (event is Contract) {
        event.complete(false);
      }
    }
  });
}

/// brodcast a new event on the event bus with the specified [event].
///
///     eventBus.listen<MockEventA>((event) {
///       type = event.runtimeType;
///     });
///     eventBus.brodcast(MockEventA('a1'));
///
void brodcast(event) {
  log.debug(_here, ' \u001b[33mbrodcast \u001b[0m${event.runtimeType}');
  _streamController.add(event);
}

/// caller open contract, need call back when job done
///
///     eventBus.listen<MockContract>((event) {
///       event.complete(true);
///     });
///     eventBus.contract(MockContract('c1')).then((value) {
///       ok = value;
///     });
///
Future<bool> contract(Contract event) {
  log.debug(_here, ' \u001b[35mcontract \u001b[0m${event.runtimeType}');
  _streamController.add(event);
  return event.future;
}

/// This is generally only in a testing context.
///
Future<void> doneForTest() async {
  await _streamController.close();
  _streamController = StreamController.broadcast(sync: false);
}
