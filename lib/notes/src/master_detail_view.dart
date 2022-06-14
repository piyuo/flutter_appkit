import 'dart:math';
import 'package:flutter/material.dart';
import 'package:libcli/delta/delta.dart' as delta;
import 'package:libcli/responsive/responsive.dart' as responsive;
import 'package:split_view/split_view.dart';
import 'selectable.dart';
import 'dynamic_list.dart';
import 'dynamic_grid.dart';

class MasterDetailView<T> extends StatelessWidget {
  /// MasterDetailView show basic master detail view with select/check function, it need [delta.RefreshButtonController]
  const MasterDetailView({
    required this.contentBuilder,
    required this.items,
    required this.selectedItems,
    this.listBuilder,
    this.listDecorationBuilder = defaultListDecorationBuilder,
    this.gridDecorationBuilder = defaultGridDecorationBuilder,
    this.gridBuilder,
    this.leftBarBuilder,
    this.rightBarBuilder,
    this.touchBottomBarBuilder,
    this.mouseBottomBarBuilder,
    this.selectionBarBuilder,
    this.headerBuilder,
    this.footerBuilder,
    this.onRefresh,
    this.onMore,
    this.onItemTapped,
    this.onItemSelected,
    this.onItemChecked,
    this.gridItemWidth = 240,
    this.isCheckMode = false,
    this.isListView = true,
    this.creating,
    this.isReady = true,
    this.gridScrollController,
    this.listScrollController,
    this.gridAnimatedViewScrollController,
    this.listAnimatedViewScrollController,
    Key? key,
  }) : super(key: key);

  /// items is the list of data to be displayed
  final List<T> items;

  /// selectedItems is the list of selected items
  final List<T> selectedItems;

  /// creating is not null mean user is editing a new item
  final T? creating;

  /// listScrollController is scroll controller for list
  final ScrollController? listScrollController;

  /// listAnimatedViewScrollController is animated view scroll controller for list
  final ScrollController? listAnimatedViewScrollController;

  /// gridScrollController is scroll controller for grid
  final ScrollController? gridScrollController;

  /// gridAnimatedViewScrollController is animated view scroll controller for grid
  final ScrollController? gridAnimatedViewScrollController;

  /// listBuilder is the builder for list view
  final ItemBuilder<T>? listBuilder;

  /// listDecorationBuilder is a list decoration builder
  final ItemDecorationBuilder<T> listDecorationBuilder;

  /// gridBuilder is the builder for grid view
  final ItemBuilder<T>? gridBuilder;

  /// gridDecorationBuilder is a grid decoration builder
  final ItemDecorationBuilder<T> gridDecorationBuilder;

  /// gridItemWidth is the width of grid item
  final int gridItemWidth;

  /// contentBuilder is the builder for content
  final Widget Function() contentBuilder;

  /// headerBuilder is the builder for header
  final delta.WidgetBuilder? headerBuilder;

  /// footerBuilder is the builder for footer
  final delta.WidgetBuilder? footerBuilder;

  /// selectionBarBuilder build selection on bar
  final delta.WidgetBuilder? selectionBarBuilder;

  /// leftBarBuilder build left part on bar
  final delta.WidgetBuilder? leftBarBuilder;

  /// rightBarBuilder build right part on bar
  final delta.WidgetBuilder? rightBarBuilder;

  /// touchBottomBarBuilder build bottom bar on touch mode
  final delta.WidgetBuilder? touchBottomBarBuilder;

  /// mouseBottomBarBuilder build bottom bar on mouse mode
  final delta.WidgetBuilder? mouseBottomBarBuilder;

  /// onRefresh called when user pull down refresh
  final delta.FutureCallback<void>? onRefresh;

  /// onMore called when user pull up to load more data
  final delta.FutureCallback<void>? onMore;

  /// onItemTapped is callback when item is tapped
  final void Function(T item)? onItemTapped;

  /// onItemSelected is the callback for item selected
  final void Function(List<T> items)? onItemSelected;

  /// onItemChecked is the callback for item checked
  final void Function(List<T> items)? onItemChecked;

  /// checkMode is a boolean value that indicates whether the list is in check mode
  final bool isCheckMode;

  /// isListView is true will use list view
  final bool isListView;

  /// isGridView return true if it's grid view
  bool get isGridView => !isListView;

  /// isSplitView is true if in split view
  bool get isSplitView => isListView && !responsive.phoneScreen;

  /// isReady is true mean list is ready to show
  final bool isReady;

  /// buildList build list and split view
  Widget buildList(BuildContext context) {
    return Column(
      children: [
        if (selectionBarBuilder != null && isCheckMode && !isSplitView) selectionBarBuilder!(),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: DynamicList<T>(
              scrollController: listScrollController,
              animatedViewScrollController: listAnimatedViewScrollController,
              isReady: isReady,
              isCheckMode: isCheckMode,
              creating: creating,
              items: items,
              selectedItems: selectedItems,
              itemBuilder: listBuilder!,
              itemDecorationBuilder: listDecorationBuilder,
              onRefresh: onRefresh,
              onLoadMore: onMore,
              headerBuilder: isCheckMode
                  ? null
                  : () => Padding(
                      padding: EdgeInsets.fromLTRB(4, !context.isPreferMouse || responsive.phoneScreen ? 10 : 0, 4, 0),
                      child: headerBuilder != null ? headerBuilder!() : null),
              footerBuilder: isCheckMode ? null : footerBuilder,
              onItemTapped: (selectedItem) => onItemTapped?.call(selectedItem),
              onItemSelected: (selectedItems) => onItemSelected?.call(selectedItems),
              onItemChecked: (selectedItems) => onItemChecked?.call(selectedItems),
            ),
          ),
        ),
        if (touchBottomBarBuilder != null && responsive.phoneScreen && !context.isPreferMouse && !isCheckMode)
          touchBottomBarBuilder!(),
        if (mouseBottomBarBuilder != null && responsive.phoneScreen && context.isPreferMouse && !isCheckMode)
          mouseBottomBarBuilder!(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
      if (isGridView) {
        return Column(
          children: [
            if (selectionBarBuilder != null && isCheckMode) selectionBarBuilder!(),
            if (rightBarBuilder != null &&
                leftBarBuilder != null &&
                context.isPreferMouse &&
                !isCheckMode &&
                responsive.notPhoneScreen)
              Row(
                children: [
                  SizedBox(width: 300, child: leftBarBuilder!()),
                  const SizedBox(height: 30, child: VerticalDivider(color: Colors.grey)),
                  Expanded(child: rightBarBuilder!()),
                ],
              ),
            Expanded(
                child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: DynamicGrid<T>(
                      scrollController: gridScrollController,
                      animatedViewScrollController: gridAnimatedViewScrollController,
                      crossAxisCount: max(constraints.maxWidth ~/ gridItemWidth, 2),
                      isReady: isReady,
                      isCheckMode: isCheckMode,
                      newItem: creating,
                      items: items,
                      selectedItems: selectedItems,
                      itemBuilder: gridBuilder!,
                      itemDecorationBuilder: gridDecorationBuilder,
                      onRefresh: onRefresh,
                      onLoadMore: onMore,
                      headerBuilder: () => Padding(
                          padding: EdgeInsets.only(
                              top: context.isPreferMouse && !isCheckMode && responsive.notPhoneScreen ? 0 : 10),
                          child: isCheckMode
                              ? null
                              : headerBuilder != null
                                  ? headerBuilder!()
                                  : null),
                      footerBuilder: isCheckMode ? null : footerBuilder,
                      onItemTapped: (selectedItem) => onItemTapped?.call(selectedItem),
                      onItemSelected: (selectedItems) => onItemSelected?.call(selectedItems),
                      onItemChecked: (selectedItems) => onItemChecked?.call(selectedItems),
                    ))),
            if (touchBottomBarBuilder != null && responsive.phoneScreen && !context.isPreferMouse && !isCheckMode)
              touchBottomBarBuilder!(),
            if (mouseBottomBarBuilder != null && responsive.phoneScreen && context.isPreferMouse && !isCheckMode)
              mouseBottomBarBuilder!(),
          ],
        );
      }

      if (!isSplitView) {
        return buildList(context);
      }

/*      final activeItem = (newItem != null)
          ? newItem
          : selectedItems.isEmpty
              ? items.isEmpty
                  ? null
                  : items[0]
              : selectedItems[0];*/

      return Column(children: [
        if (selectionBarBuilder != null && isCheckMode) selectionBarBuilder!(),
        Expanded(
            child: SplitView(
          gripSize: 5,
          gripColor: context.themeColor(
            light: Colors.grey.shade100,
            dark: Colors.grey.shade800,
          ),
          gripColorActive: context.themeColor(
            light: Colors.grey.shade300,
            dark: Colors.grey.shade800,
          ),
          controller: SplitViewController(
            weights: [0.35],
            limits: [WeightLimit(min: 0.25, max: 0.45)],
          ),
          viewMode: SplitViewMode.Horizontal,
          indicator: SplitIndicator(
              viewMode: SplitViewMode.Horizontal,
              color: context.themeColor(
                light: Colors.grey.shade400,
                dark: Colors.grey,
              )),
          activeIndicator: const SplitIndicator(
            viewMode: SplitViewMode.Horizontal,
            isActive: true,
            color: Colors.grey,
          ),
          children: [
            Column(
              children: [
                if (leftBarBuilder != null && !isCheckMode && context.isPreferMouse) leftBarBuilder!(),
                Expanded(
                  child: buildList(context),
                ),
              ],
            ),
            Column(
              children: [
                if (rightBarBuilder != null && !isCheckMode && context.isPreferMouse) rightBarBuilder!(),
                Expanded(
                  child: contentBuilder(),
                )
              ],
            ),
          ],
          //onWeightChanged: (w) => onSplitViewResized?.call(constraints.maxWidth * w[0]!),
        ))
      ]);
    });
  }
}
