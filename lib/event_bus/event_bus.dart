import 'dart:async';
import 'package:libcli/log/log.dart';

const _here = 'eventbus';

/// Contract need listener do something and need callback when job is done
///
class Contract {
  Completer<bool> _completer = new Completer<bool>();

  void complete(bool ok) {
    var text = ok ? '${NOUN}}done' : '${NOUN2}fail';
    '$_here|${this.runtimeType} $text '.log;
    _completer.complete(ok);
  }

  Future<bool> get future {
    return _completer.future;
  }
}

StreamController _streamController = StreamController.broadcast(sync: false);

/// Listens for events of Type [T] and its subtypes.
///
///     StreamSubscription sub = eventBus.listen<MockEvent>((event) {
///       text = event.text;
///     });
///     sub.cancel();
StreamSubscription<dynamic> listen<T>(Function(dynamic) func) {
  assert(func != null);
  if (T == dynamic) {
    '$_here|All listened'.print;
  } else {
    '$_here|listen $T listened'.print;
  }

  Stream stream;
  if (T == dynamic) {
    stream = _streamController.stream;
  } else {
    stream = _streamController.stream.where((event) => event is T).cast<T>();
  }
  return stream.listen((event) {
    try {
      func(event);
    } catch (e, s) {
      _here.error(e, s);
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
  assert(event != null);
  '$_here|brodcast $NOUN${event.runtimeType}'.log;
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
  assert(event != null);
  '$_here|contract $NOUN${event.runtimeType}'.log;
  _streamController.add(event);
  return event.future;
}

/// This is generally only in a testing context.
///
Future<void> doneForTest() async {
  await _streamController.close();
  _streamController = StreamController.broadcast(sync: false);
}
