import 'dart:math';
import 'package:flutter/material.dart';
import 'package:libcli/delta/delta.dart' as delta;
import 'package:libcli/utils/utils.dart' as general;
import 'package:split_view/split_view.dart';
import 'selectable.dart';
import 'dynamic_list.dart';
import 'dynamic_grid.dart';

/// GridListView show basic grid/list view with select/check function, it need [delta.RefreshButtonController]
class GridListView<T> extends StatelessWidget {
  const GridListView({
    required this.animateViewProvider,
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

  /// animateViewProvider is the provider of the animate view
  final delta.AnimateViewProvider animateViewProvider;

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
  final general.WidgetBuilder? headerBuilder;

  /// footerBuilder is the builder for footer
  final general.WidgetBuilder? footerBuilder;

  /// selectionBarBuilder build selection on bar
  final general.WidgetBuilder? selectionBarBuilder;

  /// leftBarBuilder build left part on bar
  final general.WidgetBuilder? leftBarBuilder;

  /// rightBarBuilder build right part on bar
  final general.WidgetBuilder? rightBarBuilder;

  /// touchBottomBarBuilder build bottom bar on touch mode
  final general.WidgetBuilder? touchBottomBarBuilder;

  /// mouseBottomBarBuilder build bottom bar on mouse mode
  final general.WidgetBuilder? mouseBottomBarBuilder;

  /// onRefresh called when user pull down refresh
  final general.FutureCallback<void>? onRefresh;

  /// onMore called when user pull up to load more data
  final general.FutureCallback<void>? onMore;

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
  bool get isSplitView => isListView && !delta.phoneScreen;

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
              animateViewProvider: animateViewProvider,
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
              onMore: onMore,
              headerBuilder: isCheckMode
                  ? null
                  : () => Padding(
                      padding: EdgeInsets.fromLTRB(4, !context.isPreferMouse || delta.phoneScreen ? 10 : 0, 4, 0),
                      child: headerBuilder != null ? headerBuilder!() : null),
              footerBuilder: isCheckMode ? null : footerBuilder,
              onItemTapped: (selectedItem) => onItemTapped?.call(selectedItem),
              onItemSelected: (selectedItems) => onItemSelected?.call(selectedItems),
              onItemChecked: (selectedItems) => onItemChecked?.call(selectedItems),
            ),
          ),
        ),
        if (touchBottomBarBuilder != null && delta.phoneScreen && !context.isPreferMouse && !isCheckMode)
          touchBottomBarBuilder!(),
        if (mouseBottomBarBuilder != null && delta.phoneScreen && context.isPreferMouse && !isCheckMode)
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
                delta.notPhoneScreen)
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
                      animateViewProvider: animateViewProvider,
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
                      onMore: onMore,
                      headerBuilder: () => Padding(
                          padding: EdgeInsets.only(
                              top: context.isPreferMouse && !isCheckMode && delta.notPhoneScreen ? 0 : 10),
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
            if (touchBottomBarBuilder != null && delta.phoneScreen && !context.isPreferMouse && !isCheckMode)
              touchBottomBarBuilder!(),
            if (mouseBottomBarBuilder != null && delta.phoneScreen && context.isPreferMouse && !isCheckMode)
              mouseBottomBarBuilder!(),
          ],
        );
      }

      if (!isSplitView) {
        return buildList(context);
      }

      final colorScheme = Theme.of(context).colorScheme;
      return Column(children: [
        if (selectionBarBuilder != null && isCheckMode) selectionBarBuilder!(),
        Expanded(
            child: SplitView(
          gripSize: 5,
          gripColor: colorScheme.outlineVariant.withOpacity(.2),
          gripColorActive: colorScheme.outlineVariant.withOpacity(.5),
          controller: SplitViewController(
            weights: [0.35],
            limits: [WeightLimit(min: 0.25, max: 0.45)],
          ),
          viewMode: SplitViewMode.Horizontal,
          indicator: SplitIndicator(
            viewMode: SplitViewMode.Horizontal,
            color: colorScheme.outlineVariant.withOpacity(.9),
          ),
          activeIndicator: SplitIndicator(
            viewMode: SplitViewMode.Horizontal,
            isActive: true,
            color: colorScheme.outlineVariant,
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
        ))
      ]);
    });
  }
}
