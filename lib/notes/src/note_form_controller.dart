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
import 'notes_provider.dart';

const creatingID = '_';

/// NotesFormState define form is loading, loaded, load empty form, load form ist not exists
enum NotesFormState { loading, loaded, formEmpty, formNotExists }

/// NoteFormController load single item and provide a way to save/delete/archive it
class NoteFormController<T extends pb.Object> with ChangeNotifier {
  NoteFormController({
    required this.formGroup,
    required this.formBuilder,
    required delta.FutureCallback<T> creator,
    required data.DataClientLoader<T> loader,
    required data.DataClientSaver<T> saver,
    this.formLoader,
    this.formSaver,
    this.showArchiveButton = false,
    this.showDeleteButton = false,
    this.showRestoreButton = false,
  }) {
    dataClient = data.DataClient(
      creator: creator,
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

  /// isAllowDelete is true current item can be delete
  bool get isAllowDelete => !isNewItem;

  /// formGroup is from group
  final FormGroup formGroup;

  /// isInView is true mean form is in notes view
  bool isInView = false;

  /// formBuilder build item form
  final Widget Function(BuildContext context, NoteFormController<T> controller) formBuilder;

  /// dataView data view to display data
  late data.DataClient<T> dataClient;

  /// formState is current form state
  NotesFormState formState = NotesFormState.loading;

  /// current is current loaded item
  T? current;

  /// isNewItem is true mean current is new item
  bool isNewItem = false;

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
    if (current != null) {
      form.objectToForm(current!, formGroup);
      formLoader?.call(formGroup, current!);
    }
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
    current = await dataClient.load(context, dataset: dataset, id: id);
    formState = current != null ? NotesFormState.loaded : NotesFormState.formNotExists;
    if (current != null) {
      _itemToForm();
    }
    notifyListeners();
    isNewItem = id == creatingID;
    if (isNewItem) {
      formGroup.markAsDirty();
    }
    return current!;
  }

  /// loadByView load data set and _item data from notes view,return false mean current data is editing can't leave,  return true mean _item data is changed
  /// ```dart
  /// client.loadByView();
  /// ```
  Future<void> loadByView({required data.Dataset<T> dataset, required T row}) async {
    if (current != null && current!.id == row.id) {
      return;
    }
    dataClient.setDataset(dataset);
    current = row;
    formState = NotesFormState.loaded;
    _itemToForm();
    formGroup.markAsPristine();
    isNewItem = false;

    notifyListeners();
  }

  /// loadNewByView load form empty. not data to display
  Future<T> loadNewByView(BuildContext context, data.Dataset<T> dataset) async {
    final creating = await dataClient.creator();
    await loadByView(dataset: dataset, row: creating);
    formGroup.markAsDirty();
    isNewItem = true;
    return creating;
  }

  /// loadEmpty load form empty. not data to display
  void loadEmpty() {
    reset();
    formState = NotesFormState.formEmpty;
    isNewItem = false;
    notifyListeners();
  }

  /// reset formGroup/current to null
  void reset() {
    current = null;
    formGroup.reset();
    notifyListeners();
  }

  /// delete called when user press remove button, return true if success
  Future<void> delete(BuildContext context) async {
    if (current == null) {
      return;
    }
    if (isInView) {
      await NotesProvider.of<T>(context).onDelete(context);
      return;
    }
    await deleteByView(context, [current!]);
    await eventbus.broadcast(NotesRefillEvent(isRemove: true));
    Navigator.of(context).pop();
  }

  /// archive called when user press archive button
  Future<void> archive(BuildContext context, List<T> list) async {
    if (current == null) {
      return;
    }
    if (isInView) {
      await NotesProvider.of<T>(context).onArchive(context);
      return;
    }
    await archiveByView(context, list);
    await eventbus.broadcast(NotesRefillEvent(isRemove: true));
    Navigator.of(context).pop();
  }

  /// restore called when user press restore button
  Future<void> restore(BuildContext context, List<T> list) async {
    if (current == null) {
      return;
    }
    if (isInView) {
      await NotesProvider.of<T>(context).onRestore(context);
      return;
    }
    await restoreByView(context, list);
    await eventbus.broadcast(NotesRefillEvent(isRemove: true));
    Navigator.of(context).pop();
  }

  /// deleteByView called by view
  Future<void> deleteByView(BuildContext context, List<T> list) async {
    await dialog.toastWaitFor(
      showDone: false,
      callback: () => dataClient.delete(context, list),
    );
  }

  /// archiveByView called by view
  Future<void> archiveByView(BuildContext context, List<T> list) async {
    await dataClient.archive(context, list);
  }

  /// restoreByView called by view
  Future<void> restoreByView(BuildContext context, List<T> list) async {
    await dataClient.restore(context, list);
  }

  /// buildForm use formBuilder to build form
  Widget buildForm(BuildContext context) => formBuilder(context, this);

  /// isAllowToExit is true mean can exit
  Future<bool> isAllowToExit(BuildContext context) async => await form.isAllowToExit(
        context,
        formGroup: formGroup,
        submitCallback: onSubmit,
      );

  /// submit form, return true if form is submit success
  Future<bool> submit(BuildContext context) async {
    if (formGroup.valid && formGroup.dirty) {
      return await form.submit(
        formGroup: formGroup,
        callback: onSubmit,
      );
    }
    return false;
  }

  /// onSubmit called when user press submit button or submit been called, return true mean submit success
  Future<bool> onSubmit(BuildContext context) async {
    _formToItem();
    await dataClient.save(context, [current!]);
    await eventbus.broadcast(NotesRefillEvent(isNew: isNewItem));
    notifyListeners();
    return true;
  }
}
