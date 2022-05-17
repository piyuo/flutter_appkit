import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:libcli/delta/delta.dart' as delta;
import 'package:libcli/data/data.dart' as data;
import 'package:libcli/pb/pb.dart' as pb;
import 'package:beamer/beamer.dart';
import 'package:libcli/animations/animations.dart' as animations;
import 'package:libcli/responsive/responsive.dart' as responsive;
import 'tag.dart';
import 'master_detail_view.dart';
import 'selectable.dart';

/// Adder add new item
typedef Adder<T> = Future<T> Function(BuildContext context);

/// Remover remove list of selected rows
typedef Remover<T> = Future<bool> Function(BuildContext context, List<T> item);

class NotesController<T extends pb.Object> with ChangeNotifier {
  NotesController({
    required BuildContext context,
    required this.dataset,
    required pb.Builder<T> dataBuilder,
    required data.DataViewLoader<T> loader,
    required this.adder,
    required this.remover,
    required this.isSaved,
    required this.isRemovable,
    this.tags = const [],
    this.onTagChanged,
    this.onSearchChanged,
    this.onItemSelected,
    this.detailBeamName = '/',
    required this.onSearch,
    this.onSearchBegin,
    this.onSearchEnd,
  }) {
    searchTrigger = delta.SearchTrigger(
      controller: searchController,
      onSearch: onSearch,
      onSearchBegin: onSearchBegin,
      onSearchEnd: onSearchEnd,
    );

    dataset.onChanged = (context) async {
      dataView.selectRows([]);
      await refill(context);
    };

    dataView = context.isPreferMouse
        ? data.PagedDataView<T>(
            dataset,
            dataBuilder: dataBuilder,
            loader: loader,
          )
        : data.ContinuousDataView<T>(
            dataset,
            dataBuilder: dataBuilder,
            loader: loader,
          );

    open(context);
  }

  /// of get NotesController from context
  static NotesController of(BuildContext context) {
    return Provider.of<NotesController>(context, listen: false);
  }

  /// open dataset
  Future<void> open(BuildContext context) async {
    await dataView.load(context);
    animatedViewController.itemCount = dataView.displayRows.length;
    setDefaultSelected(context);
    isReadyToShow = true;
    notifyListeners();
  }

  /// dataView data view to display data
  late data.DataView<T> dataView;

  /// dataset used in data view
  data.Dataset<T> dataset;

  /// refreshButtonController is refresh button controller
  final refreshButtonController = delta.RefreshButtonController();

  /// animatedViewController control view animation
  final animatedViewController = animations.AnimatedViewProvider(0);

  /// _searchController is search box controller
  final searchController = TextEditingController();

  /// tags is a list of tags to display.
  List<Tag<String>> tags;

  /// isListView is true if is in list view mode
  bool isListView = true;

  /// isCheckMode is true if is in check mode
  bool isCheckMode = false;

  /// onTagChanged called when tag changed, return true if need refresh
  final Future<bool> Function(String value)? onTagChanged;

  /// onSearchChanged called when search changed, return true if need refresh
  final Future<bool> Function(String value)? onSearchChanged;

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

  /// onItemSelected called when row is selected and ready to show on detail
  final void Function(BuildContext context, T item)? onItemSelected;

  /// detailBeamName is the beam location name of detail and name must end with "/" like '/user/'
  final String detailBeamName;

  /// isReadyToShow is true mean list is ready to show
  bool isReadyToShow = false;

  /// searchTrigger trigger search event
  late delta.SearchTrigger searchTrigger;

  /// onSearch called when text need to be search
  final void Function(String text) onSearch;

  /// onSearchBegin called when text is editing and search begin
  final VoidCallback? onSearchBegin;

  /// onSearchEnd called when text is clear and search end
  final VoidCallback? onSearchEnd;

  @override
  void dispose() {
    searchTrigger.dispose();
    refreshButtonController.dispose();
    animatedViewController.dispose();
    dataView.dispose();
    super.dispose();
  }

  /// noMore return true if dataset is no more data
  bool get noMore => dataView.noMore;

  /// noRefresh return true if dataset is no need refresh
  bool get noRefresh => dataView.noRefresh;

  /// noRefresh set to true if no need refresh dataset
  Future<void> setNoRefresh(BuildContext context, value) async => await dataView.setNoRefresh(context, value);

  /// setDefaultSelected will select first row if no row selected
  void setDefaultSelected(BuildContext context) {
    if (dataView.selectedRows.isEmpty && dataView.displayRows.isNotEmpty) {
      if (onRowExit(null)) {
        final first = dataView.displayRows.first;
        dataView.selectRows([first]);
        onItemSelected?.call(context, first);
      }
    }
  }

  /// onItemTapped called when user tap item
  void onItemTapped(BuildContext context, T selectedRow) {
    if (!isSplitView) {
      context.beamToNamed('$detailBeamName${selectedRow.entityID}/');
      return;
    }
  }

  /// onSelectItems call when user select rows
  void onSelectItems(BuildContext context, List<T> selectedRows) {
    if (!onItemChecked(context, selectedRows)) {
      return;
    }
    final newRow = selectedRows.first;
    onItemSelected?.call(context, newRow);
  }

  /// onItemChecked called when user select item, return true if new item has been selected
  bool onItemChecked(BuildContext context, List<T> selectedRows) {
    final oldRow = dataView.selectedRows.isNotEmpty ? dataView.selectedRows.first : null;
    if (!onRowExit(oldRow)) {
      return false;
    }
    dataView.selectRows(selectedRows);
    notifyListeners();
    return true;
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
  bool get hasNextPage => dataView is data.PagedDataView ? (dataView as data.PagedDataView).hasNextPage : false;

  /// hasPrevPage return true if has prev page
  bool get hasPreviousPage => dataView is data.PagedDataView ? (dataView as data.PagedDataView).hasPrevPage : false;

  /// refill let dataset refill data, the data may changed or deleted
  Future<void> refill(BuildContext context) async {
    await dataView.fill();
    newItem = null;
    setDefaultSelected(context);
    animatedViewController.itemCount = dataView.displayRows.length;
    notifyListeners();
  }

  /// refresh dataset
  Future<void> refresh(BuildContext context) async => await onBarAction(context, MasterDetailViewAction.refresh);

  /// onBarAction handle bar action
  Future<void> onBarAction(
    BuildContext context,
    MasterDetailViewAction action, {
    ItemBuilder<T>? builder, // only use at delete
  }) async {
    switch (action) {
      case MasterDetailViewAction.refresh:
        final originLength = dataView.length;
        var firstPage = true;
        if (dataView is data.PagedDataView) {
          firstPage = (dataView as data.PagedDataView).isFirstPage;
        }
        final isReset = await dataView.refresh(context);
        final diff = dataView.length - originLength;
        setDefaultSelected(context);
        if (isReset || (diff > 0 && !firstPage)) {
          animatedViewController.refreshPageAnimation();
          animatedViewController.itemCount = dataView.displayRows.length;
        } else if (diff > 0) {
          if (dataView.isDisplayRowsFullPage) {
            animatedViewController.itemCount = dataView.rowsPerPage - diff;
          }
          for (int i = 0; i < diff; i++) {
            animatedViewController.insertAnimation();
          }
        }
        break;
      case MasterDetailViewAction.more:
        await dataView.more(context, dataView.rowsPerPage);
        animatedViewController.itemCount = dataView.displayRows.length;
        break;
      case MasterDetailViewAction.previousPage:
        if (dataView is data.PagedDataView) {
          await (dataView as data.PagedDataView).prevPage(context);
          animatedViewController.itemCount = dataView.displayRows.length;
          animatedViewController.prevPageAnimation();
        }
        break;
      case MasterDetailViewAction.nextPage:
        if (dataView is data.PagedDataView) {
          await (dataView as data.PagedDataView).nextPage(context);
          animatedViewController.itemCount = dataView.displayRows.length;
          animatedViewController.nextPageAnimation();
        }
        break;
      case MasterDetailViewAction.rows10:
        await dataView.setRowsPerPage(context, 10);
        animatedViewController.itemCount = dataView.displayRows.length;
        break;
      case MasterDetailViewAction.rows20:
        await dataView.setRowsPerPage(context, 20);
        animatedViewController.itemCount = dataView.displayRows.length;
        break;
      case MasterDetailViewAction.rows50:
        await dataView.setRowsPerPage(context, 50);
        animatedViewController.itemCount = dataView.displayRows.length;
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
          dataView.selectRows([]);
        } else {
          if (dataView.displayRows.isNotEmpty) {
            dataView.selectRows([dataView.displayRows.first]);
          }
        }
        break;
      case MasterDetailViewAction.add:
        if (!isSplitView) {
          context.beamToNamed('${detailBeamName}new/');
          return;
        }

        dataView.selectRows([]);
        newItem = await adder(context);
        animatedViewController.itemCount = dataView.displayRows.length + 1;
        animatedViewController.insertAnimation();
        break;
      case MasterDetailViewAction.delete:
        assert(builder != null, 'builder must not be null when delete item');

        if (isCheckMode) {
          isCheckMode = false;
        }
        if (isRemovable(dataView.selectedRows)) {
          final deleted = await remover(context, dataView.selectedRows);
          if (deleted) {
            await dataView.dataset.delete(context, dataView.selectedRows);
            int removeCount = 0;
            for (int i = 0; i < dataView.displayRows.length; i++) {
              final row = dataView.displayRows[i];
              if (dataView.selectedRows.contains(row)) {
                final child = builder!(context, row, true);
                animatedViewController.removeAnimation(i - removeCount, isListView, child);
                removeCount++;
              }
            }
            await dataView.fill();
            dataView.selectRows([]);
            animatedViewController.onAnimationDone(() {
              setDefaultSelected(context);
              notifyListeners();
            });
          }
        }

        break;
    }
    notifyListeners();
    debugPrint('$action');
  }

  /// setSelectedTag called when a tag is selected
  Future<void> setSelectedTag(String value) async {
    String oldValue = getSelectedTag();
    for (final tag in tags) {
      tag.selected = tag.value == value;
    }
    if (value != oldValue) {
      searchController.text = '';
      bool needReload = false;
      if (onTagChanged != null) {
        needReload = await onTagChanged!(value);
      }
      if (needReload) {}
      notifyListeners();
    }
  }

  /// getSelectedTag return selected tag
  String getSelectedTag() {
    for (final tag in tags) {
      if (tag.selected) {
        return tag.value;
      }
    }
    return '';
  }

  /// getRowByID return object by id
  /// ```dart
  /// final obj = await getRowByID('1');
  /// ```
  Future<T?> getRowByID(String id) async => await dataView.getRowByID(id);
}
