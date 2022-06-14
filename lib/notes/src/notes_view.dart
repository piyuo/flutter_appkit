import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:libcli/pb/pb.dart' as pb;
import 'package:libcli/delta/delta.dart' as delta;
import 'package:libcli/i18n/i18n.dart' as i18n;
import 'package:libcli/responsive/responsive.dart' as responsive;
import 'notes_provider.dart';
import 'master_detail_view.dart';
import 'tag_split_view.dart';
import 'tag_view.dart';
import 'checkable_header.dart';

class NotesView<T extends pb.Object> extends StatelessWidget {
  const NotesView({
    required this.viewProvider,
    required this.contentBuilder,
    this.leftTools,
    this.rightTools,
    this.tagViewHeader,
    Key? key,
  }) : super(key: key);

  /// notesProvider provide notes, don't direct consume it, this provider maybe inhibit by other provider
  final NotesProvider<T> viewProvider;

  /// contentBuilder is content builder
  final Widget Function() contentBuilder;

  /// leftTools is extra tools on left part on bar
  final List<responsive.ToolItem>? leftTools;

  /// rightTools is extra tools on right part on bar
  final List<responsive.ToolItem>? rightTools;

  /// tagViewHeader is header for tag view
  final Widget? tagViewHeader;

  List<responsive.ToolItem> _buildPaginator(BuildContext context, NotesProvider<T> controller, String pageInfoText) {
    final MaterialLocalizations localizations = MaterialLocalizations.of(context);
    return [
      responsive.ToolSelection(
        width: 180,
        label: localizations.rowsPerPageTitle,
        text: pageInfoText.isNotEmpty ? pageInfoText : context.i18n.noDataLabel,
        selection: {
          10: context.i18n.notesRowsPerPage.replace1('10'),
          20: context.i18n.notesRowsPerPage.replace1('20'),
          50: context.i18n.notesRowsPerPage.replace1('50'),
        },
        onPressed: (value) => controller.setRowsPerPage(context, value),
      ),
      responsive.ToolButton(
        label: localizations.previousPageTooltip,
        icon: Icons.chevron_left,
        onPressed: controller.hasPreviousPage ? () => controller.onPreviousPage(context) : null,
      ),
      responsive.ToolButton(
        label: localizations.nextPageTooltip,
        icon: Icons.chevron_right,
        onPressed: controller.hasNextPage ? () => controller.onNextPage(context) : null,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final MaterialLocalizations localizations = MaterialLocalizations.of(context);
    final linkColor = context.themeColor(light: Colors.blue.shade400, dark: Colors.blue.shade500);
    return LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
      final pageInfoText = viewProvider.pageInfo(context);
      final searchBox = delta.SearchBox(
        enabled: viewProvider.isReadyToShow,
        prefixIcon: viewProvider.tags.isEmpty || responsive.isBigScreen(constraints.maxWidth)
            ? null
            : IconButton(
                icon: Icon(Icons.menu, color: viewProvider.isReadyToShow ? Colors.blue : null),
                onPressed: viewProvider.isReadyToShow
                    ? () => showTagView<String>(
                          context,
                          onTagSelected: (value) => viewProvider.setSelectedTag(value),
                          tags: viewProvider.tags,
                          header: tagViewHeader,
                        )
                    : null,
              ),
        controller: viewProvider.searchController,
      );
      return MultiProvider(
          providers: [
            ChangeNotifierProvider.value(
              value: viewProvider.refreshButtonController,
            ),
            ChangeNotifierProvider.value(
              value: viewProvider.animateViewController,
            )
          ],
          child: TagSplitView(
              tagView: viewProvider.tags.isNotEmpty
                  ? TagView<String>(
                      onTagSelected: viewProvider.setSelectedTag,
                      tags: viewProvider.tags,
                      header: tagViewHeader,
                    )
                  : null,
              child: MasterDetailView<T>(
                isReady: viewProvider.isReadyToShow,
                items: viewProvider.dataView != null ? viewProvider.dataView!.displayRows : [],
                selectedItems: viewProvider.dataView != null ? viewProvider.dataView!.getSelectedRows() : [],
                listScrollController: viewProvider.listScrollController,
                gridScrollController: viewProvider.gridScrollController,
                listAnimatedViewScrollController: viewProvider.listAnimatedViewScrollController,
                gridAnimatedViewScrollController: viewProvider.gridAnimatedViewScrollController,
                listBuilder: viewProvider.listBuilder,
                gridBuilder: viewProvider.gridBuilder,
                listDecorationBuilder: viewProvider.listDecorationBuilder,
                gridDecorationBuilder: viewProvider.gridDecorationBuilder,
                contentBuilder: contentBuilder,
                onRefresh: context.isTouchSupported && viewProvider.isReadyToShow && !viewProvider.noRefresh
                    ? () => viewProvider.refresh(context)
                    : null,
                onMore: context.isTouchSupported && viewProvider.isReadyToShow && !viewProvider.noMore
                    ? () => viewProvider.loadMore(context)
                    : null,
                headerBuilder: () => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: responsive.FoldPanel(
                    builder: (isColumn) => [
                      if (viewProvider.caption != null)
                        Padding(
                            padding: isColumn ? const EdgeInsets.only(bottom: 10) : EdgeInsets.zero,
                            child: Text(viewProvider.caption!,
                                style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  overflow: TextOverflow.ellipsis,
                                ))),
                      isColumn
                          ? searchBox
                          : Align(
                              alignment: Alignment.centerRight,
                              child: ConstrainedBox(
                                constraints: const BoxConstraints(maxWidth: 320),
                                child: searchBox,
                              ),
                            )
                    ],
                  ),
                ),
                footerBuilder: viewProvider.hasNextPage || viewProvider.hasPreviousPage
                    ? () => Column(children: [
                          if (!viewProvider.isListView) const Divider(),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: LayoutBuilder(
                                builder: (BuildContext context, BoxConstraints constraints) => Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        if (viewProvider.hasPreviousPage)
                                          TextButton.icon(
                                            icon: Icon(Icons.chevron_left, color: linkColor),
                                            label: constraints.maxWidth < 300
                                                ? const SizedBox()
                                                : Text(localizations.previousPageTooltip,
                                                    style: TextStyle(color: linkColor)),
                                            onPressed: () => viewProvider.onPreviousPage(context),
                                          ),
                                        if (viewProvider.hasNextPage)
                                          TextButton.icon(
                                            icon: constraints.maxWidth < 300
                                                ? const SizedBox()
                                                : Text(localizations.nextPageTooltip,
                                                    style: TextStyle(color: linkColor)),
                                            label: Icon(Icons.chevron_right, color: linkColor),
                                            onPressed: () => viewProvider.onNextPage(context),
                                          ),
                                      ],
                                    )),
                          ),
                        ])
                    : null,
                leftBarBuilder: () {
                  return Row(
                    children: [
                      const SizedBox(width: 10),
                      delta.RefreshButton(
                        onPressed: viewProvider.isReadyToShow ? () async => await viewProvider.refresh(context) : null,
                      ),
                      Expanded(
                        child: responsive.Toolbar(
                          items: [
                            if (viewProvider.hasListView && viewProvider.hasGridView)
                              responsive.ToolButton(
                                label: context.i18n.notesViewAsListLabel,
                                icon: Icons.view_headline,
                                onPressed: viewProvider.isReadyToShow ? () => viewProvider.onListView(context) : null,
                                active: viewProvider.isListView,
                              ),
                            if (viewProvider.hasListView && viewProvider.hasGridView)
                              responsive.ToolButton(
                                label: context.i18n.notesViewAsGridLabel,
                                icon: Icons.grid_view,
                                onPressed: viewProvider.isReadyToShow ? () => viewProvider.onGridView(context) : null,
                                active: !viewProvider.isListView,
                                space: 10,
                              ),
                            responsive.ToolButton(
                              label: context.i18n.notesSelectButtonLabel,
                              icon: Icons.check_circle_outline,
                              onPressed: viewProvider.isNotEmpty ? () => viewProvider.onToggleCheckMode(context) : null,
                            ),
                            if (leftTools != null) ...leftTools!,
                            if (viewProvider.isListView) responsive.ToolSpacer(),
                            if (viewProvider.formController.showArchiveButton)
                              responsive.ToolButton(
                                label: context.i18n.archiveButtonText,
                                icon: Icons.archive,
                                onPressed: viewProvider.isAllowDelete ? () => viewProvider.onArchive(context) : null,
                              ),
                            if (viewProvider.formController.showDeleteButton)
                              responsive.ToolButton(
                                label: context.i18n.deleteButtonText,
                                icon: Icons.delete,
                                onPressed: viewProvider.isAllowDelete ? () => viewProvider.onDelete(context) : null,
                              ),
                            if (viewProvider.formController.showRestoreButton)
                              responsive.ToolButton(
                                label: context.i18n.restoreButtonText,
                                icon: Icons.restore,
                                onPressed: viewProvider.isAllowDelete ? () => viewProvider.onRestore(context) : null,
                              ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
                rightBarBuilder: () {
                  return responsive.Toolbar(
                    items: [
                      responsive.ToolButton(
                        label: context.i18n.notesNewButtonLabel,
                        icon: Icons.add,
                        onPressed: () => viewProvider.onCreateNew(context),
                      ),
                      responsive.ToolButton(
                        label: context.i18n.formSubmitButtonText,
                        icon: Icons.cloud_upload,
                        onPressed: () => viewProvider.formController.submit(context),
                      ),
                      if (rightTools != null) ...rightTools!,
                      responsive.ToolSpacer(),
                      ..._buildPaginator(context, viewProvider, pageInfoText),
                    ],
                  );
                },
                touchBottomBarBuilder: () {
                  final buttonStyle = TextStyle(
                    fontSize: 15,
                    color: viewProvider.isReadyToShow ? Colors.blue.shade700 : Colors.grey,
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
                        style: viewProvider.isCheckMode
                            ? ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                  context.themeColor(light: Colors.grey.shade300, dark: Colors.grey.shade900),
                                ),
                              )
                            : null,
                        onPressed: viewProvider.isReadyToShow ? () => viewProvider.onToggleCheckMode(context) : null,
                      ),
                      pageInfoText.isNotEmpty
                          ? Expanded(
                              child: Text(pageInfoText,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: context.themeColor(light: Colors.grey.shade600, dark: Colors.grey.shade400),
                                  )),
                            )
                          : const Spacer(),
                      TextButton(
                        child: Text(context.i18n.notesNewButtonLabel, style: buttonStyle),
                        onPressed: viewProvider.isReadyToShow ? () => viewProvider.onCreateNew(context) : null,
                      ),
                    ]),
                  );
                },
                mouseBottomBarBuilder: () {
                  return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 18),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular(10)),
                        color: context.themeColor(light: Colors.grey.shade100, dark: Colors.grey.shade800),
                      ),
                      child: responsive.Toolbar(
                        mainAxisAlignment: MainAxisAlignment.center,
                        items: [
                          ..._buildPaginator(context, viewProvider, pageInfoText),
                        ],
                      ));
                },
                selectionBarBuilder: () {
                  return CheckableHeader(
                    selectedItemCount: viewProvider.dataView!.selectedCount,
                    isAllSelected: viewProvider.dataView!.selectedCount == viewProvider.dataView!.displayRows.length,
                    onSelectAll: () => viewProvider.onItemChecked(context, viewProvider.dataView!.displayRows),
                    onUnselectAll: () => viewProvider.onItemChecked(context, []),
                    onCancel: () => viewProvider.onToggleCheckMode(context),
                    actions: [
                      if (viewProvider.formController.showArchiveButton)
                        TextButton.icon(
                          style: TextButton.styleFrom(
                            primary: Colors.grey.shade900,
                          ),
                          label: Text(context.i18n.archiveButtonText),
                          icon: const Icon(Icons.archive),
                          onPressed:
                              viewProvider.dataView!.hasSelectedRows ? () => viewProvider.onArchive(context) : null,
                        ),
                      if (viewProvider.formController.showDeleteButton)
                        TextButton.icon(
                          style: TextButton.styleFrom(
                            primary: Colors.grey.shade900,
                          ),
                          label: Text(context.i18n.deleteButtonText),
                          icon: const Icon(Icons.delete),
                          onPressed:
                              viewProvider.dataView!.hasSelectedRows ? () => viewProvider.onDelete(context) : null,
                        ),
                      if (viewProvider.formController.showRestoreButton)
                        TextButton.icon(
                          style: TextButton.styleFrom(
                            primary: Colors.grey.shade900,
                          ),
                          label: Text(context.i18n.restoreButtonText),
                          icon: const Icon(Icons.restore),
                          onPressed:
                              viewProvider.dataView!.hasSelectedRows ? () => viewProvider.onRestore(context) : null,
                        ),
                    ],
                  );
                },
                creating: viewProvider.creating,
                isCheckMode: viewProvider.isCheckMode,
                isListView: viewProvider.isListView,
                onItemChecked: (selected) => viewProvider.onItemChecked(context, selected),
                onItemSelected: (selected) => viewProvider.onItemsSelected(context, selected),
                onItemTapped: (selected) => viewProvider.onItemTapped(context, selected),
              )));
    });
  }
}
