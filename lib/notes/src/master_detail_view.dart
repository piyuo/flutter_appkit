import 'dart:math';
import 'package:flutter/material.dart';
import 'package:libcli/delta/delta.dart' as delta;
import 'package:libcli/i18n/i18n.dart' as i18n;
import 'package:libcli/responsive/responsive.dart' as responsive;
import 'package:split_view/split_view.dart';
import 'selectable.dart';
import 'dynamic_list.dart';
import 'dynamic_grid.dart';
import 'checkable_header.dart';

/// MasterDetailViewAction is the action that that MasterDetailView generates
enum MasterDetailViewAction {
  refresh,
  more,
  refill, // refill dataset
  listView,
  gridView,
  delete,
  add,
  toggleCheckMode,
  previousPage,
  nextPage,
  rows10,
  rows20,
  rows50
}

class MasterDetailView<T> extends StatelessWidget {
  /// MasterDetailView show basic master detail view with select/check function, it need [delta.RefreshButtonController]
  const MasterDetailView({
    required this.listBuilder,
    required this.gridBuilder,
    required this.detailBuilder,
    required this.items,
    required this.selectedItems,
    required this.onBarAction,
    this.gridLabelBuilder,
    this.headerBuilder,
    this.footerBuilder,
    this.isLoading = false,
    this.onItemSelected,
    this.onItemChecked,
    this.onShowDetail,
    this.gridItemWidth = 240,
    this.information,
    this.hasNextPage = true,
    this.hasPrevPage = true,
    this.isCheckMode = false,
    this.isListView = true,
    this.supportRefresh = true,
    this.supportLoadMore = true,
    this.gridItemBackgroundColor,
    this.deleteLabel,
    this.deleteIcon,
    Key? key,
  }) : super(key: key);

  /// items is the list of data to be displayed
  final List<T> items;

  /// selectedItems is the list of selected items
  final List<T> selectedItems;

  /// listBuilder is the builder for list view
  final ItemBuilder<T> listBuilder;

  /// gridBuilder is the builder for grid view
  final ItemBuilder<T> gridBuilder;

  /// gridItemWidth is the width of grid item
  final int gridItemWidth;

  /// gridItemBackgroundColor is the background color of grid item
  final Color? gridItemBackgroundColor;

  /// labelBuilder is the builder for label in grid view
  final ItemBuilder<T>? gridLabelBuilder;

  /// detailBuilder is the builder for detail view
  final Widget Function(T) detailBuilder;

  /// headerBuilder is the builder for header
  final Widget Function()? headerBuilder;

  /// footerBuilder is the builder for footer
  final Widget Function()? footerBuilder;

  /// isLoading is the flag to indicate if loading
  final bool isLoading;

  /// pagingInfo is current page info if not in phone design
  final String? information;

  /// onItemSelected is the callback for item selected
  final void Function(List<T> items)? onItemSelected;

  /// onItemChecked is the callback for item checked
  final void Function(List<T> items)? onItemChecked;

  /// onShowDetail is the callback for navigate to detail view
  final void Function(T)? onShowDetail;

  /// onBarAction is the callback for bar action
  final Future<void> Function(MasterDetailViewAction) onBarAction;

  /// nextPageEnabled is the flag to indicate if next page is enabled
  final bool hasNextPage;

  /// prevPageEnabled is the flag to indicate if prev page is enabled
  final bool hasPrevPage;

  /// checkMode is a boolean value that indicates whether the list is in check mode
  final bool isCheckMode;

  /// isListView is true will use list view
  final bool isListView;

  /// isGridView return true if it's grid view
  bool get isGridView => !isListView;

  /// supportRefresh is true will support refresh in pull refresh list
  final bool supportRefresh;

  /// supportLoadMore is true will support load more in pull refresh list
  final bool supportLoadMore;

  /// isSplitView is true if in split view
  bool get isSplitView => isListView && !responsive.phoneScreen;

  /// deleteLabel is the label for delete button
  final String? deleteLabel;

  /// deleteIcon is the icon for delete button
  final IconData? deleteIcon;

  /// buildList build list and split view
  Widget buildList(BuildContext context) {
    return Column(
      children: [
        if (isCheckMode && !isSplitView) _buildSelectionHeader(context),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: DynamicList<T>(
              checkMode: isCheckMode,
              items: items,
              selectedItems: selectedItems,
              itemBuilder: listBuilder,
              onRefresh: supportRefresh ? () => onBarAction.call(MasterDetailViewAction.refresh) : null,
              onLoadMore: supportLoadMore ? () => onBarAction.call(MasterDetailViewAction.more) : null,
              headerBuilder: isCheckMode
                  ? null
                  : () => Padding(
                      padding: EdgeInsets.fromLTRB(4, !context.isPreferMouse || responsive.phoneScreen ? 10 : 0, 4, 0),
                      child: headerBuilder != null ? headerBuilder!() : null),
              footerBuilder: isCheckMode ? null : footerBuilder,
              onItemSelected: (selectedItems) {
                if (!isSplitView) {
                  onShowDetail?.call(selectedItems[0]);
                }
                onItemSelected?.call(selectedItems);
              },
              onItemChecked: (selectedItems) => onItemChecked?.call(selectedItems),
            ),
          ),
        ),
        if (responsive.phoneScreen && !context.isPreferMouse && !isCheckMode) _buildBottomTouchBar(context),
        if (responsive.phoneScreen && context.isPreferMouse && !isCheckMode) _buildBottomMouseBar(context),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
      if (isLoading) {
        return const delta.LoadingDisplay();
      }
      if (isGridView) {
        return Column(
          children: [
            if (isCheckMode) _buildSelectionHeader(context),
            if (context.isPreferMouse && !isCheckMode && responsive.notPhoneScreen)
              Row(
                children: [
                  SizedBox(width: 272, child: _buildLeftBar(context)),
                  const SizedBox(height: 30, child: VerticalDivider(color: Colors.grey)),
                  Expanded(child: _buildRightBar(context)),
                ],
              ),
            Expanded(
                child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: DynamicGrid<T>(
                      itemBackgroundColor: gridItemBackgroundColor,
                      crossAxisCount: max(constraints.maxWidth ~/ gridItemWidth, 2),
                      isCheckMode: isCheckMode,
                      items: items,
                      selectedItems: selectedItems,
                      itemBuilder: gridBuilder,
                      labelBuilder: gridLabelBuilder,
                      onRefresh: supportRefresh ? () => onBarAction.call(MasterDetailViewAction.refresh) : null,
                      onLoadMore: supportLoadMore ? () => onBarAction.call(MasterDetailViewAction.more) : null,
                      headerBuilder: () => Padding(
                          padding: EdgeInsets.only(
                              top: context.isPreferMouse && !isCheckMode && responsive.notPhoneScreen ? 0 : 10),
                          child: isCheckMode
                              ? null
                              : headerBuilder != null
                                  ? headerBuilder!()
                                  : null),
                      footerBuilder: isCheckMode ? null : footerBuilder,
                      onItemSelected: (selectedItems) {
                        onShowDetail?.call(selectedItems[0]);
                        onItemSelected?.call(selectedItems);
                      },
                      onItemChecked: (selectedItems) => onItemChecked?.call(selectedItems),
                    ))),
            if (responsive.phoneScreen && !context.isPreferMouse && !isCheckMode) _buildBottomTouchBar(context),
            if (responsive.phoneScreen && context.isPreferMouse && !isCheckMode) _buildBottomMouseBar(context),
          ],
        );
      }

      if (!isSplitView) {
        return buildList(context);
      }

      final activeItem = selectedItems.isEmpty
          ? items.isEmpty
              ? null
              : items[0]
          : selectedItems[0];

      return Column(children: [
        if (isCheckMode) _buildSelectionHeader(context),
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
                if (!isCheckMode && context.isPreferMouse) _buildLeftBar(context),
                Expanded(
                  child: buildList(context),
                ),
              ],
            ),
            Column(
              children: [
                if (!isCheckMode && context.isPreferMouse) _buildRightBar(context),
                if (activeItem != null)
                  Expanded(
                    child: detailBuilder(activeItem),
                  )
              ],
            ),
          ],
          //onWeightChanged: (w) => onSplitViewResized?.call(constraints.maxWidth * w[0]!),
        ))
      ]);
    });
  }

  /// _buildSelectionHeader in selection view
  Widget _buildSelectionHeader(BuildContext context) {
    return CheckableHeader(
      selectedItemCount: selectedItems.length,
      isAllSelected: selectedItems.length == items.length,
      onSelectAll: () => onItemChecked?.call(items),
      onUnselectAll: () => onItemChecked?.call([]),
      onCancel: () => onBarAction.call(MasterDetailViewAction.toggleCheckMode),
      actions: [
        if (deleteLabel != null)
          TextButton.icon(
            style: TextButton.styleFrom(
              primary: Colors.grey.shade900,
            ),
            label: Text(deleteLabel!),
            icon: Icon(deleteIcon ?? Icons.delete),
            onPressed: () async {
              await onBarAction.call(MasterDetailViewAction.toggleCheckMode);
              await onBarAction.call(MasterDetailViewAction.delete);
            },
          ),
      ],
    );
  }

  /// _buildLeftBar in split view
  Widget _buildLeftBar(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 10),
        delta.RefreshButton(
          onPressed: () async => await onBarAction(MasterDetailViewAction.refresh),
        ),
        Expanded(
          child: responsive.Toolbar<MasterDetailViewAction>(
            onPressed: (action) => onBarAction.call(action),
            items: [
              responsive.ToolButton(
                label: context.i18n.notesViewAsListLabel,
                icon: Icons.view_headline,
                value: MasterDetailViewAction.listView,
                active: isListView,
              ),
              responsive.ToolButton(
                label: context.i18n.notesViewAsGridLabel,
                icon: Icons.grid_view,
                value: MasterDetailViewAction.gridView,
                active: !isListView,
                space: 10,
              ),
              responsive.ToolButton(
                label: context.i18n.notesSelectButtonLabel,
                icon: Icons.check_circle_outline,
                value: MasterDetailViewAction.toggleCheckMode,
              ),
              responsive.ToolSpacer(),
              if (deleteLabel != null)
                responsive.ToolButton(
                  label: deleteLabel!,
                  icon: deleteIcon ?? Icons.delete,
                  value: MasterDetailViewAction.delete,
                ),
            ],
          ),
        ),
      ],
    );
  }

  /// _buildPaginator build paginator
  List<responsive.ToolItem<MasterDetailViewAction>> _buildPaginator(BuildContext context) {
    final MaterialLocalizations localizations = MaterialLocalizations.of(context);
    return [
      if (information != null)
        responsive.ToolSelection<MasterDetailViewAction>(
          width: 180,
          label: localizations.rowsPerPageTitle,
          text: information!,
          selection: {
            MasterDetailViewAction.rows10: context.i18n.notesRowsPerPage.replace1('10'),
            MasterDetailViewAction.rows20: context.i18n.notesRowsPerPage.replace1('20'),
            MasterDetailViewAction.rows50: context.i18n.notesRowsPerPage.replace1('50'),
          },
        ),
      responsive.ToolButton(
        label: localizations.previousPageTooltip,
        icon: Icons.chevron_left,
        value: hasPrevPage ? MasterDetailViewAction.previousPage : null,
      ),
      responsive.ToolButton(
        label: localizations.nextPageTooltip,
        icon: Icons.chevron_right,
        value: hasNextPage ? MasterDetailViewAction.nextPage : null,
      ),
    ];
  }

  /// _buildRightBar in split view
  Widget _buildRightBar(BuildContext context) {
    return responsive.Toolbar<MasterDetailViewAction>(
      onPressed: onBarAction,
      items: [
        responsive.ToolButton(
          label: context.i18n.notesNewButtonLabel,
          icon: Icons.add,
          value: MasterDetailViewAction.add,
        ),
        if (items.isNotEmpty) responsive.ToolSpacer(),
        if (items.isNotEmpty) ..._buildPaginator(context),
      ],
    );
  }

  /// _buildBottomTouchBar build list bottom bar for touch device
  Widget _buildBottomTouchBar(BuildContext context) {
    final buttonStyle = TextStyle(
      fontSize: 15,
      color: Colors.orange.shade700,
    );
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 18),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        color: context.themeColor(light: Colors.grey.shade100, dark: Colors.grey.shade800),
      ),
      child: Row(children: [
        TextButton(
          child: Text(context.i18n.notesSelectButtonLabel, style: buttonStyle),
          style: isCheckMode
              ? ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    context.themeColor(light: Colors.grey.shade300, dark: Colors.grey.shade900),
                  ),
                )
              : null,
          onPressed: () async => await onBarAction.call(MasterDetailViewAction.toggleCheckMode),
        ),
        information != null
            ? Expanded(
                child: Text(information!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: context.themeColor(light: Colors.grey.shade600, dark: Colors.grey.shade400),
                    )),
              )
            : const Spacer(),
        TextButton(
          child: Text(context.i18n.notesNewButtonLabel, style: buttonStyle),
          onPressed: () => onBarAction.call(MasterDetailViewAction.add),
        ),
      ]),
    );
  }

  Widget _buildBottomMouseBar(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 18),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          color: context.themeColor(light: Colors.grey.shade100, dark: Colors.grey.shade800),
        ),
        child: responsive.Toolbar<MasterDetailViewAction>(
          mainAxisAlignment: MainAxisAlignment.center,
          onPressed: onBarAction,
          items: [
            if (items.isNotEmpty) ..._buildPaginator(context),
          ],
        ));
  }
}
