import 'dart:async';
import 'package:flutter/material.dart';
import 'package:libcli/log.dart';
import 'package:libcli/src/eventbus/contract.dart';

const _here = 'eventbus';

typedef Callback(BuildContext context, dynamic event);

/// latestContract is used for testing purpose
///
@visibleForTesting
Contract latestContract;

/// latestEvent is used for testing purpose
///
@visibleForTesting
dynamic latestEvent;

/// Listener
class Listener {
  final dynamic _type;

  final Callback _func;

  Listener(this._type, this._func);

  /// call send event to listener
  ///
  call(BuildContext context, dynamic event) {
    if (_type == dynamic || _type == event.runtimeType) {
      _func(context, event);
    }
  }
}

/// Subscription use for remove listener from _listeners
///
class Subscription {
  Listener _listener;

  Subscription(this._listener);

  /// cancel remove listener from _listeners
  ///
  cancel() {
    _listeners.remove(_listener);
  }
}

/// _listeners save all listener
///
List<Listener> _listeners = List<Listener>();

/// reset  remove all listener from eventbus
///
reset() {
  _listeners.clear();
}

@visibleForTesting
int getListenerCount() {
  return _listeners.length;
}

/// Listens for events of Type [T] and its subtypes.
///
///     Subscription sub = eventbus.listen<MockEvent>('test',(ctx,event) {
///       text = event.text;
///     });
///     sub.cancel();
Subscription listen<T>(
  String where,
  Function(BuildContext, dynamic) func,
) {
  assert(func != null);
  if (T == dynamic) {
    debugPrint('$_here~$where listen all event');
  } else {
    debugPrint('$_here~$where listen $T');
  }

  var listener = Listener(T, func);
  _listeners.add(listener);
  var sub = Subscription(listener);
  return sub;
}

/// brodcast a new event on the event bus with the specified [event].
///
///     eventbus.listen<MockEventA>((BuildContext ctx,event) {
///       type = event.runtimeType;
///     });
///     eventbus.brodcast(ctx,MockEventA('a1'));
///
broadcast(BuildContext context, dynamic event) {
  assert(event != null);
  latestEvent = event;
  log('$_here~brodcast ${event.runtimeType}');
  dispatch(context, event);
}

/// contract open by caller, need call back when job done
///
///     eventbus.listen<MockContract>((BuildContext ctx,event) {
///       event.complete(true);
///     });
///     eventBus.contract(ctx,MockContract('c1')).then((value) {
///       ok = value;
///     });
///
Future<bool> contract(BuildContext context, Contract event) {
  assert(event != null);
  latestContract = event;
  log('$_here~contract ${event.runtimeType}');
  dispatch(context, event);
  return event.future;
}

/// dispatch event to [listener]
///
///     dispatch(ctx,'hello');
///
@visibleForTesting
dispatch(BuildContext context, dynamic event) {
  for (var listener in _listeners) {
    try {
      listener.call(context, event);
    } catch (e, s) {
      error(_here, e, s);
      if (event is Contract) {
        event.complete(false);
      }
    }
  }
}
