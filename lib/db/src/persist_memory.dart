import 'package:flutter/material.dart';
import 'package:libcli/pb/pb.dart' as pb;
import 'package:libcli/eventbus/eventbus.dart' as eventbus;
import 'package:libcli/unique/unique.dart' as unique;
import 'memory.dart';

/// MemoryChangedEvent happen when memory changed and need to inform other memory instance to refill data
class MemoryChangedEvent extends eventbus.Event {
  MemoryChangedEvent({
    required this.id,
    required this.name,
  });

  /// name is memory name that trigger for this event
  final String name;

  /// id is memory id that trigger for this event
  final String id;
}

abstract class PersistMemory<T extends pb.Object> extends Memory<T> {
  PersistMemory({
    required this.name,
    required pb.Builder<T> dataBuilder,
    this.onChanged,
  }) : super(dataBuilder: dataBuilder) {
    _subscribed ??= eventbus.listen(listened);
  }

  /// name use for database or cache id
  final String name;

  /// _id is the unique id of this dataset, it is used to cache data
  final String _id = unique.generate(4);

  /// onChanged called when memory saved
  Future<void> Function(BuildContext context)? onChanged;

  /// _subscribed is eventbus subscription
  eventbus.Subscription? _subscribed;

  /// close memory
  @override
  @mustCallSuper
  Future<void> close() async {
    _subscribed?.cancel();
  }

  /// save memory cache
  @mustCallSuper
  Future<void> save(BuildContext context) async => await broadcastChangedEvent(context);

  /// broadcastChangedEvent broadcast MemoryChangedEvent
  Future<void> broadcastChangedEvent(BuildContext context) async => eventbus.broadcast(
      context,
      MemoryChangedEvent(
        id: _id,
        name: name,
      ));

  @visibleForTesting
  Future<void> listened(BuildContext context, dynamic e) async {
    if (e is MemoryChangedEvent) {
      if (e.name == name && e.id != _id) {
        // do not handle if event is fire from same memory
        await reload();
        if (onChanged != null) {
          await onChanged!(context);
        }
      }
    }
  }
}
