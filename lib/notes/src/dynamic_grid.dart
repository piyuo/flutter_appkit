import 'package:flutter/material.dart';
import 'package:libcli/delta/delta.dart' as delta;
import 'selectable.dart';

/// DynamicGrid is animation + refresh more, need AnimatedViewProvider
class DynamicGrid<T> extends Selectable<T> {
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
    required this.animateViewProvider,
    required List<T> items,
    required List<T> selectedItems,
    bool isCheckMode = false,
    void Function(T item)? onItemTapped,
    void Function(List<T> items)? onItemSelected,
    void Function(List<T> items)? onItemChecked,
    Color? selectedColor,
    required ItemBuilder<T> itemBuilder,
    ItemDecorationBuilder<T> itemDecorationBuilder = defaultGridDecorationBuilder,
    Widget Function()? headerBuilder,
    Widget Function()? footerBuilder,
    Color? selectedBorderColor,
    Color? borderColor,
    this.onRefresh,
    this.onLoadMore,
    this.scrollController,
    this.animatedViewScrollController,
    this.crossAxisCount = 2,
    T? newItem,
    bool isReady = true,
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
          creating: newItem,
          isReady: isReady,
          key: key,
        );

  /// onRefresh is the callback function when user refresh the list
  final Future<void> Function()? onRefresh;

  /// ondLoadMore is the callback function when user load more the list
  final Future<void> Function()? onLoadMore;

  /// scrollController is list scroll controller
  final ScrollController? scrollController;

  /// animateViewProvider is the provider of the animate view
  final delta.AnimateViewProvider animateViewProvider;

  /// animatedViewScrollController is animated view scroll controller inside list
  final ScrollController? animatedViewScrollController;

  /// crossAxisCount is the number of children in the cross axis.
  final int crossAxisCount;

  /// rowCount is actual row count to display
  int get rowCount {
    int count = 1;
    if (headerBuilder != null) {
      count++;
    }
    if (footerBuilder != null) {
      count++;
    }
    return count;
  }

  /// buildHeader build header in list view
  Widget buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
      child: headerBuilder!(),
    );
  }

  /// buildListFooter build footer in list view
  Widget buildFooter(BuildContext context) {
    return footerBuilder!();
  }

  @override
  Widget build(BuildContext context) {
    if (!isReady) {
      return const delta.LoadingDisplay();
    }
    return Stack(
      fit: StackFit.expand,
      children: [
        if (isReady && items.isEmpty) const Padding(padding: EdgeInsets.only(top: 80), child: delta.NoDataDisplay()),
        delta.RefreshView(
            scrollController: scrollController,
            onRefresh: onRefresh,
            onLoadMore: onLoadMore,
            child: ListView.builder(
                itemCount: rowCount,
                itemBuilder: (BuildContext context, int index) {
                  if (headerBuilder != null && index == 0) {
                    return buildHeader(context);
                  }
                  if (footerBuilder != null && index == rowCount - 1) {
                    return buildFooter(context);
                  }

                  return delta.AnimateView(
                    animateViewProvider: animateViewProvider,
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 40,
                    mainAxisSpacing: 5,
                    controller: animatedViewScrollController,
                    shrinkWrap: true,
                    itemBuilder: (int index) {
                      if (creating != null) {
                        if (index == 0) {
                          return buildItem(context, creating as T);
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
                }))
      ],
    );
  }
}
