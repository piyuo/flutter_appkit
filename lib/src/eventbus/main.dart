import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:libcli/src/log/log.dart' as log;
import 'package:libcli/src/eventbus/types.dart';

/// latestEvent is used for testing purpose
///
@visibleForTesting
Event latest = Event();

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
    log.log('listen all event');
  } else {
    log.log('listen $T');
  }

  var listener = Listener(eventType: T, callback: func);
  _listeners.add(listener);
  var sub = Subscription(listener);
  return sub;
}

/// broadcast a new event or contract on the event bus with the specified [event].
///
///     eventbus.listen<MockEventA>((BuildContext ctx,event) {
///       type = event.runtimeType;
///     });
///     eventbus.broadcast(ctx,MockEventA('a1'));
///
Future<bool> broadcast(BuildContext context, Event event) async {
  latest = event;
  log.log('broadcast ${event.runtimeType}');

  for (var listener in _listeners) {
    try {
      await listener.listen(context, event);
    } catch (e, s) {
      log.error(e, s);
    }
    if (event is Contract && event.isComplete) {
      break;
    }
  }

  if (event is Contract) {
    if (event.isComplete == false) {
      log.log('${log.COLOR_ALERT}caught no listener for ${event.runtimeType}');
      event.complete(false);
    }
    return event.OK;
  }
  return false;
}
