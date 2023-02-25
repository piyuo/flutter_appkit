import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:libcli/log/log.dart' as log;

/// Listener is listener for event bus
class Listener {
  Listener({
    required this.eventType,
    required this.callback,
  });

  /// eventType is event type the listener listen to
  final dynamic eventType;

  /// callback called when event happen
  final Future<void> Function(dynamic event) callback;

  /// listen all event and run callback when event type is match
  Future<void> listen(dynamic event) async {
    if (eventType == dynamic || eventType == event.runtimeType) {
      await callback(event);
    }
  }
}

/// Subscription use for remove listener from _listeners
class Subscription {
  final Listener _listener;

  Subscription(this._listener);

  /// cancel remove listener from _listeners
  cancel() {
    _listeners.remove(_listener);
  }
}

/// _listeners save all listener
List<Listener> _listeners = [];

/// clearListeners  remove all listener from eventbus
clearListeners() {
  _listeners.clear();
}

@visibleForTesting
int getListenerCount() {
  return _listeners.length;
}

/// listens for events of Type [T] and its subtypes.
/// ```dart
/// Subscription sub = eventbus.listen<MockEvent>('test',(ctx,event) {
///   text = event.text;
/// });
/// sub.cancel();
/// ```
Subscription listen<T>(
  Future<void> Function(dynamic) func,
) {
  if (T != dynamic) {
    log.log('[eventbus] listen $T');
  }
  final listener = Listener(eventType: T, callback: func);
  _listeners.add(listener);
  return Subscription(listener);
}

/// broadcast a new event or contract on the event bus with the specified [event].
/// ```dart
/// eventbus.listen<MockEventA>((BuildContext ctx,event) {
///   type = event.runtimeType;
/// });
/// eventbus.broadcast(ctx,MockEventA('a1'));
/// ```
Future<void> broadcast(dynamic event) async {
  log.log('[eventbus] broadcast ${event.runtimeType}');

  for (var i = _listeners.length - 1; i >= 0; i--) {
    final listener = _listeners[i];
    try {
      await listener.listen(event);
    } catch (e, s) {
      log.error(e, s);
    }
  }
}
