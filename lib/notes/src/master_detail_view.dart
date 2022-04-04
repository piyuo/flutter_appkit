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
  listView,
  gridView,
  delete,
  archive,
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
    this.labelBuilder,
    this.headerBuilder,
    this.footerBuilder,
    this.isLoading = false,
    this.onItemSelected,
    this.onItemChecked,
    this.onShowDetail,
    this.gridItemWidth = 240,
    this.pagingInfo,
    this.hasNextPage = true,
    this.hasPrevPage = true,
    this.checkMode = false,
    this.isListView = true,
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

  /// labelBuilder is the builder for label in grid view
  final ItemBuilder<T>? labelBuilder;

  /// detailBuilder is the builder for detail view
  final Widget Function(T) detailBuilder;

  /// headerBuilder is the builder for header
  final Widget Function()? headerBuilder;

  /// footerBuilder is the builder for footer
  final Widget Function()? footerBuilder;

  /// isLoading is the flag to indicate if loading
  final bool isLoading;

  /// pagingInfo is current page info if not in phone design
  final String? pagingInfo;

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
  final bool checkMode;

  /// isListView is true will use list view
  final bool isListView;

  /// isSplitView is true if in split view
  bool get isSplitView => isListView && !responsive.isPhoneDesign;

  /// _buildFooterButton build footer buttons bar
  Widget _buildFooterButtons(BuildContext context) {
    final buttonStyle = TextStyle(
      fontSize: 15,
      color: Colors.orange.shade700,
    );
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 1),
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
      color: context.themeColor(light: Colors.grey.shade50, dark: Colors.grey.shade800),
      child: Row(children: [
        TextButton(
          child: Text(context.i18n.notesSelectButtonLabel, style: buttonStyle),
          style: checkMode
              ? ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    context.themeColor(light: Colors.grey.shade300, dark: Colors.grey.shade900),
                  ),
                )
              : null,
          onPressed: () async => await onBarAction.call(MasterDetailViewAction.toggleCheckMode),
        ),
        const Spacer(),
        TextButton(
          child: Text(context.i18n.notesNewButtonLabel, style: buttonStyle),
          onPressed: () => onBarAction.call(MasterDetailViewAction.add),
        ),
      ]),
    );
  }

  /// buildList build list and split view
  Widget buildList(BuildContext context) {
    return Column(
      children: [
        if (checkMode && !isSplitView) _buildSelectionHeader(context),
        Expanded(
          child: Padding(
            padding: EdgeInsets.fromLTRB(15, context.isPreferMouse ? 0 : 10, 15, 0),
            child: DynamicList<T>(
              checkMode: checkMode,
              items: items,
              selectedItems: selectedItems,
              itemBuilder: listBuilder,
              onRefresh: context.isTouchSupported ? () => onBarAction.call(MasterDetailViewAction.refresh) : null,
              onLoadMore: context.isTouchSupported ? () => onBarAction.call(MasterDetailViewAction.more) : null,
              headerBuilder: checkMode ? null : headerBuilder,
              footerBuilder: checkMode ? null : footerBuilder,
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
        if (!context.isPreferMouse) _buildFooterButtons(context),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
      if (isLoading) {
        return const delta.LoadingDisplay();
      }
      if (!isListView) {
        // grid view
        return Column(
          children: [
            if (checkMode) _buildSelectionHeader(context),
            if (responsive.isNotPhoneDesign && !checkMode)
              Row(
                children: [
                  SizedBox(width: 230, child: _buildLeftBar(context)),
                  const SizedBox(height: 30, child: VerticalDivider(color: Colors.grey)),
                  Expanded(child: _buildRightBar(context)),
                ],
              ),
            Expanded(
                child: DynamicGrid<T>(
              checkMode: checkMode,
              headerBuilder: headerBuilder,
              footerBuilder: footerBuilder,
              items: items,
              selectedItems: selectedItems,
              itemBuilder: gridBuilder,
              labelBuilder: labelBuilder,
              onRefresh: context.isTouchSupported ? () => onBarAction.call(MasterDetailViewAction.refresh) : null,
              onLoadMore: context.isTouchSupported ? () => onBarAction.call(MasterDetailViewAction.more) : null,
              onItemSelected: onItemSelected,
              onItemChecked: onItemChecked,
              crossAxisCount: max(constraints.maxWidth ~/ gridItemWidth, 2),
            )),
            if (!context.isPreferMouse) _buildFooterButtons(context),
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
        if (checkMode) _buildSelectionHeader(context),
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
                if (!checkMode && context.isPreferMouse) _buildLeftBar(context),
                Expanded(
                  child: buildList(context),
                ),
              ],
            ),
            Column(
              children: [
                if (!checkMode && context.isPreferMouse) _buildRightBar(context),
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
        TextButton.icon(
          style: TextButton.styleFrom(
            primary: Colors.grey.shade900,
          ),
          label: Text(context.i18n.notesDeleteButtonLabel),
          icon: const Icon(Icons.delete),
          onPressed: () => onBarAction.call(MasterDetailViewAction.delete),
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
              responsive.ToolButton(
                label: context.i18n.notesDeleteButtonLabel,
                icon: Icons.delete_forever,
                value: MasterDetailViewAction.delete,
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// _buildRightBar in split view
  Widget _buildRightBar(BuildContext context) {
    final MaterialLocalizations localizations = MaterialLocalizations.of(context);
    return responsive.Toolbar<MasterDetailViewAction>(
      onPressed: onBarAction,
      items: [
        responsive.ToolButton(
          label: context.i18n.notesNewButtonLabel,
          icon: Icons.add,
          value: MasterDetailViewAction.add,
        ),
        if (items.isNotEmpty) ...[
          responsive.ToolSpacer(),
          if (pagingInfo != null)
            responsive.ToolSelection<MasterDetailViewAction>(
              width: 120,
              label: localizations.rowsPerPageTitle,
              text: pagingInfo!,
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
        ],
      ],
    );
  }
}
