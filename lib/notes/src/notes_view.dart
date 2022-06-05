import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:libcli/pb/pb.dart' as pb;
import 'package:libcli/delta/delta.dart' as delta;
import 'package:libcli/i18n/i18n.dart' as i18n;
import 'package:libcli/responsive/responsive.dart' as responsive;
import 'notes_view_provider.dart';
import 'master_detail_view.dart';
import 'tag_split_view.dart';
import 'tag_view.dart';
import 'checkable_header.dart';
import 'note_form_controller.dart';
import 'note_form.dart';

class NotesView<T extends pb.Object> extends StatelessWidget {
  const NotesView({
    this.leftTools,
    this.rightTools,
    this.tagViewHeader,
    Key? key,
  }) : super(key: key);

  /// leftTools is extra tools on left part on bar
  final List<responsive.ToolItem>? leftTools;

  /// rightTools is extra tools on right part on bar
  final List<responsive.ToolItem>? rightTools;

  /// tagViewHeader is header for tag view
  final Widget? tagViewHeader;

  List<responsive.ToolItem> _buildPaginator(
      BuildContext context, NotesViewProvider<T> controller, String pageInfoText) {
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
    return Consumer2<NotesViewProvider<T>, NoteFormController<T>>(
        builder: (context, provide, formController, _) =>
            LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
              final pageInfoText = provide.pageInfo(context);
              final searchBox = delta.SearchBox(
                enabled: provide.isReady,
                prefixIcon: provide.tags.isEmpty || responsive.isBigScreen(constraints.maxWidth)
                    ? null
                    : IconButton(
                        icon: Icon(Icons.menu, color: provide.isReady ? Colors.blue : null),
                        onPressed: provide.isReady
                            ? () => showTagView<String>(
                                  context,
                                  onTagSelected: (value) => provide.setSelectedTag(value),
                                  tags: provide.tags,
                                  header: tagViewHeader,
                                )
                            : null,
                      ),
                controller: provide.searchController,
              );
              return MultiProvider(
                  providers: [
                    ChangeNotifierProvider.value(
                      value: provide.refreshButtonController,
                    ),
                    ChangeNotifierProvider.value(
                      value: provide.animatedViewController,
                    )
                  ],
                  child: TagSplitView(
                      tagView: provide.tags.isNotEmpty
                          ? TagView<String>(
                              onTagSelected: provide.setSelectedTag,
                              tags: provide.tags,
                              header: tagViewHeader,
                            )
                          : null,
                      child: MasterDetailView<T>(
                        isReady: provide.isReady,
                        items: provide.dataView != null ? provide.dataView!.displayRows : [],
                        selectedItems: provide.dataView != null ? provide.dataView!.selectedRows : [],
                        listScrollController: provide.listScrollController,
                        gridScrollController: provide.gridScrollController,
                        listAnimatedViewScrollController: provide.listAnimatedViewScrollController,
                        gridAnimatedViewScrollController: provide.gridAnimatedViewScrollController,
                        listBuilder: provide.listBuilder,
                        gridBuilder: provide.gridBuilder,
                        listDecorationBuilder: provide.listDecorationBuilder,
                        gridDecorationBuilder: provide.gridDecorationBuilder,
                        contentBuilder: () => NoteForm<T>(),
                        onRefresh: context.isTouchSupported && provide.isReady && !provide.noRefresh
                            ? () => provide.refresh(context)
                            : null,
                        onMore: context.isTouchSupported && provide.isReady && !provide.noMore
                            ? () => provide.loadMore(context)
                            : null,
                        headerBuilder: () => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: responsive.FoldPanel(
                            builder: (isColumn) => [
                              if (provide.caption != null)
                                Padding(
                                    padding: isColumn ? const EdgeInsets.only(bottom: 10) : EdgeInsets.zero,
                                    child: Text(provide.caption!,
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
                        footerBuilder: provide.hasNextPage || provide.hasPreviousPage
                            ? () => Column(children: [
                                  if (!provide.isListView) const Divider(),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 10),
                                    child: LayoutBuilder(
                                        builder: (BuildContext context, BoxConstraints constraints) => Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                if (provide.hasPreviousPage)
                                                  TextButton.icon(
                                                    icon: Icon(Icons.chevron_left, color: linkColor),
                                                    label: constraints.maxWidth < 300
                                                        ? const SizedBox()
                                                        : Text(localizations.previousPageTooltip,
                                                            style: TextStyle(color: linkColor)),
                                                    onPressed: () => provide.onPreviousPage(context),
                                                  ),
                                                if (provide.hasNextPage)
                                                  TextButton.icon(
                                                    icon: constraints.maxWidth < 300
                                                        ? const SizedBox()
                                                        : Text(localizations.nextPageTooltip,
                                                            style: TextStyle(color: linkColor)),
                                                    label: Icon(Icons.chevron_right, color: linkColor),
                                                    onPressed: () => provide.onNextPage(context),
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
                                onPressed: provide.isReady ? () async => await provide.refresh(context) : null,
                              ),
                              Expanded(
                                child: responsive.Toolbar(
                                  items: [
                                    if (provide.hasListView && provide.hasGridView)
                                      responsive.ToolButton(
                                        label: context.i18n.notesViewAsListLabel,
                                        icon: Icons.view_headline,
                                        onPressed: provide.isReady ? provide.onListView : null,
                                        active: provide.isListView,
                                      ),
                                    if (provide.hasListView && provide.hasGridView)
                                      responsive.ToolButton(
                                        label: context.i18n.notesViewAsGridLabel,
                                        icon: Icons.grid_view,
                                        onPressed: provide.isReady ? provide.onGridView : null,
                                        active: !provide.isListView,
                                        space: 10,
                                      ),
                                    responsive.ToolButton(
                                      label: context.i18n.notesSelectButtonLabel,
                                      icon: Icons.check_circle_outline,
                                      onPressed: provide.isNotEmpty ? provide.onToggleCheckMode : null,
                                    ),
                                    if (leftTools != null) ...leftTools!,
                                    responsive.ToolSpacer(),
                                    if (formController.showArchiveButton)
                                      responsive.ToolButton(
                                        label: context.i18n.archiveButtonText,
                                        icon: Icons.archive,
                                        onPressed: provide.isNotEmpty ? () => provide.onArchive(context) : null,
                                      ),
                                    if (formController.showDeleteButton)
                                      responsive.ToolButton(
                                        label: context.i18n.deleteButtonText,
                                        icon: Icons.delete,
                                        onPressed: provide.isNotEmpty ? () => provide.onDelete(context) : null,
                                      ),
                                    if (formController.showRestoreButton)
                                      responsive.ToolButton(
                                        label: context.i18n.restoreButtonText,
                                        icon: Icons.restore,
                                        onPressed: provide.isNotEmpty ? () => provide.onRestore(context) : null,
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
                                onPressed: () => provide.onAdd(context),
                              ),
                              if (rightTools != null) ...rightTools!,
                              responsive.ToolSpacer(),
                              ..._buildPaginator(context, provide, pageInfoText),
                            ],
                          );
                        },
                        touchBottomBarBuilder: () {
                          final buttonStyle = TextStyle(
                            fontSize: 15,
                            color: provide.isReady ? Colors.blue.shade700 : Colors.grey,
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
                                style: provide.isCheckMode
                                    ? ButtonStyle(
                                        backgroundColor: MaterialStateProperty.all(
                                          context.themeColor(light: Colors.grey.shade300, dark: Colors.grey.shade900),
                                        ),
                                      )
                                    : null,
                                onPressed: provide.isReady ? provide.onToggleCheckMode : null,
                              ),
                              pageInfoText.isNotEmpty
                                  ? Expanded(
                                      child: Text(pageInfoText,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: context.themeColor(
                                                light: Colors.grey.shade600, dark: Colors.grey.shade400),
                                          )),
                                    )
                                  : const Spacer(),
                              TextButton(
                                child: Text(context.i18n.notesNewButtonLabel, style: buttonStyle),
                                onPressed: provide.isReady ? () => provide.onAdd(context) : null,
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
                                  ..._buildPaginator(context, provide, pageInfoText),
                                ],
                              ));
                        },
                        selectionBarBuilder: () {
                          return CheckableHeader(
                            selectedItemCount: provide.dataView!.selectedRows.length,
                            isAllSelected:
                                provide.dataView!.selectedRows.length == provide.dataView!.displayRows.length,
                            onSelectAll: () => provide.onItemChecked(context, provide.dataView!.displayRows),
                            onUnselectAll: () => provide.onItemChecked(context, []),
                            onCancel: () => provide.onToggleCheckMode(),
                            actions: [
                              if (formController.showArchiveButton)
                                TextButton.icon(
                                  style: TextButton.styleFrom(
                                    primary: Colors.grey.shade900,
                                  ),
                                  label: Text(context.i18n.archiveButtonText),
                                  icon: const Icon(Icons.archive),
                                  onPressed: provide.dataView!.selectedRows.isNotEmpty
                                      ? () => provide.onArchive(context)
                                      : null,
                                ),
                              if (formController.showDeleteButton)
                                TextButton.icon(
                                  style: TextButton.styleFrom(
                                    primary: Colors.grey.shade900,
                                  ),
                                  label: Text(context.i18n.deleteButtonText),
                                  icon: const Icon(Icons.delete),
                                  onPressed: provide.dataView!.selectedRows.isNotEmpty
                                      ? () => provide.onDelete(context)
                                      : null,
                                ),
                              if (formController.showRestoreButton)
                                TextButton.icon(
                                  style: TextButton.styleFrom(
                                    primary: Colors.grey.shade900,
                                  ),
                                  label: Text(context.i18n.restoreButtonText),
                                  icon: const Icon(Icons.restore),
                                  onPressed: provide.dataView!.selectedRows.isNotEmpty
                                      ? () => provide.onRestore(context)
                                      : null,
                                ),
                            ],
                          );
                        },
                        newItem: provide.newItem,
                        isCheckMode: provide.isCheckMode,
                        isListView: provide.isListView,
                        onItemChecked: (selected) => provide.onItemChecked(context, selected),
                        onItemSelected: (selected) => provide.onItemsSelected(context, selected),
                        onItemTapped: (selected) => provide.onItemTapped(context, selected),
                      )));
            }));
  }
}
