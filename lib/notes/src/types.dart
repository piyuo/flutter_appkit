import 'package:flutter/material.dart';
import 'package:libcli/eventbus/eventbus.dart' as eventbus;

/// NotesViewRefillEvent will let NotesViewProvider to refill the list
class NotesViewRefillEvent extends eventbus.Event {}

/// NotesHandler is handler type
typedef NotesHandler<T> = Future<bool> Function(BuildContext context, List<T> item);
