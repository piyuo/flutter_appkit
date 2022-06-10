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
import 'selectable.dart';
import 'types.dart';
import 'note_form_controller.dart';

/// NotesProvider provide notes for notes view
class NotesProvider<T extends pb.Object> with ChangeNotifier {
  NotesProvider({
    required this.formControllerBuilder,
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
    searchTrigger = delta.SearchTrigger(
      controller: searchController,
      onSearch: onSearch,
      onSearchBegin: onSearchBegin,
      onSearchEnd: onSearchEnd,
    );
    subscription = eventbus.listen<NotesRefillEvent>((BuildContext context, event) async {
      if (dataView != null) {
        creating = null;
        await dataView!.load(context);
        await refill(context);
        scrollToTop();
        notifyListeners();
      }
    });

    if (listBuilder == null) {
      isListView = false;
    }
  }

  /// formControllerBuilder return form controller
  NoteFormController<T> Function(BuildContext) formControllerBuilder;

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
  final animateViewController = animations.AnimateViewProvider(0);

  /// _searchController is search box controller
  final searchController = TextEditingController();

  /// tags is a list of tags to display.
  List<Tag<String>> tags;

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
            loader: loader,
          )
        : data.ContinuousDataView<T>(
            dataset,
            loader: loader,
          );

    await dataView!.refresh(context);
    animateViewController.itemCount = dataView!.displayRows.length;
    setDefaultSelected(context);
    notifyListeners();
  }

  @override
  void dispose() {
    subscription?.cancel();
    searchTrigger.dispose();
    refreshButtonController.dispose();
    animateViewController.dispose();
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
      final first = dataView!.displayRows.first;
      dataView!.selectRows([first]);
      formControllerBuilder(context).loadByView(context, dataset: dataView!.dataset, row: first);
    }
  }

  /// isReadyToShow return true if provider is ready to show
  bool get isReadyToShow => dataView != null;

  /// isReadyForAction return true if provider is ready to do any action
  Future<bool> isReadyForAction(context) async => dataView != null && await _allowToExit(context);

  /// _allowToExit return true if form controller allow to exit
  Future<bool> _allowToExit(context) async {
    if (dataView == null || dataView!.selectedRows.isEmpty || !isSplitView) {
      return true;
    }
    final result = await formControllerBuilder(context).allowToExit(context);
    if (result == true && creating != null) {
      creating = null;
    }
    return result;
  }

  /// onItemTapped called when user tap item
  void onItemTapped(BuildContext context, T selectedRow) {
    if (!isSplitView) {
      context.beamToNamed('$formRoute/${selectedRow.id}');
      return;
    }
  }

  /// onItemChecked called when user select item, return true if new item has been selected
  bool onItemChecked(BuildContext context, List<T> selectedRows) {
    dataView!.selectRows(selectedRows);
    notifyListeners();
    return true;
  }

  /// onItemsSelected call when user select items
  Future<void> onItemsSelected(BuildContext context, List<T> selectedRows) async {
    if (!await isReadyForAction(context) || selectedRows.isEmpty) {
      return;
    }

    final first = selectedRows.first;
    await formControllerBuilder(context).loadByView(context, dataset: dataView!.dataset, row: first);
    if (!onItemChecked(context, selectedRows)) {
      return;
    }
  }

  /// onCreateNew called when user press new button
  Future<void> onCreateNew(BuildContext context) async {
    if (!await isReadyForAction(context)) {
      return;
    }

    if (!await formControllerBuilder(context).allowToExit(context)) {
      return;
    }

    if (!isSplitView) {
      context.beamToNamed('$formRoute/_');
      return;
    }

    dataView?.selectRows([]);
    creating = await formControllerBuilder(context).creator(context);
    animateViewController.itemCount = dataView!.displayRows.length + 1;
    animateViewController.insertAnimation();
    await formControllerBuilder(context).loadByView(context, dataset: dataView!.dataset, row: creating!);
    notifyListeners();
    debugPrint('onAdd');
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
    setDefaultSelected(context);
    animateViewController.itemCount = dataView!.displayRows.length;
    notifyListeners();
  }

  /// _buildDeletedItemWithDecoration build item with decoration
  Widget _buildDeletedItemWithDecoration(BuildContext context, T item, bool isSelected) {
    return isListView
        ? listDecorationBuilder(
            context,
            child: listBuilder!(context, item, isSelected),
            checkMode: isCheckMode,
            isSelected: isSelected,
          )
        : gridDecorationBuilder(
            context,
            child: gridBuilder!(context, item, isSelected),
            checkMode: isCheckMode,
            isSelected: isSelected,
          );
  }

  /// refresh called when user tap refresh button
  Future<void> refresh(BuildContext context) async {
    if (!await isReadyForAction(context)) {
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
      animateViewController.refreshPageAnimation();
      animateViewController.itemCount = dataView!.displayRows.length;
    } else if (diff > 0) {
      if (dataView!.isDisplayRowsFullPage) {
        animateViewController.itemCount = dataView!.rowsPerPage - diff;
      }
      for (int i = 0; i < diff; i++) {
        animateViewController.insertAnimation();
      }
    }
    notifyListeners();
  }

  /// loadMore called when user pull down to load more data
  Future<void> loadMore(BuildContext context) async {
    if (dataView == null) {
      return;
    }
    await dataView!.more(context, dataView!.rowsPerPage);
    animateViewController.itemCount = dataView!.displayRows.length;
    notifyListeners();
    debugPrint('onMore');
  }

  /// onToggleCheckMode called when user toggle check mode
  Future<void> onToggleCheckMode(BuildContext context) async {
    if (!await isReadyForAction(context)) {
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
  Future<void> onListView(BuildContext context) async {
    if (!await isReadyForAction(context)) {
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
    if (!await isReadyForAction(context)) {
      return;
    }
    if (isListView) {
      isListView = false;
      notifyListeners();
      debugPrint('onGridView');
    }
  }

  /// onDelete called when user press delete button
  Future<void> onDelete(BuildContext context) async {
    if (!await isReadyForAction(context)) {
      return;
    }

    if (isCheckMode) {
      isCheckMode = false;
    }
    //await formControllerBuilder(context).delete(context, dataView!.selectedRows);
    await _showDeleteAnimation(context);
  }

  /// onArchive called when user press archive button
  Future<void> onArchive(BuildContext context) async {
    if (!await isReadyForAction(context)) {
      return;
    }
    if (isCheckMode) {
      isCheckMode = false;
    }
    await formControllerBuilder(context).archive(context, dataView!.selectedRows);
    await _showDeleteAnimation(context);
  }

  /// onRestore called when user press restore button
  Future<void> onRestore(BuildContext context) async {
    if (!await isReadyForAction(context)) {
      return;
    }
    if (isCheckMode) {
      isCheckMode = false;
    }
    await formControllerBuilder(context).restore(context, dataView!.selectedRows);
    await _showDeleteAnimation(context);
  }

  /// _showDeleteAnimation delete selected item from data view
  Future<void> _showDeleteAnimation(BuildContext context) async {
    int removeCount = 0;
    for (int i = 0; i < dataView!.displayRows.length; i++) {
      final row = dataView!.displayRows[i];
      if (dataView!.selectedRows.contains(row)) {
        final removedItem = _buildDeletedItemWithDecoration(context, row, true);
        animateViewController.removeAnimation(i - removeCount, isListView, removedItem);
        removeCount++;
      }
    }
    await dataView!.fill();
    dataView!.selectRows([]);
    await animateViewController.waitForAnimationDone();
    setDefaultSelected(context);
    animateViewController.itemCount = dataView!.displayRows.length;
    notifyListeners();
  }

  /// onNextPage called when user press next button
  Future<void> onNextPage(BuildContext context) async {
    if (!await isReadyForAction(context)) {
      return;
    }
    if (dataView is data.PagedDataView) {
      await (dataView as data.PagedDataView).nextPage(context);
      animateViewController.itemCount = dataView!.displayRows.length;
      animateViewController.nextPageAnimation();
    }
    notifyListeners();
    debugPrint('onNextPage');
  }

  /// onPreviousPage called when user press previous button
  Future<void> onPreviousPage(BuildContext context) async {
    if (!await isReadyForAction(context)) {
      return;
    }
    if (dataView is data.PagedDataView) {
      await (dataView as data.PagedDataView).prevPage(context);
      animateViewController.itemCount = dataView!.displayRows.length;
      animateViewController.prevPageAnimation();
    }
    notifyListeners();
    debugPrint('onPreviousPage');
  }

  /// onSetRowsPerPage called when user set rows per page
  Future<void> setRowsPerPage(BuildContext context, int rowsPerPage) async {
    if (!await isReadyForAction(context)) {
      return;
    }
    await dataView!.dataset.setRowsPerPage(context, rowsPerPage);
    animateViewController.itemCount = dataView!.displayRows.length;
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
