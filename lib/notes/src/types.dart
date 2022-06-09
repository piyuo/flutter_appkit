import 'package:flutter/material.dart';
import 'package:libcli/eventbus/eventbus.dart' as eventbus;

/// NotesRefillEvent will let NotesProvider to refill the list
class NotesRefillEvent extends eventbus.Event {}

/// NotesHandler is handler type
typedef NotesHandler<T> = Future<bool> Function(BuildContext context, List<T> item);
