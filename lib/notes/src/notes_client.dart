import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:libcli/pb/pb.dart' as pb;
import 'package:libcli/data/data.dart' as data;
import 'package:libcli/delta/delta.dart' as delta;
import 'package:libcli/eventbus/eventbus.dart' as eventbus;
import 'notes_view_provider.dart';

class NotesClientProvider<T extends pb.Object> with ChangeNotifier {
  NotesClientProvider({
    required pb.Builder<T> dataBuilder,
    required data.DataClientGetter<T> getter,
    data.DataClientSetter<T>? setter,
    data.DataClientRemover<T>? remover,
  }) {
    dataClient = data.DataClient(
      dataBuilder: dataBuilder,
      getter: getter,
      setter: setter,
      remover: remover,
    );
  }

  /// dataView data view to display data
  late data.DataClient<T> dataClient;

  /// current data
  T? current;

  /// of get [NotesClientProvider] from context
  static NotesClientProvider<T> of<T extends pb.Object>(BuildContext context) {
    return Provider.of<NotesClientProvider<T>>(context, listen: false);
  }

  /// load dataset, get data if id present
  /// ```dart
  /// await client.load(testing.Context());
  /// ```
  Future<T> load(BuildContext context, {required data.Dataset<T> dataset, required String id}) async {
    current = await dataClient.load(context, dataset: dataset, id: id);
    notifyListeners();
    return current!;
  }

  /// save data to remote and local, only update cache when setter return true
  /// ```dart
  /// provide.data = sample.Person()..name = 'john';
  /// await client.save(context);
  /// ```
  Future<bool> save(BuildContext context, {T? item}) async {
    item ??= current;
    if (item == null) {
      return false;
    }
    final result = await dataClient.save(context, item);
    await eventbus.broadcast(context, NotesViewRefillEvent());
    return result;
  }

  /// delete data from remote service and local
  /// ```dart
  /// await client.delete(context);
  /// ```
  Future<bool> delete(BuildContext context, {T? item}) async {
    item ??= current;
    if (item == null) {
      return false;
    }
    final result = await dataClient.delete(context, item);
    eventbus.broadcast(context, NotesViewRefillEvent());
    return result;
  }
}

class NotesClient<T extends pb.Object> extends StatelessWidget {
  const NotesClient({
    required this.builder,
    this.shimmerBuilder,
    Key? key,
  }) : super(key: key);

  /// builder build client item
  final Widget Function(BuildContext, T) builder;

  /// shimmerBuilder build shimmer item
  final Widget Function(BuildContext)? shimmerBuilder;

  @override
  Widget build(BuildContext context) {
    return Consumer<NotesClientProvider<T>>(builder: (context, controller, _) {
      if (controller.current == null) {
        if (shimmerBuilder != null) {
          return shimmerBuilder!(context);
        }
        return const delta.LoadingDisplay();
      }
      return builder(context, controller.current!);
    });
  }
}
