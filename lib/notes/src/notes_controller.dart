import 'package:flutter/material.dart';
import 'package:libcli/delta/delta.dart' as delta;
import 'package:libcli/db/db.dart' as db;
import 'package:libcli/pb/pb.dart' as pb;
import 'package:beamer/beamer.dart';
import 'package:libcli/animations/animations.dart' as animations;
import 'package:libcli/responsive/responsive.dart' as responsive;
import 'tag.dart';
import 'master_detail_view.dart';

/// Adder add new item
typedef Adder<T> = Future<T> Function(BuildContext context);

/// Remover remove list of selected rows
typedef Remover<T> = Future<bool> Function(BuildContext context, List<T> item);

class NotesController<T extends pb.Object> with ChangeNotifier {
  NotesController(
    db.Memory<T> _memory, {
    required BuildContext context,
    required db.DatasetLoader<T> loader,
    required pb.Builder<T> dataBuilder,
    required this.adder,
    required this.remover,
    required this.isSaved,
    required this.isRemovable,
    this.tags = const [],
    this.onTagChanged,
    this.onShowDetail,
    this.detailBeamName = '',
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
    open(context);
  }

  /// open dataset
  Future<void> open(BuildContext context) async {
    await dataset.open(context);
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

  /// onTagChanged called when tag changed
  final Future<void> Function(String value)? onTagChanged;

  /// adder create new item
  final Adder adder;

  /// isSaved is true if row is saved and ready to move to other row
  final bool Function(T row) isSaved;

  /// remover remove item
  final Remover remover;

  /// isRemovable check if item is removable, return true will delete the row
  final bool Function(List<T> row) isRemovable;

  /// newItem is not null mean user is editing a new item
  T? newItem;

  /// onShowDetail called when row is selected and ready to show on detail
  final void Function(T)? onShowDetail;

  /// detailBeamName is the beam location name of detail, like '/user'
  final String detailBeamName;

  @override
  void dispose() {
    refreshButtonController.dispose();
    animatedViewController.dispose();
    dataset.dispose();
    super.dispose();
  }

  /// noMore return true if dataset is no more data
  bool get noMore => dataset.noMore;

  /// noRefresh return true if dataset is no need refresh
  bool get noRefresh => dataset.noRefresh;

  /// noRefresh set to true if no need refresh dataset
  Future<void> setNoRefresh(BuildContext context, value) async => await dataset.setNoRefresh(context, value);

  /// setDefaultSelected will select first row if no row selected
  void setDefaultSelected() {
    if (dataset.selectedRows.isEmpty && dataset.displayRows.isNotEmpty) {
      if (onRowExit(null)) {
        dataset.selectRows([dataset.displayRows.first]);
      }
    }
  }

  /// onItemChecked called when user select item, return true if new item has been selected
  bool onItemChecked(BuildContext context, List<T> selectedRows) {
    final oldRow = dataset.selectedRows.isNotEmpty ? dataset.selectedRows.first : null;
    if (!onRowExit(oldRow)) {
      return false;
    }
    dataset.selectRows(selectedRows);
    notifyListeners();
    return true;
  }

  /// onItemSelected call when user select rows
  void onItemSelected(BuildContext context, List<T> selectedRows) {
    if (!onItemChecked(context, selectedRows)) {
      return;
    }

    if (!isSplitView) {
      final item = selectedRows.first;
      context.beamToNamed('$detailBeamName/${item.entityID}');
      return;
    }

    final newRow = selectedRows.first;
    onShowDetail?.call(newRow);
  }

  /// onRowExit return true if row allow to exit
  bool onRowExit(T? oldRow) {
    if (oldRow != null && !isSaved(oldRow)) {
      return false;
    }
    newItem = null;
    return true;
  }

  /// isSplitView is true if in split view
  bool get isSplitView => isListView && !responsive.phoneScreen;

  /// hasNextPage return true if has next page
  bool get hasNextPage => dataset is db.PagedDataset ? (dataset as db.PagedDataset).hasNextPage : false;

  /// hasPrevPage return true if has prev page
  bool get hasPrevPage => dataset is db.PagedDataset ? (dataset as db.PagedDataset).hasPrevPage : false;

  /// refill let dataset refill data, the data may changed or deleted
  Future<void> refill(BuildContext context) async {
    await dataset.fill();
    newItem = null;
    setDefaultSelected();
    animatedViewController.itemCount = dataset.displayRows.length;
    notifyListeners();
  }

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
        if (!isSplitView) {
          context.beamToNamed('$detailBeamName/new/');
          return;
        }

        dataset.selectRows([]);
        newItem = await adder(context);
        animatedViewController.itemCount = dataset.displayRows.length + 1;
        animatedViewController.insertAnimation();
        break;
      case MasterDetailViewAction.delete:
        if (isRemovable(dataset.selectedRows)) {
          final deleted = await remover(context, dataset.selectedRows);
          if (deleted) {
            await dataset.memory.delete(context, dataset.selectedRows);
            dataset.selectRows([]);
            await refill(context);
          }
        }
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
