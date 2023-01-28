import 'package:flutter/material.dart';

/// NotesRefillEvent let NotesProvider to refill the list
class NotesRefillEvent {
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
