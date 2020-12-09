import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:libcli/log.dart';
import 'package:libcli/src/eventbus/contract.dart';

/// latestContract is used for testing purpose
///
@visibleForTesting
Contract? latestContract;

/// latestEvent is used for testing purpose
///
@visibleForTesting
dynamic latestEvent;

/// Listener
class Listener {
  /// eventType is event type the listener listen to
  ///
  final dynamic eventType;

  /// callback called when event happen
  ///
  final Future<void> Function(BuildContext context, dynamic event) callback;

  Listener({
    required this.eventType,
    required this.callback,
  });

  /// listen all event and run callback when event type is match
  ///
  Future<void> listen(BuildContext context, dynamic event) async {
    if (eventType == dynamic || eventType == event.runtimeType) {
      await callback(context, event);
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
List<Listener> _listeners = [];

/// clearListeners  remove all listener from eventbus
///
clearListeners() {
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
  Future<void> Function(BuildContext, dynamic) func,
) {
  if (T == dynamic) {
    log('listen all event');
  } else {
    log('listen $T');
  }

  var listener = Listener(eventType: T, callback: func);
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
Future<void> broadcast(BuildContext context, dynamic event) async {
  assert(event != null);
  latestEvent = event;
  log('brodcast ${event.runtimeType}');
  await dispatch(context, event);
}

/// contract open by caller, need call back when job done. if no listener complete event it will be complete by false
///
///     eventbus.listen<MockContract>((BuildContext ctx,event) {
///       event.complete(true);
///     });
///     eventBus.contract(ctx,MockContract('c1')).then((value) {
///       ok = value;
///     });
///
Future<bool> contract(BuildContext context, Contract contract) async {
  latestContract = contract;
  log('contract ${contract.runtimeType}');
  await dispatch(context, contract);
  if (contract.completed == null) {
    log('${COLOR_ALERT}caught no listener for ${contract.runtimeType}');
    contract.completed = false;
  }
  return contract.completed!;
}

/// dispatch event to [listener]
///
///     dispatch(ctx,'hello');
///
@visibleForTesting
Future<void> dispatch(BuildContext context, dynamic event) async {
  for (var listener in _listeners) {
    try {
      await listener.listen(context, event);
    } catch (e, s) {
      error(e, s);
      if (event is Contract) {
        event.complete(false);
      }
    }

    if (event is Contract && event.completed != null) {
      return;
    }
  }
}
