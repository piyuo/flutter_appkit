import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:libcli/pb/pb.dart' as pb;
import 'package:libcli/data/data.dart' as data;
import 'package:libcli/eventbus/eventbus.dart' as eventbus;
import 'package:libcli/dialog/dialog.dart' as dialog;
import 'types.dart';

/// NoteController is a provider for [NotesClient]
class NoteController<T extends pb.Object> with ChangeNotifier {
  NoteController({
    required this.contentBuilder,
    this.shimmerBuilder,
    required pb.Builder<T> dataBuilder,
    required data.DataClientGetter<T> getter,
    required this.removeHandler,
    required this.archiveHandler,
    required this.saveHandler,
    this.onSaved,
    this.onRemoved,
    this.onArchived,
  }) {
    dataClient = data.DataClient(
      dataBuilder: dataBuilder,
      getter: getter,
    );
  }

  /// contentBuilder build item content
  final Widget Function(T) contentBuilder;

  /// shimmerBuilder build shimmer item
  final Widget Function(BuildContext)? shimmerBuilder;

  /// onSaved called when save
  final VoidCallback? onSaved;

  /// onRemoved called when remove
  final VoidCallback? onRemoved;

  /// onArchived called when archive
  final VoidCallback? onArchived;

  /// dataView data view to display data
  late data.DataClient<T> dataClient;

  /// current data
  T? current;

  /// removeHandler not null will show delete button
  final NotesHandler? removeHandler;

  /// archiveHandler not null will show archive button
  final NotesHandler? archiveHandler;

  /// saveHandler not null will show save button
  final NotesHandler saveHandler;

  /// _isDirty is true mean current data is not saved
  bool _isDirty = false;

  /// isDirty is true mean current data is not saved
  bool get isDirty => _isDirty;

  final formKey = GlobalKey<FormState>();

  /// setDirty set dirty
  set isDirty(value) {
    _isDirty = value;
    notifyListeners();
  }

  /// of get [NoteController] from context
  static NoteController<T> of<T extends pb.Object>(BuildContext context) {
    return Provider.of<NoteController<T>>(context, listen: false);
  }

  /// load dataset, get data if id present
  /// ```dart
  /// await client.load(testing.Context(), 'object_id');
  /// ```
  Future<T> load(BuildContext context, {required data.Dataset<T> dataset, required String id}) async {
    current = await dataClient.load(context, dataset: dataset, id: id);
    notifyListeners();
    return current!;
  }

  /// loadByView load data set and current data from notes view, return true mean current data is changed
  /// ```dart
  /// client.loadByView(testing.Context());
  /// ```
  Future<bool> loadByView(BuildContext context, {required data.Dataset<T> dataset, required T row}) async {
    if (!await onExit(context)) {
      return false;
    }
    dataClient.setDataset(dataset);
    current = row;
    notifyListeners();
    return true;
  }

  /// resetCurrent set current to null, used when set default iem
  void resetCurrent() {
    current = null;
  }

  /// onExit call when exit current data, return true mean can exit
  Future<bool> onExit(BuildContext context) async {
    if (_isDirty) {
      var result = await dialog.alert(context, 'Content is changed, save it?',
          buttonYes: true, buttonNo: true, buttonCancel: true, blurry: false);
      if (result == true) {
        bool ok = await save(context);
        if (!ok) {
          return false;
        }
      } else if (result == false) {
        _isDirty = false;
        // discard content
      } else if (result == null) {
        return false;
      }
    }
    return true;
  }

  /// remove called when user press remove button, return true mean remove success
  Future<bool> remove(BuildContext context) async {
    if (removeHandler != null && current != null) {
      final deleted = await removeHandler!(context, [current!]);
      if (!deleted) {
        return false;
      }
      await dataClient.delete(context, current!);
      eventbus.broadcast(context, NotesViewRefillEvent());
      debugPrint('item removed');
    }
    return true;
  }

  /// archive called when user press archive button,return true mean archive success
  Future<bool> archive(BuildContext context) async {
    if (archiveHandler != null && current != null) {
      final archived = await archiveHandler!(context, [current!]);
      if (!archived) {
        return false;
      }
      await dataClient.delete(context, current!);
      eventbus.broadcast(context, NotesViewRefillEvent());
      debugPrint('item archived');
    }
    return true;
  }

  /// save called when user press update button, return true mean save success
  Future<bool> save(BuildContext context) async {
    if (_isDirty) {
      final saved = await saveHandler(context, [current!]);
      if (!saved) {
        return false;
      }
      _isDirty = false;
      await dataClient.update(context, current!);
      await eventbus.broadcast(context, NotesViewRefillEvent());
      notifyListeners();
      debugPrint('item saved');
    }
    return true;
  }
}
