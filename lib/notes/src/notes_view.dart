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
    required this.notesProvider,
    required this.contentBuilder,
    this.leftTools,
    this.rightTools,
    this.tagViewHeader,
    Key? key,
  }) : super(key: key);

  /// notesProvider provide notes, don't direct consume it, this provider maybe inhibit by other provider
  final NotesProvider<T> notesProvider;

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
      final pageInfoText = notesProvider.pageInfo(context);
      final searchBox = delta.SearchBox(
        enabled: notesProvider.isReadyToShow,
        prefixIcon: notesProvider.tags.isEmpty || responsive.isBigScreen(constraints.maxWidth)
            ? null
            : IconButton(
                icon: Icon(Icons.menu, color: notesProvider.isReadyToShow ? Colors.blue : null),
                onPressed: notesProvider.isReadyToShow
                    ? () => showTagView<String>(
                          context,
                          onTagSelected: (value) => notesProvider.setSelectedTag(value),
                          tags: notesProvider.tags,
                          header: tagViewHeader,
                        )
                    : null,
              ),
        controller: notesProvider.searchController,
      );
      return MultiProvider(
          providers: [
            ChangeNotifierProvider.value(
              value: notesProvider.refreshButtonController,
            ),
            ChangeNotifierProvider.value(
              value: notesProvider.animateViewProvider,
            )
          ],
          child: TagSplitView(
              tagView: notesProvider.tags.isNotEmpty
                  ? TagView<String>(
                      onTagSelected: notesProvider.setSelectedTag,
                      tags: notesProvider.tags,
                      header: tagViewHeader,
                    )
                  : null,
              child: MasterDetailView<T>(
                animateViewProvider: notesProvider.animateViewProvider,
                isReady: notesProvider.isReadyToShow,
                items: notesProvider.dataView != null ? notesProvider.dataView!.displayRows : [],
                selectedItems: notesProvider.dataView != null ? notesProvider.dataView!.getSelectedRows() : [],
                listScrollController: notesProvider.listScrollController,
                gridScrollController: notesProvider.gridScrollController,
                listAnimatedViewScrollController: notesProvider.listAnimatedViewScrollController,
                gridAnimatedViewScrollController: notesProvider.gridAnimatedViewScrollController,
                listBuilder: notesProvider.listBuilder,
                gridBuilder: notesProvider.gridBuilder,
                listDecorationBuilder: notesProvider.listDecorationBuilder,
                gridDecorationBuilder: notesProvider.gridDecorationBuilder,
                contentBuilder: contentBuilder,
                onRefresh: context.isTouchSupported && notesProvider.isReadyToShow && !notesProvider.noRefresh
                    ? () => notesProvider.refresh(context)
                    : null,
                onMore: context.isTouchSupported && notesProvider.isReadyToShow && !notesProvider.noMore
                    ? () => notesProvider.loadMore(context)
                    : null,
                headerBuilder: () => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: responsive.FoldPanel(
                    builder: (isColumn) => [
                      if (notesProvider.caption != null)
                        Padding(
                            padding: isColumn ? const EdgeInsets.only(bottom: 10) : EdgeInsets.zero,
                            child: Text(notesProvider.caption!,
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
                footerBuilder: notesProvider.hasNextPage || notesProvider.hasPreviousPage
                    ? () => Column(children: [
                          if (!notesProvider.isListView) const Divider(),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: LayoutBuilder(
                                builder: (BuildContext context, BoxConstraints constraints) => Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        if (notesProvider.hasPreviousPage)
                                          TextButton.icon(
                                            icon: Icon(Icons.chevron_left, color: linkColor),
                                            label: constraints.maxWidth < 300
                                                ? const SizedBox()
                                                : Text(localizations.previousPageTooltip,
                                                    style: TextStyle(color: linkColor)),
                                            onPressed: () => notesProvider.onPreviousPage(context),
                                          ),
                                        if (notesProvider.hasNextPage)
                                          TextButton.icon(
                                            icon: constraints.maxWidth < 300
                                                ? const SizedBox()
                                                : Text(localizations.nextPageTooltip,
                                                    style: TextStyle(color: linkColor)),
                                            label: Icon(Icons.chevron_right, color: linkColor),
                                            onPressed: () => notesProvider.onNextPage(context),
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
                        onPressed:
                            notesProvider.isReadyToShow ? () async => await notesProvider.refresh(context) : null,
                      ),
                      Expanded(
                        child: responsive.Toolbar(
                          items: [
                            if (notesProvider.hasListView && notesProvider.hasGridView)
                              responsive.ToolButton(
                                label: context.i18n.notesViewAsListLabel,
                                icon: Icons.view_headline,
                                onPressed: notesProvider.isReadyToShow ? () => notesProvider.onListView(context) : null,
                                active: notesProvider.isListView,
                              ),
                            if (notesProvider.hasListView && notesProvider.hasGridView)
                              responsive.ToolButton(
                                label: context.i18n.notesViewAsGridLabel,
                                icon: Icons.grid_view,
                                onPressed: notesProvider.isReadyToShow ? () => notesProvider.onGridView(context) : null,
                                active: !notesProvider.isListView,
                                space: 10,
                              ),
                            responsive.ToolButton(
                              label: context.i18n.notesSelectButtonLabel,
                              icon: Icons.check_circle_outline,
                              onPressed:
                                  notesProvider.isNotEmpty ? () => notesProvider.onToggleCheckMode(context) : null,
                            ),
                            if (leftTools != null) ...leftTools!,
                            if (notesProvider.isListView) responsive.ToolSpacer(),
                            if (notesProvider.formController.showArchiveButton)
                              responsive.ToolButton(
                                label: context.i18n.archiveButtonText,
                                icon: Icons.archive,
                                onPressed: notesProvider.isAllowDelete ? () => notesProvider.onArchive(context) : null,
                              ),
                            if (notesProvider.formController.showDeleteButton)
                              responsive.ToolButton(
                                label: context.i18n.deleteButtonText,
                                icon: Icons.delete,
                                onPressed: notesProvider.isAllowDelete ? () => notesProvider.onDelete(context) : null,
                              ),
                            if (notesProvider.formController.showRestoreButton)
                              responsive.ToolButton(
                                label: context.i18n.restoreButtonText,
                                icon: Icons.restore,
                                onPressed: notesProvider.isAllowDelete ? () => notesProvider.onRestore(context) : null,
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
                        onPressed: () => notesProvider.onCreateNew(context),
                      ),
                      responsive.ToolButton(
                        label: context.i18n.formSubmitButtonText,
                        icon: Icons.cloud_upload,
                        onPressed: () => notesProvider.formController.submit(context),
                      ),
                      if (rightTools != null) ...rightTools!,
                      responsive.ToolSpacer(),
                      ..._buildPaginator(context, notesProvider, pageInfoText),
                    ],
                  );
                },
                touchBottomBarBuilder: () {
                  final buttonStyle = TextStyle(
                    fontSize: 15,
                    color: notesProvider.isReadyToShow ? Colors.blue.shade700 : Colors.grey,
                  );
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 18),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      color: context.themeColor(light: Colors.grey.shade100, dark: Colors.grey.shade800),
                    ),
                    child: Row(children: [
                      TextButton(
                        style: notesProvider.isCheckMode
                            ? ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                  context.themeColor(light: Colors.grey.shade300, dark: Colors.grey.shade900),
                                ),
                              )
                            : null,
                        onPressed: notesProvider.isReadyToShow ? () => notesProvider.onToggleCheckMode(context) : null,
                        child: Text(context.i18n.notesSelectButtonLabel, style: buttonStyle),
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
                        onPressed: notesProvider.isReadyToShow ? () => notesProvider.onCreateNew(context) : null,
                        child: Text(context.i18n.notesNewButtonLabel, style: buttonStyle),
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
                          ..._buildPaginator(context, notesProvider, pageInfoText),
                        ],
                      ));
                },
                selectionBarBuilder: () {
                  return CheckableHeader(
                    selectedItemCount: notesProvider.dataView!.selectedCount,
                    isAllSelected: notesProvider.dataView!.selectedCount == notesProvider.dataView!.displayRows.length,
                    onSelectAll: () => notesProvider.onItemChecked(notesProvider.dataView!.displayRows),
                    onUnselectAll: () => notesProvider.onItemChecked([]),
                    onCancel: () => notesProvider.onToggleCheckMode(context),
                    actions: [
                      if (notesProvider.formController.showArchiveButton)
                        TextButton.icon(
                          style: TextButton.styleFrom(
                            primary: Colors.grey.shade900,
                          ),
                          label: Text(context.i18n.archiveButtonText),
                          icon: const Icon(Icons.archive),
                          onPressed:
                              notesProvider.dataView!.hasSelectedRows ? () => notesProvider.onArchive(context) : null,
                        ),
                      if (notesProvider.formController.showDeleteButton)
                        TextButton.icon(
                          style: TextButton.styleFrom(
                            primary: Colors.grey.shade900,
                          ),
                          label: Text(context.i18n.deleteButtonText),
                          icon: const Icon(Icons.delete),
                          onPressed:
                              notesProvider.dataView!.hasSelectedRows ? () => notesProvider.onDelete(context) : null,
                        ),
                      if (notesProvider.formController.showRestoreButton)
                        TextButton.icon(
                          style: TextButton.styleFrom(
                            primary: Colors.grey.shade900,
                          ),
                          label: Text(context.i18n.restoreButtonText),
                          icon: const Icon(Icons.restore),
                          onPressed:
                              notesProvider.dataView!.hasSelectedRows ? () => notesProvider.onRestore(context) : null,
                        ),
                    ],
                  );
                },
                creating: notesProvider.creating,
                isCheckMode: notesProvider.isCheckMode,
                isListView: notesProvider.isListView,
                onItemChecked: (selected) => notesProvider.onItemChecked(selected),
                onItemSelected: (selected) => notesProvider.onItemsSelected(context, selected),
                onItemTapped: (selected) => notesProvider.onItemTapped(context, selected),
              )));
    });
  }
}
