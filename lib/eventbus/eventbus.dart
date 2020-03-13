import 'dart:async';
import 'package:flutter/material.dart';
import 'package:libcli/log/log.dart';
import 'package:libcli/eventbus/contract.dart';

const _here = 'eventbus';

typedef Callback(BuildContext context, dynamic event);

class Listener {
  final dynamic _type;

  final Callback _func;

  Listener(this._type, this._func);
  call(BuildContext context, dynamic event) {
    if (_type == null || _type == event.runtimeType) {
      _func(context, event);
    }
  }
}

class Subscription {
  Listener _listener;

  Subscription(this._listener);

  cancel() {
    _listeners.remove(_listener);
  }
}

List<Listener> _listeners = List<Listener>();

/// Listens for events of Type [T] and its subtypes.
///
///     Subscription sub = eventbus.listen<MockEvent>((ctx,event) {
///       text = event.text;
///     });
///     sub.cancel();
Subscription listen<T>(Function(BuildContext, dynamic) func) {
  assert(func != null);
  if (T == dynamic) {
    '$_here|someone listen ${NOUN}all event'.print;
  } else {
    '$_here|someone listen ${NOUN}$T'.print;
  }

  var listener = Listener(T, func);
  _listeners.add(listener);
  var sub = Subscription(listener);
  return sub;
/*
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
  */
}

/// brodcast a new event on the event bus with the specified [event].
///
///     eventbus.listen<MockEventA>((BuildContext ctx,event) {
///       type = event.runtimeType;
///     });
///     eventbus.brodcast(ctx,MockEventA('a1'));
///
broadcast(BuildContext ctx, dynamic event) {
  assert(event != null);
  latestEvent = event;
  '$_here|brodcast ${event.runtimeType}'.log;
  dispatch(ctx, event);
}

/// contract open by caller, need call back when job done
///
///     eventbus.listen<MockContract>((event) {
///       event.complete(true);
///     });
///     eventBus.contract(MockContract('c1')).then((value) {
///       ok = value;
///     });
///
Future<bool> contract(BuildContext ctx, Contract event) {
  assert(event != null);
  latestContract = event;
  '$_here|contract ${event.runtimeType}'.log;
  dispatch(ctx, event);
  return event.future;
}

/// dispatch event to [listener]
///
///     dispatch(ctx,'hello');
///
@visibleForTesting
dispatch(BuildContext ctx, dynamic event) {
  for (var listener in _listeners) {
    try {
      listener.call(ctx, event);
    } catch (e, s) {
      _here.error(e, s);
      if (event is Contract) {
        event.complete(false);
      }
    }
  }
}
