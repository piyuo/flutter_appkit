import 'package:flutter/material.dart';
import 'package:libcli/delta/delta.dart' as delta;
import 'package:libcli/db/db.dart' as db;
import 'package:libcli/pb/pb.dart' as pb;
import 'package:libcli/animations/animations.dart' as animations;
import 'tag.dart';
import 'master_detail_view.dart';

class NotesController<T extends pb.Object> with ChangeNotifier {
  NotesController(
    db.Memory<T> _memory, {
    required BuildContext context,
    required db.DatasetLoader<T> loader,
    required pb.Builder<T> dataBuilder,
    this.tags = const [],
    this.onAdd,
    this.onDelete,
    this.onTagChanged,
  }) {
    dataset = context.isPreferMouse
        ? db.PagedDataset<T>(
            _memory,
            dataBuilder: dataBuilder,
            loader: loader,
          )
        : db.ContinuousDataset<T>(
            _memory,
            dataBuilder: dataBuilder,
            loader: loader,
          );
    start(context);
  }

  /// start dataset
  Future<void> start(BuildContext context) async {
    await dataset.start(context);
    animatedViewController.itemCount = dataset.displayRows.length;
    setDefaultSelected();
    notifyListeners();
  }

  /// refreshButtonController is refresh button controller
  final refreshButtonController = delta.RefreshButtonController();

  /// animatedViewController control view animation
  final animatedViewController = animations.AnimatedViewProvider(0);

  /// searchController is search box controller
  final searchController = TextEditingController();

  /// table is data to be display
  late db.Dataset<T> dataset;

  /// tags is a list of tags to display.
  List<Tag<String>> tags;

  /// isListView is true if is in list view mode
  bool isListView = true;

  /// isCheckMode is true if is in check mode
  bool isCheckMode = false;

  /// onNew called when pressed new button
  final Future<void> Function()? onAdd;

  /// onDelete called when pressed delete button
  final Future<void> Function()? onDelete;

  /// onTagChanged called when tag changed
  final Future<void> Function(String value)? onTagChanged;

  @override
  void dispose() {
    refreshButtonController.dispose();
    animatedViewController.dispose();
    super.dispose();
  }

  /// noMore return true if dataset is no more data
  bool get noMore => dataset.noMore;

  /// noRefresh return true if dataset is no need refresh
  bool get noRefresh => dataset.noRefresh;

  /// noRefresh set to true if no need refresh dataset
  set noRefresh(value) => dataset.noRefresh = value;

  /// setDefaultSelected will select first row if no row selected
  void setDefaultSelected() {
    if (dataset.selectedRows.isEmpty && dataset.displayRows.isNotEmpty) {
      dataset.selectRows([dataset.displayRows.first]);
    }
  }

  /// selectRows call when user select rows
  void selectRows(List<T> selectedItems) {
    dataset.selectRows(selectedItems);
    notifyListeners();
  }

  /// hasNextPage return true if has next page
  bool get hasNextPage => dataset is db.PagedDataset ? (dataset as db.PagedDataset).hasNextPage : false;

  /// hasPrevPage return true if has prev page
  bool get hasPrevPage => dataset is db.PagedDataset ? (dataset as db.PagedDataset).hasPrevPage : false;

  /// refill let dataset refill data, the data may changed or deleted
  Future<void> refill(BuildContext context) async => await barAction(context, MasterDetailViewAction.refill);

  /// refresh dataset
  Future<void> refresh(BuildContext context) async => await barAction(context, MasterDetailViewAction.refresh);

  /// barAction handle bar action
  Future<void> barAction(BuildContext context, MasterDetailViewAction action) async {
    switch (action) {
      case MasterDetailViewAction.refresh:
        final originLength = dataset.length;
        var firstPage = true;
        if (dataset is db.PagedDataset) {
          firstPage = (dataset as db.PagedDataset).isFirstPage;
        }
        final isReset = await dataset.refresh(context);
        final diff = dataset.length - originLength;
        setDefaultSelected();
        if (isReset || (diff > 0 && !firstPage)) {
          animatedViewController.refreshPageAnimation();
          animatedViewController.itemCount = dataset.displayRows.length;
        } else if (diff > 0) {
          if (dataset.isDisplayRowsFullPage) {
            animatedViewController.itemCount = dataset.rowsPerPage - diff;
          }
          for (int i = 0; i < diff; i++) {
            animatedViewController.insertAnimation();
          }
        }
        break;
      case MasterDetailViewAction.more:
        await dataset.more(context, dataset.rowsPerPage);
        animatedViewController.itemCount = dataset.displayRows.length;
        break;
      case MasterDetailViewAction.refill:
        await dataset.fill();
        animatedViewController.itemCount = dataset.displayRows.length;
        break;
      case MasterDetailViewAction.previousPage:
        if (dataset is db.PagedDataset) {
          await (dataset as db.PagedDataset).prevPage(context);
          animatedViewController.itemCount = dataset.displayRows.length;
          animatedViewController.prevPageAnimation();
        }
        break;
      case MasterDetailViewAction.nextPage:
        if (dataset is db.PagedDataset) {
          await (dataset as db.PagedDataset).nextPage(context);
          animatedViewController.itemCount = dataset.displayRows.length;
          animatedViewController.nextPageAnimation();
        }
        break;
      case MasterDetailViewAction.rows10:
        await dataset.setRowsPerPage(context, 10);
        animatedViewController.itemCount = dataset.displayRows.length;
        break;
      case MasterDetailViewAction.rows20:
        await dataset.setRowsPerPage(context, 20);
        animatedViewController.itemCount = dataset.displayRows.length;
        break;
      case MasterDetailViewAction.rows50:
        await dataset.setRowsPerPage(context, 50);
        animatedViewController.itemCount = dataset.displayRows.length;
        break;
      case MasterDetailViewAction.listView:
        isListView = true;
        break;
      case MasterDetailViewAction.gridView:
        isListView = false;
        break;
      case MasterDetailViewAction.toggleCheckMode:
        isCheckMode = !isCheckMode;
        if (isCheckMode) {
          dataset.selectRows([]);
        } else {
          if (dataset.displayRows.isNotEmpty) {
            dataset.selectRows([dataset.displayRows.first]);
          }
        }
        break;
      case MasterDetailViewAction.add:
        await onAdd?.call();
        break;
      case MasterDetailViewAction.delete:
        await onDelete?.call();
        break;
    }
    notifyListeners();
    debugPrint('$action');
  }

  /// setSelectedTag called when a tag is selected
  Future<void> setSelectedTag(String value) async {
    for (final tag in tags) {
      tag.selected = tag.value == value;
    }
    await onTagChanged?.call(value);
    notifyListeners();
  }

  /// getSelectedTag return selected tag
  String? getSelectedTag() {
    for (final tag in tags) {
      if (tag.selected) {
        return tag.value;
      }
    }
    return null;
  }

  /// getRowByID return object by id
  /// ```dart
  /// final obj = await getRowByID('1');
  /// ```
  Future<T?> getRowByID(String id) async => await dataset.getRowByID(id);
}
