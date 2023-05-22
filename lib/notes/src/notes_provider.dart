import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:beamer/beamer.dart';
import 'package:libcli/delta/delta.dart' as delta;
import 'package:libcli/tools/tools.dart' as tools;
import 'package:libcli/eventbus/eventbus.dart' as eventbus;
import 'package:libcli/data/data.dart' as data;
import 'package:libcli/pb/pb.dart' as pb;
import 'selectable.dart';
import 'types.dart';
import 'note_form_controller.dart';

/// NotesProvider provide notes for notes view
class NotesProvider<T extends pb.Object> with ChangeNotifier {
  NotesProvider({
    required this.animateViewProvider,
    required this.formController,
    required this.loader,
    this.listBuilder,
    this.gridBuilder,
    this.listDecorationBuilder = defaultListDecorationBuilder,
    this.gridDecorationBuilder = defaultGridDecorationBuilder,
    this.caption,
    this.tags = const [],
    this.onTagChanged,
    this.onSearchChanged,
    this.formRoute = '', // e.g '/products', don't end with /
    required this.onSearch,
    this.onSearchBegin,
    this.onSearchEnd,
  }) {
    formController.isInView = true;
    searchTrigger = delta.SearchTrigger(
      controller: searchController,
      onSearch: onSearch,
      onSearchBegin: onSearchBegin,
      onSearchEnd: onSearchEnd,
    );
    subscription = eventbus.listen<NotesRefillEvent>((event) async {
      if (dataView != null) {
        creating = null;
        await dataView!.load();
        if (event.isNew) {
          dataView!.selectedIDs = [];
        }

        if (!event.isRemove) {
          scrollToTop();
        }
        await refill(isRemove: event.isRemove);
        notifyListeners();
      }
    });

    if (listBuilder == null) {
      isListView = false;
    }
  }

  /// formController is form controller
  NoteFormController<T> formController;

  /// listBuilder is the builder for list view
  final ItemBuilder<T>? listBuilder;

  /// gridBuilder is the builder for grid view
  final ItemBuilder<T>? gridBuilder;

  /// listDecorationBuilder is a list decoration builder
  final ItemDecorationBuilder<T> listDecorationBuilder;

  /// gridDecorationBuilder is a grid decoration builder
  final ItemDecorationBuilder<T> gridDecorationBuilder;

  /// caption on top of search box
  final String? caption;

  /// loader
  final data.DataViewLoader<T> loader;

  /// dataView data view to display data
  data.DataView<T>? dataView;

  /// refreshButtonController is refresh button controller
  final refreshButtonController = delta.RefreshButtonController();

  /// animateViewController control view animation
  final delta.AnimateViewProvider animateViewProvider;

  /// _searchController is search box controller
  final searchController = TextEditingController();

  /// tags is a list of tags to display.
  List<tools.Tag<String>> tags;

  /// hasListView return true if has list view mode
  bool get hasListView => listBuilder != null;

  /// hasGridView return true if has grid view mode
  bool get hasGridView => gridBuilder != null;

  /// isListView is true if is in list view mode
  bool isListView = true;

  /// isCheckMode is true if is in check mode
  bool isCheckMode = false;

  /// onTagChanged called when tag changed, return true if need refresh
  final Future<bool> Function(String value)? onTagChanged;

  /// onSearchChanged called when search changed, return true if need refresh
  final Future<bool> Function(String value)? onSearchChanged;

  /// creating is the new item creator
  T? creating;

  /// formRoute is the route name form, e.g '/products', don't end with /
  final String formRoute;

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

  /// of get [NotesProvider] from context
  static NotesProvider<T> of<T extends pb.Object>(BuildContext context) {
    return Provider.of<NotesProvider<T>>(context, listen: false);
  }

  /// isAllowDelete is true if allow delete
  bool get isAllowDelete => isNotEmpty;

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
  Future<void> load(bool isPreferMouse, data.Dataset<T> dataset) async {
    dataView = isPreferMouse
        ? data.PagedDataView<T>(
            dataset,
            loader: loader,
          )
        : data.ContinuousDataView<T>(
            dataset,
            loader: loader,
          );

    await dataView!.refresh();
    animateViewProvider.setLength(dataView!.displayRows.length);
    _setDefaultSelected();
    notifyListeners();
  }

  @override
  void dispose() {
    subscription?.cancel();
    searchTrigger.dispose();
    refreshButtonController.dispose();
    animateViewProvider.dispose();
    super.dispose();
  }

  /// noMore return true if dataset is no more data
  bool get noMore => dataView != null ? dataView!.noMore : true;

  /// noRefresh return true if dataset is no need refresh
  bool get noRefresh => dataView != null ? dataView!.noRefresh : true;

  /// noRefresh set to true if no need refresh dataset
  Future<void> setNoRefresh(BuildContext context, value) async => await dataView?.setNoRefresh(value);

  /// isReadyToShow return true if provider is ready to show
  bool get isReadyToShow => dataView != null;

  /// isReadyForAction return true if provider is ready to do any action
  Future<bool> isReadyForAction() async => dataView != null && await _isAllowToExit();

  /// _setDefaultSelected will select first row if no row selected
  void _setDefaultSelected({String? defaultSelectedID}) {
    if (dataView == null || dataView!.hasSelectedRows) {
      return;
    }

    if (dataView!.displayRows.isEmpty) {
      formController.loadEmpty();
      return;
    }
    var nextRow = _findRowInDisplayRowByID(defaultSelectedID);
    nextRow = nextRow ?? dataView!.displayRows.first;
    dataView!.setSelectedRows([nextRow]);
    if (isSplitView) {
      formController.loadByView(dataset: dataView!.dataset, row: nextRow);
    }
  }

  /// _findRowInDisplayRowByID find row in display row by id
  T? _findRowInDisplayRowByID(String? id) {
    if (id == null) {
      return null;
    }
    for (final row in dataView!.displayRows) {
      if (row.id == id) {
        return row;
      }
    }
    return null;
  }

  /// findNextSelected next selected row id if current selected is deleted
  /// must use id ,cause dataview will refill data when selected row is deleted, it will cause all row dispose
  String? _findNextSelectedID() {
    if (!dataView!.hasSelectedRows) {
      return null;
    }

    T? nextSelected;
    for (int i = dataView!.displayRows.length - 1; i >= 0; i--) {
      final row = dataView!.displayRows[i];
      if (dataView!.isRowSelected(row)) {
        break;
      }
      nextSelected = row;
    }
    if (nextSelected != null) {
      return nextSelected.id;
    }
    for (final row in dataView!.displayRows) {
      if (dataView!.isRowSelected(row)) {
        break;
      }
      nextSelected = row;
    }
    if (nextSelected != null) {
      return nextSelected.id;
    }
    return null;
  }

  /// _isAllowToExit return true if form controller allow to exit
  Future<bool> _isAllowToExit() async {
    if (dataView == null || !isSplitView || (!dataView!.hasSelectedRows && creating == null)) {
      return true;
    }
    final allowed = await formController.isAllowToExit();
    if (allowed == true && creating != null) {
      await _showNewItemDeleteAnimation();
    }
    return allowed;
  }

  /// onItemTapped called when user tap item
  void onItemTapped(BuildContext context, T selectedRow) {
    if (!isSplitView) {
      context.beamToNamed('$formRoute/${selectedRow.id}');
      return;
    }
  }

  /// onItemChecked called when user select item, return true if new item has been selected
  bool onItemChecked(List<T> selectedRows) {
    dataView!.setSelectedRows(selectedRows);
    notifyListeners();
    return true;
  }

  /// onItemsSelected call when user select items
  Future<void> onItemsSelected(BuildContext context, List<T> selectedRows) async {
    if (!await isReadyForAction() || selectedRows.isEmpty) {
      return;
    }

    if (isSplitView) {
      final first = selectedRows.first;
      await formController.loadByView(dataset: dataView!.dataset, row: first);
    }
    if (!onItemChecked(selectedRows)) {
      return;
    }
  }

  /// onCreateNew called when user press new button
  Future<void> onCreateNew(BuildContext context) async {
    final beamer = Beamer.of(context);
    if (!await isReadyForAction()) {
      return;
    }

    if (!await formController.isAllowToExit()) {
      return;
    }

    if (!isSplitView) {
      beamer.beamToNamed('$formRoute/_');
      return;
    }

    dataView?.selectedIDs = [];
    animateViewProvider.setLength(dataView!.displayRows.length + 1);
    animateViewProvider.insertAnimation();
    creating = await formController.loadNewByView(dataView!.dataset);
    notifyListeners();
    debugPrint('onAdd');
  }

  /// isSplitView is true if in split view
  bool get isSplitView => isListView && !delta.phoneScreen;

  /// hasNextPage return true if has next page
  bool get hasNextPage => dataView is data.PagedDataView ? (dataView as data.PagedDataView).hasNextPage : false;

  /// hasPrevPage return true if has prev page
  bool get hasPreviousPage => dataView is data.PagedDataView ? (dataView as data.PagedDataView).hasPrevPage : false;

  /// refill let dataset refill data, the data may changed or deleted
  Future<void> refill({bool isRemove = false}) async {
    if (dataView == null) {
      return;
    }
    String? defaultSelectedID;
    if (isRemove) {
      defaultSelectedID = _findNextSelectedID();
      dataView!.selectedIDs = [];
    }
    await dataView!.fill();
    _setDefaultSelected(defaultSelectedID: defaultSelectedID);
    animateViewProvider.setLength(dataView!.displayRows.length);
    notifyListeners();
  }

  /// _buildDeletedItemWithDecoration build item with decoration
  Widget _buildDeletedItemWithDecoration(T item, bool isSelected) {
    return isListView
        ? listDecorationBuilder(
            delta.globalContext,
            child: listBuilder!(delta.globalContext, item, isSelected),
            checkMode: isCheckMode,
            isSelected: isSelected,
          )
        : gridDecorationBuilder(
            delta.globalContext,
            child: gridBuilder!(delta.globalContext, item, isSelected),
            checkMode: isCheckMode,
            isSelected: isSelected,
          );
  }

  /// refresh called when user tap refresh button
  Future<void> refresh(BuildContext context) async {
    if (!await isReadyForAction()) {
      return;
    }
    final originLength = dataView!.length;
    var firstPage = true;
    if (dataView is data.PagedDataView) {
      firstPage = (dataView as data.PagedDataView).isFirstPage;
    }
    final isReset = await dataView!.refresh();
    final diff = dataView!.length - originLength;
    _setDefaultSelected();
    if (isReset || (diff > 0 && !firstPage)) {
      animateViewProvider.refreshPageAnimation(dataView!.displayRows.length);
    } else if (diff > 0) {
      if (dataView!.isDisplayRowsFullPage) {
        animateViewProvider.setLength(dataView!.rowsPerPage - diff);
      }
      for (int i = 0; i < diff; i++) {
        animateViewProvider.insertAnimation();
      }
    }
    notifyListeners();
  }

  /// loadMore called when user pull down to load more data
  Future<void> loadMore(BuildContext context) async {
    if (dataView == null) {
      return;
    }
    await dataView!.more(dataView!.rowsPerPage);
    animateViewProvider.setLength(dataView!.displayRows.length);
    notifyListeners();
    debugPrint('onMore');
  }

  /// onToggleCheckMode called when user toggle check mode
  Future<void> onToggleCheckMode(BuildContext context) async {
    if (!await isReadyForAction()) {
      return;
    }
    isCheckMode = !isCheckMode;
    if (isCheckMode) {
      dataView?.selectedIDs = [];
    } else {
      if (dataView!.displayRows.isNotEmpty) {
        dataView?.setSelectedRows([dataView!.displayRows.first]);
      }
    }
    notifyListeners();
    debugPrint('onToggleCheckMode');
  }

  /// onListView called when user set to list view
  Future<void> onListView(BuildContext context) async {
    if (!await isReadyForAction()) {
      return;
    }
    if (!isListView) {
      isListView = true;
      notifyListeners();
      debugPrint('onListView');
    }
  }

  /// onGridView called when user set to grid view
  Future<void> onGridView(BuildContext context) async {
    if (!await isReadyForAction()) {
      return;
    }
    if (isListView) {
      isListView = false;
      notifyListeners();
      debugPrint('onGridView');
    }
  }

  /// _tryRemove try to remove select item, return true if can remove
  Future<void> _tryRemove(Future<void> Function(List<T> list) callback) async {
    if (creating != null) {
      // don't ask user just delete, avoid isReadyForAction to delete creating first
      await _showNewItemDeleteAnimation();
      return;
    }

    if (!await isReadyForAction()) {
      return;
    }

    if (isCheckMode) {
      isCheckMode = false;
    }
    await callback(dataView!.getSelectedRows());
    await _showDeleteAnimation();
  }

  /// onDelete called when user press delete button
  Future<void> onDelete(BuildContext context) async => await _tryRemove(formController.deleteByView);

  /// onRestore called when user press restore button
  Future<void> onRestore(BuildContext context) async => await _tryRemove(formController.restoreByView);

  /// _showNewItemDeleteAnimation show animation remove new item from data view
  Future<void> _showNewItemDeleteAnimation() async {
    final removedItem = _buildDeletedItemWithDecoration(creating!, true);
    creating = null;
    animateViewProvider.removeAnimation(0, removedItem, isListView);
    notifyListeners();
    await animateViewProvider.waitForAnimationDone();
    animateViewProvider.setLength(dataView!.displayRows.length);
    _setDefaultSelected();
    notifyListeners();
  }

  /// _showDeleteAnimation show animation remove selected item from data view
  Future<void> _showDeleteAnimation() async {
    int removeCount = 0;
    final defaultSelectedID = _findNextSelectedID();
    for (int i = 0; i < dataView!.displayRows.length; i++) {
      final row = dataView!.displayRows[i];
      if (dataView!.isRowSelected(row)) {
        final removedItem = _buildDeletedItemWithDecoration(row, true);
        animateViewProvider.removeAnimation(i - removeCount, removedItem, isListView);
        removeCount++;
      }
    }
    dataView!.selectedIDs = [];
    notifyListeners();
    await animateViewProvider.waitForAnimationDone();
    await dataView!.fill();
    animateViewProvider.setLength(dataView!.displayRows.length);
    _setDefaultSelected(defaultSelectedID: defaultSelectedID);
    notifyListeners();
  }

  /// onNextPage called when user press next button
  Future<void> onNextPage(BuildContext context) async {
    if (!await isReadyForAction()) {
      return;
    }
    if (dataView is data.PagedDataView) {
      await (dataView as data.PagedDataView).nextPage();
      animateViewProvider.nextPageAnimation(dataView!.displayRows.length);
    }
    notifyListeners();
    debugPrint('onNextPage');
  }

  /// onPreviousPage called when user press previous button
  Future<void> onPreviousPage(BuildContext context) async {
    if (!await isReadyForAction()) {
      return;
    }
    if (dataView is data.PagedDataView) {
      await (dataView as data.PagedDataView).prevPage();
      animateViewProvider.prevPageAnimation(dataView!.displayRows.length);
    }
    notifyListeners();
    debugPrint('onPreviousPage');
  }

  /// onSetRowsPerPage called when user set rows per page
  Future<void> setRowsPerPage(BuildContext context, int rowsPerPage) async {
    if (!await isReadyForAction()) {
      return;
    }
    await dataView!.dataset.setRowsPerPage(rowsPerPage);
    animateViewProvider.setLength(dataView!.displayRows.length);
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
