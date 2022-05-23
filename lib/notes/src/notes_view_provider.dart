import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:beamer/beamer.dart';
import 'package:libcli/delta/delta.dart' as delta;
import 'package:libcli/eventbus/eventbus.dart' as eventbus;
import 'package:libcli/data/data.dart' as data;
import 'package:libcli/pb/pb.dart' as pb;
import 'package:libcli/animations/animations.dart' as animations;
import 'package:libcli/responsive/responsive.dart' as responsive;
import 'tag.dart';
import 'master_detail_view.dart';
import 'selectable.dart';

/// NotesViewRefillEvent will let NotesViewProvider to refill the list
class NotesViewRefillEvent extends eventbus.Event {}

/// NotesViewProviderRemover remove list of selected rows
typedef NotesViewProviderRemover<T> = Future<bool> Function(BuildContext context, List<T> item);

/// Notes controller will load dataset to display but not close it, you need close dataset if need
class NotesViewProvider<T extends pb.Object> with ChangeNotifier {
  NotesViewProvider({
    required this.listBuilder,
    required this.gridBuilder,
    required this.detailBuilder,
    required this.dataBuilder,
    required this.loader,
    required this.adder,
    required this.remover,
    required this.isSaved,
    required this.isRemovable,
    this.listDecorationBuilder = defaultListDecorationBuilder,
    this.gridDecorationBuilder = defaultGridDecorationBuilder,
    this.caption,
    this.deleteLabel,
    this.deleteIcon,
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
    subscription = eventbus.listen<NotesViewRefillEvent>((BuildContext context, event) async {
      if (dataView != null) {
        await dataView!.load(context);
        await refill(context);
        scrollToTop();
      }
    });
  }

  /// listBuilder is the builder for list view
  final ItemBuilder<T> listBuilder;

  /// gridBuilder is the builder for grid view
  final ItemBuilder<T> gridBuilder;

  /// listDecorationBuilder is a list decoration builder
  final ItemDecorationBuilder<T> listDecorationBuilder;

  /// gridDecorationBuilder is a grid decoration builder
  final ItemDecorationBuilder<T> gridDecorationBuilder;

  /// detailBuilder is the builder for detail view
  final Widget Function(T) detailBuilder;

  /// caption on top of search box
  final String? caption;

  /// deleteLabel is the label for delete button
  final String? deleteLabel;

  /// deleteIcon is the icon for delete button
  final IconData? deleteIcon;

  /// dataBuilder
  final pb.Builder<T> dataBuilder;

  /// loader
  final data.DataViewLoader<T> loader;

  /// dataView data view to display data
  data.DataView<T>? dataView;

  /// dataset used in data view
  data.Dataset<T>? dataset;

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
  final delta.FutureContextCallback adder;

  /// isSaved is true if row is saved and ready to move to other row
  final bool Function(T row) isSaved;

  /// remover remove item
  final NotesViewProviderRemover remover;

  /// isRemovable check if item is removable, return true will delete the row
  final bool Function(List<T> row) isRemovable;

  /// newItem is not null mean user is editing a new item
  T? newItem;

  /// onItemSelected called when row is selected and ready to show on detail
  final void Function(BuildContext context, T item)? onItemSelected;

  /// detailBeamName is the beam location name of detail and name must end with "/" like '/user/'
  final String detailBeamName;

  /// isReady is true mean content is ready to show
  bool get isReady => dataView != null;

  /// isEmpty is true mean content is empty
  bool get isEmpty => !isNotEmpty;

  /// isNotEmpty is true mean content is not empty
  bool get isNotEmpty => dataView != null && dataView!.isNotEmpty;

  /// searchTrigger trigger search event
  late delta.SearchTrigger searchTrigger;

  /// onSearch called when text need to be search
  final void Function(String text) onSearch;

  /// onSearchBegin called when text is editing and search begin
  final VoidCallback? onSearchBegin;

  /// onSearchEnd called when text is clear and search end
  final VoidCallback? onSearchEnd;

  /// subscription for NotesRefillEvent
  eventbus.Subscription? subscription;

  /// listScrollController is scroll controller for list
  final ScrollController listScrollController = ScrollController();

  /// listAnimatedViewScrollController is animated view scroll controller for list
  final ScrollController listAnimatedViewScrollController = ScrollController();

  /// gridScrollController is scroll controller for grid
  final ScrollController gridScrollController = ScrollController();

  /// gridAnimatedViewScrollController is animated view scroll controller for grid
  final ScrollController gridAnimatedViewScrollController = ScrollController();

  /// of get [NotesViewProvider] from context
  static NotesViewProvider<T> of<T extends pb.Object>(BuildContext context) {
    return Provider.of<NotesViewProvider<T>>(context, listen: false);
  }

  /// scrollToTop scroll to top
  void scrollToTop() {
    if (isListView) {
      listScrollController.jumpTo(0);
      listAnimatedViewScrollController.jumpTo(0);
    } else {
      gridScrollController.jumpTo(0);
      gridAnimatedViewScrollController.jumpTo(0);
    }
  }

  /// load data to display
  Future<void> load(BuildContext context, data.Dataset<T> dataset) async {
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

    await dataView!.refresh(context);
    animatedViewController.itemCount = dataView!.displayRows.length;
    setDefaultSelected(context);
    notifyListeners();
  }

  @override
  void dispose() {
    subscription?.cancel();
    searchTrigger.dispose();
    refreshButtonController.dispose();
    animatedViewController.dispose();
    super.dispose();
  }

  /// noMore return true if dataset is no more data
  bool get noMore => dataView != null ? dataView!.noMore : true;

  /// noRefresh return true if dataset is no need refresh
  bool get noRefresh => dataView != null ? dataView!.noRefresh : true;

  /// noRefresh set to true if no need refresh dataset
  Future<void> setNoRefresh(BuildContext context, value) async => await dataView?.setNoRefresh(context, value);

  /// setDefaultSelected will select first row if no row selected
  void setDefaultSelected(BuildContext context) {
    if (dataView != null && dataView!.selectedRows.isEmpty && dataView!.displayRows.isNotEmpty) {
      if (onRowExit(null)) {
        final first = dataView!.displayRows.first;
        dataView!.selectRows([first]);
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
    final oldRow = dataView!.selectedRows.isNotEmpty ? dataView!.selectedRows.first : null;
    if (!onRowExit(oldRow)) {
      return false;
    }
    dataView!.selectRows(selectedRows);
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
    await dataView!.fill();
    newItem = null;
    setDefaultSelected(context);
    animatedViewController.itemCount = dataView!.displayRows.length;
    notifyListeners();
  }

  /// _buildDeletedItemWithDecoration build item with decoration
  Widget _buildDeletedItemWithDecoration(BuildContext context, T item, bool isSelected) {
    return isListView
        ? listDecorationBuilder(
            context,
            child: listBuilder(context, item, isSelected),
            checkMode: isCheckMode,
            isSelected: isSelected,
          )
        : gridDecorationBuilder(
            context,
            child: gridBuilder(context, item, isSelected),
            checkMode: isCheckMode,
            isSelected: isSelected,
          );
  }

  /// refresh called when user tap refresh button
  Future<void> refresh(BuildContext context) async {
    if (dataView == null) {
      return;
    }
    final originLength = dataView!.length;
    var firstPage = true;
    if (dataView is data.PagedDataView) {
      firstPage = (dataView as data.PagedDataView).isFirstPage;
    }
    final isReset = await dataView!.refresh(context);
    final diff = dataView!.length - originLength;
    setDefaultSelected(context);
    if (isReset || (diff > 0 && !firstPage)) {
      animatedViewController.refreshPageAnimation();
      animatedViewController.itemCount = dataView!.displayRows.length;
    } else if (diff > 0) {
      if (dataView!.isDisplayRowsFullPage) {
        animatedViewController.itemCount = dataView!.rowsPerPage - diff;
      }
      for (int i = 0; i < diff; i++) {
        animatedViewController.insertAnimation();
      }
    }
    notifyListeners();
    debugPrint('onRefresh');
  }

  /// loadMore called when user pull down to load more data
  Future<void> loadMore(BuildContext context) async {
    if (dataView == null) {
      return;
    }
    await dataView!.more(context, dataView!.rowsPerPage);
    animatedViewController.itemCount = dataView!.displayRows.length;
    notifyListeners();
    debugPrint('onMore');
  }

  /// onToggleCheckMode called when user toggle check mode
  Future<void> onToggleCheckMode() async {
    if (dataView == null) {
      return;
    }
    isCheckMode = !isCheckMode;
    if (isCheckMode) {
      dataView?.selectRows([]);
    } else {
      if (dataView!.displayRows.isNotEmpty) {
        dataView?.selectRows([dataView!.displayRows.first]);
      }
    }
    notifyListeners();
    debugPrint('onToggleCheckMode');
  }

  /// onListView called when user set to list view
  Future<void> onListView() async {
    if (!isListView) {
      isListView = true;
      notifyListeners();
      debugPrint('onListView');
    }
  }

  /// onGridView called when user set to grid view
  Future<void> onGridView() async {
    if (isListView) {
      isListView = false;
      notifyListeners();
      debugPrint('onGridView');
    }
  }

  /// onDelete called when user press delete button
  Future<void> onDelete(BuildContext context) async {
    if (isCheckMode) {
      isCheckMode = false;
    }
    if (isRemovable(dataView!.selectedRows)) {
      final deleted = await remover(context, dataView!.selectedRows);
      if (deleted) {
        await dataView!.delete(context);
        int removeCount = 0;
        for (int i = 0; i < dataView!.displayRows.length; i++) {
          final row = dataView!.displayRows[i];
          if (dataView!.selectedRows.contains(row)) {
            final child = _buildDeletedItemWithDecoration(context, row, true);
            animatedViewController.removeAnimation(i - removeCount, isListView, child);
            removeCount++;
          }
        }
        await dataView!.fill();
        dataView!.selectRows([]);
        animatedViewController.onAnimationDone(() {
          setDefaultSelected(context);
//              debugPrint('animated item count: ${animatedViewController.itemCount}/${dataView!.displayRows.length}');
          animatedViewController.itemCount = dataView!.displayRows.length;
          notifyListeners();
        });
      }
    }
    notifyListeners();
    debugPrint('onToggleCheckMode');
  }

  /// onNextPage called when user press next button
  Future<void> onNextPage(BuildContext context) async {
    if (dataView == null) {
      return;
    }
    if (dataView is data.PagedDataView) {
      await (dataView as data.PagedDataView).nextPage(context);
      animatedViewController.itemCount = dataView!.displayRows.length;
      animatedViewController.nextPageAnimation();
    }
    notifyListeners();
    debugPrint('onNextPage');
  }

  /// onPreviousPage called when user press previous button
  Future<void> onPreviousPage(BuildContext context) async {
    if (dataView == null) {
      return;
    }
    if (dataView is data.PagedDataView) {
      await (dataView as data.PagedDataView).prevPage(context);
      animatedViewController.itemCount = dataView!.displayRows.length;
      animatedViewController.prevPageAnimation();
    }
    notifyListeners();
    debugPrint('onPreviousPage');
  }

  /// onAdd called when user press add button
  Future<void> onAdd(BuildContext context) async {
    if (dataView == null) {
      return;
    }
    if (!isSplitView) {
      context.beamToNamed('${detailBeamName}new/');
      return;
    }

    dataView?.selectRows([]);
    newItem = await adder(context);
    animatedViewController.itemCount = dataView!.displayRows.length + 1;
    animatedViewController.insertAnimation();
    notifyListeners();
    debugPrint('onAdd');
  }

  /// onSetRowsPerPage called when user set rows per page
  Future<void> setRowsPerPage(BuildContext context, int rowsPerPage) async {
    if (dataView == null) {
      return;
    }
    await dataView?.setRowsPerPage(context, rowsPerPage);
    animatedViewController.itemCount = dataView!.displayRows.length;
    notifyListeners();
    debugPrint('onSetRowsPerPage:$rowsPerPage');
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
  Future<T?> getRowByID(String id) async => await dataView?.getRowByID(id);

  /// pageInfo return data view's page info
  String pageInfo(BuildContext context) => dataView != null ? dataView!.pageInfo(context) : '';
}
