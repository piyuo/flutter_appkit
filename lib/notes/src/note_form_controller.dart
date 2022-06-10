import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:libcli/pb/pb.dart' as pb;
import 'package:libcli/delta/delta.dart' as delta;
import 'package:libcli/data/data.dart' as data;
import 'package:libcli/eventbus/eventbus.dart' as eventbus;
import 'package:libcli/dialog/dialog.dart' as dialog;
import 'package:libcli/form/form.dart' as form;
import 'types.dart';

const creatingID = '_';

/// NoteFormController load single item and provide a way to save/delete/archive it
class NoteFormController<T extends pb.Object> with ChangeNotifier {
  NoteFormController({
    required this.formGroup,
    required this.formBuilder,
    required pb.Builder<T> objectBuilder,
    required data.DataClientLoader<T> loader,
    required data.DataClientSaver<T> saver,
    required this.creator,
    this.formLoader,
    this.formSaver,
    this.shimmerBuilder,
    this.showArchiveButton = false,
    this.showDeleteButton = false,
    this.showRestoreButton = false,
  }) {
    dataClient = data.DataClient(
      objectBuilder: objectBuilder,
      loader: loader,
      saver: saver,
    );
  }

  /// showArchiveButton is true mean show archive button
  final bool showArchiveButton;

  /// showDeleteButton is true mean show delete button
  final bool showDeleteButton;

  /// showRestoreButton is true mean show restore button
  final bool showRestoreButton;

  /// formGroup is from group
  final FormGroup formGroup;

  /// formBuilder build item form
  final Widget Function(T) formBuilder;

  /// shimmerBuilder build shimmer item
  final Widget Function(BuildContext)? shimmerBuilder;

  /// dataView data view to display data
  late data.DataClient<T> dataClient;

  /// creator create new item
  final delta.FutureContextCallback<T> creator;

  /// current is current loaded item
  T? current;

  /// isEmpty return true if item is not load yet
  bool get isEmpty => current == null;

  /// isNotEmpty return true if item loaded
  bool get isNotEmpty => !isEmpty;

  /// saveHandler not null will show save button
  final void Function(FormGroup formGroup, T item)? formLoader;

  /// saveHandler not null will show save button
  final void Function(FormGroup formGroup, T item)? formSaver;

  /// _isDirty is true mean form data is ready to save
  //bool get _isDirty => formGroup.valid && formGroup.dirty;

  /// of get [NoteFormController] from context
  static NoteFormController<T> of<T extends pb.Object>(BuildContext context) {
    return Provider.of<NoteFormController<T>>(context, listen: false);
  }

  void _itemToForm() {
    form.objectToForm(current!, formGroup);
    formLoader?.call(formGroup, current!);
  }

  void _formToItem() {
    form.formToObject(formGroup, current!);
    formSaver?.call(formGroup, current!);
  }

  /// load dataset, get data if id present
  /// ```dart
  /// await client.load(testing.Context(), 'object_id');
  /// ```
  Future<T> load(BuildContext context, {required data.Dataset<T> dataset, required String id}) async {
    current = id != creatingID ? await dataClient.load(context, dataset: dataset, id: id) : await creator(context);
    _itemToForm();
    notifyListeners();
    return current!;
  }

  /// loadByView load data set and _item data from notes view,return false mean current data is editing can't leave,  return true mean _item data is changed
  /// ```dart
  /// client.loadByView(testing.Context());
  /// ```
  Future<void> loadByView(BuildContext context, {required data.Dataset<T> dataset, required T row}) async {
    if (current != null && current!.id == row.id) {
      return;
    }
    dataClient.setDataset(dataset);
    current = row;
    _itemToForm();
    notifyListeners();
  }

  /// allowToExit is true mean can exit
  Future<bool> allowToExit(BuildContext context) async {
    if (formGroup.dirty) {
      var result = await dialog.alert(context, 'Content is changed, save it?',
          buttonYes: true, buttonNo: true, buttonCancel: true, blurry: false);
      if (result == true) {
        // user want save
        bool ok = await submit(context);
        if (!ok) {
          return false;
        }
      } else if (result == false) {
        // discard content
        formGroup.reset();
      } else if (result == null) {
        return false;
      }
    }
    return true;
  }

  /// delete called when user press remove button
  Future<void> delete(BuildContext context, List<T> list) async {
    await dataClient.delete(context, list);
    //await eventbus.broadcast(context, NotesRefillEvent());
    debugPrint('item deleted');
  }

  /// archive called when user press archive button
  Future<void> archive(BuildContext context, List<T> list) async {
    await dataClient.archive(context, list);
    await eventbus.broadcast(context, NotesRefillEvent());
    debugPrint('item archived');
  }

  /// restore called when user press restore button
  Future<void> restore(BuildContext context, List<T> list) async {
    await dataClient.restore(context, list);
    await eventbus.broadcast(context, NotesRefillEvent());
    debugPrint('item restored');
  }

  /// buildForm use formBuilder to build form
  Widget buildForm(BuildContext context) => current != null ? formBuilder(current!) : const SizedBox();

  /// submit form, return true if form is submit success
  Future<bool> submit(BuildContext context) async {
    if (formGroup.valid && formGroup.dirty) {
      return await form.submit(
        context,
        formGroup,
        onPressed: () => onSubmit(context),
      );
    }
    return false;
  }

  /// onSubmit called when user press submit button or submit been called, return true mean submit success
  Future<bool> onSubmit(BuildContext context) async {
    _formToItem();
    await dataClient.save(context, [current!]);
    await eventbus.broadcast(context, NotesRefillEvent());
    notifyListeners();
    debugPrint('item saved');
    return true;
  }
}
