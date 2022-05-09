import 'package:flutter/material.dart';
import 'package:libcli/animations/animations.dart' as animations;
import 'package:libcli/delta/delta.dart' as delta;
import 'selectable.dart';

/// DynamicList is animation + refresh more, need AnimatedViewProvider
/// ```dart
/// return ChangeNotifierProvider<animations.AnimatedViewProvider>(
///    create: (context) => animations.AnimatedViewProvider(),
///    child: Consumer<animations.AnimatedViewProvider>(
///        builder: (context, provide, child) => DynamicList<String>(
///                  headerBuilder: () => delta.SearchBox(
///                    controller: _searchBoxController,
///                  ),
///                  footerBuilder: () => Container(
///                    child: const Text('footer'),
///                    color: Colors.red,
///                  ),
///                  items: animationListItems,
///                  selectedItems: const ['b'],
///                  itemBuilder: (String item, bool isSelected) => Padding(
///                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
///                    child: Text(item),
///                  ),
///                )));
/// ```
class DynamicList<T> extends Selectable<T> {
  /// DynamicList is animation + refresh more, need AnimatedViewProvider
  /// ```dart
  /// return ChangeNotifierProvider<animations.AnimatedViewProvider>(
  ///    create: (context) => animations.AnimatedViewProvider(),
  ///    child: Consumer<animations.AnimatedViewProvider>(
  ///        builder: (context, provide, child) => DynamicList<String>(
  ///                  headerBuilder: () => delta.SearchBox(
  ///                    controller: _searchBoxController,
  ///                  ),
  ///                  footerBuilder: () => Container(
  ///                    child: const Text('footer'),
  ///                    color: Colors.red,
  ///                  ),
  ///                  items: animationListItems,
  ///                  selectedItems: const ['b'],
  ///                  itemBuilder: (String item, bool isSelected) => Padding(
  ///                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
  ///                    child: Text(item),
  ///                  ),
  ///                )));
  /// ```
  const DynamicList({
    required List<T> items,
    required List<T> selectedItems,
    bool isCheckMode = false,
    void Function(T item)? onItemTapped,
    void Function(List<T> items)? onItemSelected,
    void Function(List<T> items)? onItemChecked,
    Color? selectedColor,
    required ItemBuilder<T> itemBuilder,
    ItemDecorationBuilder<T> itemDecorationBuilder = defaultListDecorationBuilder,
    Widget Function()? headerBuilder,
    Widget Function()? footerBuilder,
    this.onRefresh,
    this.onLoadMore,
    this.controller,
    T? newItem,
    bool isReadyToShow = true,
    Key? key,
  }) : super(
          items: items,
          selectedItems: selectedItems,
          checkMode: isCheckMode,
          itemBuilder: itemBuilder,
          itemDecorationBuilder: itemDecorationBuilder,
          onItemTapped: onItemTapped,
          onItemSelected: onItemSelected,
          onItemChecked: onItemChecked,
          headerBuilder: headerBuilder,
          footerBuilder: footerBuilder,
          newItem: newItem,
          isReadyToShow: isReadyToShow,
          key: key,
        );

  /// onRefresh is the callback function when user refresh the list
  final Future<void> Function()? onRefresh;

  /// ondLoadMore is the callback function when user load more the list
  final Future<void> Function()? onLoadMore;

  /// An object that can be used to control the position to which this scroll
  /// view is scrolled.
  ///
  /// Must be null if [primary] is true.
  ///
  /// A [ScrollController] serves several purposes. It can be used to control
  /// the initial scroll position (see [ScrollController.initialScrollOffset]).
  /// It can be used to control whether the scroll view should automatically
  /// save and restore its scroll position in the [PageStorage] (see
  /// [ScrollController.keepScrollOffset]). It can be used to read the current
  /// scroll position (see [ScrollController.offset]), or change it (see
  /// [ScrollController.animateTo]).
  final ScrollController? controller;

  /// _rowCount is actual row count to display
  int get _rowCount {
    int count = 1;
    if (headerBuilder != null) {
      count++;
    }
    if (footerBuilder != null) {
      count++;
    }
    return count;
  }

  @override
  Widget build(BuildContext context) {
    if (!isReadyToShow) {
      return const delta.LoadingDisplay();
    }
    var scrollController = controller ?? ScrollController();
    return Stack(
      fit: StackFit.expand,
      children: [
        if (items.isEmpty) const delta.NoDataDisplay(),
        delta.RefreshMoreView(
            scrollController: context.isTouchSupported ? scrollController : ScrollController(),
            onRefresh: onRefresh,
            onLoadMore: onLoadMore,
            itemCount: _rowCount,
            itemBuilder: (BuildContext context, int index) {
              if (headerBuilder != null && index == 0) {
                return headerBuilder!();
              }

              if (footerBuilder != null && index == _rowCount - 1) {
                return footerBuilder!();
              }

              return animations.AnimatedView(
                controller: context.isTouchSupported ? scrollController : ScrollController(),
                shrinkWrap: true,
                itemBuilder: (bool isListView, int index) {
                  if (newItem != null) {
                    if (index == 0) {
                      return buildItem(context, newItem!);
                    } else {
                      index--;
                    }
                  }
                  if (index >= items.length) {
                    //new item may cause index out of range
                    return const SizedBox();
                  }
                  return buildItem(context, items[index]);
                },
              );
            })
      ],
    );
  }
}
