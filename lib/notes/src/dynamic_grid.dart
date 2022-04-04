import 'package:flutter/material.dart';
import 'package:libcli/animations/animations.dart' as animations;
import 'package:libcli/delta/delta.dart' as delta;
import 'selectable.dart';
import 'selectable_grid.dart';

/// DynamicGrid is animation + refresh more, need AnimatedViewProvider
/// ```dart
///return ChangeNotifierProvider<animations.AnimatedViewProvider>(
///    create: (context) => animations.AnimatedViewProvider(),
///    child: Consumer<animations.AnimatedViewProvider>(
///        builder: (context, provide, child) => DynamicGrid<String>(
///                  headerBuilder: () => delta.SearchBox(
///                    controller: _searchBoxController,
///                  ),
///                  footerBuilder: () => Container(
///                    child: const Text('footer'),
///                    color: Colors.red,
///                  ),
///                  items: animationListItems,
///                  selectedItems: const ['b'],
///                  itemBuilder: (String item, bool isSelected) => Container(
///                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
///                    child: Text(item),
///                  ),
///                )));
/// ```
class DynamicGrid<T> extends SelectableGrid<T> {
  /// DynamicGrid is animation + refresh more, need AnimatedViewProvider
  /// ```dart
  ///return ChangeNotifierProvider<animations.AnimatedViewProvider>(
  ///    create: (context) => animations.AnimatedViewProvider(),
  ///    child: Consumer<animations.AnimatedViewProvider>(
  ///        builder: (context, provide, child) => DynamicGrid<String>(
  ///                  headerBuilder: () => delta.SearchBox(
  ///                    controller: _searchBoxController,
  ///                  ),
  ///                  footerBuilder: () => Container(
  ///                    child: const Text('footer'),
  ///                    color: Colors.red,
  ///                  ),
  ///                  items: animationListItems,
  ///                  selectedItems: const ['b'],
  ///                  itemBuilder: (String item, bool isSelected) => Container(
  ///                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
  ///                    child: Text(item),
  ///                  ),
  ///                )));
  /// ```
  const DynamicGrid({
    required List<T> items,
    required List<T> selectedItems,
    bool checkMode = false,
    void Function(List<T> items)? onItemSelected,
    void Function(List<T> items)? onItemChecked,
    Color? selectedColor,
    required ItemBuilder<T> itemBuilder,
    Widget Function()? headerBuilder,
    Widget Function()? footerBuilder,
    int crossAxisCount = 2,
    ItemBuilder<T>? labelBuilder,
    Color? selectedBorderColor,
    Color? borderColor,
    this.onRefresh,
    this.onLoadMore,
    this.controller,
    Key? key,
  }) : super(
          items: items,
          selectedItems: selectedItems,
          checkMode: checkMode,
          itemBuilder: itemBuilder,
          onItemSelected: onItemSelected,
          onItemChecked: onItemChecked,
          headerBuilder: headerBuilder,
          footerBuilder: footerBuilder,
          crossAxisCount: crossAxisCount,
          labelBuilder: labelBuilder,
          selectedBorderColor: selectedBorderColor,
          borderColor: borderColor,
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

  @override
  Widget build(BuildContext context) {
    var scrollController = controller ?? ScrollController();
    return Stack(
      fit: StackFit.expand,
      children: [
        if (items.isEmpty) const delta.NoDataDisplay(),
        delta.RefreshMoreView(
            scrollController: context.isTouchSupported ? scrollController : ScrollController(),
            onRefresh: onRefresh,
            onLoadMore: onLoadMore,
            itemCount: rowCount,
            itemBuilder: (BuildContext context, int index) {
              if (headerBuilder != null && index == 0) {
                return buildHeader(context);
              }
              if (footerBuilder != null && index == rowCount - 1) {
                return buildFooter(context);
              }

              return animations.AnimatedView(
                crossAxisCount: crossAxisCount,
                controller: context.isTouchSupported ? scrollController : ScrollController(),
                shrinkWrap: true,
                itemBuilder: (bool isListView, int index) {
                  return buildItem(context, index);
                },
              );
            })
      ],
    );
  }
}
