import 'package:flutter/material.dart';
import 'package:libcli/eventbus/eventbus.dart' as eventbus;

/// NotesRefillEvent let NotesProvider to refill the list
class NotesRefillEvent extends eventbus.Event {
  NotesRefillEvent({
    this.isRemove = false,
    this.isNew = false,
  });

  /// isRemove is true mean refill is by remove item action
  final bool isRemove;

  /// isNew is true mean refill is by new create item action
  final bool isNew;
}

/// NotesHandler is handler type
typedef NotesHandler<T> = Future<bool> Function(BuildContext context, List<T> item);
