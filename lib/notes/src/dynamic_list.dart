import 'package:flutter/material.dart';
import 'package:libcli/delta/delta.dart' as delta;
import 'selectable.dart';

/// DynamicList is animation + refresh more, need AnimatedViewProvider
class DynamicList<T> extends Selectable<T> {
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
    required this.animateViewProvider,
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
    this.scrollController,
    this.animatedViewScrollController,
    T? creating,
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
          creating: creating,
          isReady: isReady,
          key: key,
        );

  /// animateViewProvider is the provider of the animate view
  final delta.AnimateViewProvider animateViewProvider;

  /// onRefresh is the callback function when user refresh the list
  final Future<void> Function()? onRefresh;

  /// ondLoadMore is the callback function when user load more the list
  final Future<void> Function()? onLoadMore;

  /// scrollController is list scroll controller
  final ScrollController? scrollController;

  /// animatedViewScrollController is animated view scroll controller inside list
  final ScrollController? animatedViewScrollController;

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
    return Stack(
      fit: StackFit.expand,
      children: [
        if (isReady && items.isEmpty && creating == null)
          const Padding(padding: EdgeInsets.only(top: 80), child: delta.NoDataDisplay()),
        delta.PullRefresh(
            scrollController: scrollController,
            onRefresh: onRefresh,
            onLoadMore: onLoadMore,
            child: ListView.builder(
                controller: scrollController,
                itemCount: _rowCount,
                itemBuilder: (BuildContext context, int index) {
                  if (headerBuilder != null && index == 0) {
                    return headerBuilder!();
                  }

                  if (footerBuilder != null && index == _rowCount - 1) {
                    return footerBuilder!();
                  }

                  if (!isReady) {
                    return const delta.LoadingDisplay();
                  }

                  return delta.AnimateView(
                    animateViewProvider: animateViewProvider,
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
