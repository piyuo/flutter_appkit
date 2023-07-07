import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:libcli/pb/pb.dart' as pb;
import 'package:libcli/delta/delta.dart' as delta;
import 'package:libcli/tools/tools.dart' as tools;
import 'package:libcli/i18n/i18n.dart' as i18n;
import 'notes_provider.dart';
import 'grid_list_view.dart';
import 'checkable_header.dart';

/// DataView is a widget to display data in list or grid view, add tools and paginator
class DataView<T extends pb.Object> extends StatelessWidget {
  const DataView({
    required this.notesProvider,
    required this.contentBuilder,
    this.leftTools,
    this.rightTools,
    Key? key,
  }) : super(key: key);

  /// notesProvider provide notes, don't direct consume it, this provider maybe inhibit by other provider
  final NotesProvider<T> notesProvider;

  /// contentBuilder is content builder
  final Widget Function() contentBuilder;

  /// leftTools is extra tools on left part on bar
  final List<tools.ToolItem>? leftTools;

  /// rightTools is extra tools on right part on bar
  final List<tools.ToolItem>? rightTools;

  List<tools.ToolItem> _buildPaginator(BuildContext context, NotesProvider<T> controller, String pageInfoText) {
    final MaterialLocalizations localizations = MaterialLocalizations.of(context);
    return [
      tools.ToolSelection(
        width: 180,
        label: localizations.rowsPerPageTitle,
        //text: pageInfoText.isNotEmpty ? pageInfoText : context.i18n.noDataLabel,
        selection: {
          10: context.i18n.notesRowsPerPage.replace1('10'),
          20: context.i18n.notesRowsPerPage.replace1('20'),
          50: context.i18n.notesRowsPerPage.replace1('50'),
        },
        onPressed: (value) => controller.setRowsPerPage(context, value),
      ),
      tools.ToolButton(
        label: localizations.previousPageTooltip,
        icon: Icons.chevron_left,
        onPressed: controller.hasPreviousPage ? () => controller.onPreviousPage(context) : null,
      ),
      tools.ToolButton(
        label: localizations.nextPageTooltip,
        icon: Icons.chevron_right,
        onPressed: controller.hasNextPage ? () => controller.onNextPage(context) : null,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final MaterialLocalizations localizations = MaterialLocalizations.of(context);
    return LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
      final colorScheme = Theme.of(context).colorScheme;
      final pageInfoText = notesProvider.pageInfo(context);
      final searchBox = delta.SearchBox(
        focusNode: notesProvider.searchFocusNode,
        enabled: notesProvider.isReadyToShow,
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
          child: GridListView<T>(
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
              child: delta.VerticalOnPhoneLayout(
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
                                        icon: const Icon(Icons.chevron_left),
                                        label: constraints.maxWidth < 300
                                            ? const SizedBox()
                                            : Text(localizations.previousPageTooltip),
                                        onPressed: () => notesProvider.onPreviousPage(context),
                                      ),
                                    if (notesProvider.hasNextPage)
                                      TextButton.icon(
                                        icon: constraints.maxWidth < 300
                                            ? const SizedBox()
                                            : Text(localizations.nextPageTooltip),
                                        label: const Icon(Icons.chevron_right),
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
                    onPressed: notesProvider.isReadyToShow ? () async => await notesProvider.refresh(context) : null,
                  ),
                  Expanded(
                    child: tools.Toolbar(
                      items: [
                        if (notesProvider.hasListView && notesProvider.hasGridView)
                          tools.ToolButton(
                            label: context.i18n.notesViewAsListLabel,
                            icon: Icons.view_headline,
                            onPressed: notesProvider.isReadyToShow ? () => notesProvider.onListView(context) : null,
                            active: notesProvider.isListView,
                          ),
                        if (notesProvider.hasListView && notesProvider.hasGridView)
                          tools.ToolButton(
                            label: context.i18n.notesViewAsGridLabel,
                            icon: Icons.grid_view,
                            onPressed: notesProvider.isReadyToShow ? () => notesProvider.onGridView(context) : null,
                            active: !notesProvider.isListView,
                            space: 10,
                          ),
                        tools.ToolButton(
                          label: context.i18n.notesSelectButtonLabel,
                          icon: Icons.check_circle_outline,
                          onPressed: notesProvider.isNotEmpty ? () => notesProvider.onToggleCheckMode(context) : null,
                        ),
                        if (leftTools != null) ...leftTools!,
                        if (notesProvider.isListView) tools.ToolSpacer(),
                        if (notesProvider.formController.showDeleteButton)
                          tools.ToolButton(
                            label: context.i18n.deleteButtonText,
                            icon: Icons.delete,
                            onPressed: notesProvider.isAllowDelete ? () => notesProvider.onDelete(context) : null,
                          ),
                        if (notesProvider.formController.showRestoreButton)
                          tools.ToolButton(
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
              return tools.Toolbar(
                items: [
                  tools.ToolButton(
                    label: context.i18n.notesNewButtonLabel,
                    icon: Icons.add,
                    onPressed: () => notesProvider.onCreateNew(context),
                  ),
                  tools.ToolButton(
                    label: context.i18n.formSubmitButtonText,
                    icon: Icons.cloud_upload,
                    onPressed: () => notesProvider.formController.submit(context),
                  ),
                  if (rightTools != null) ...rightTools!,
                  tools.ToolSpacer(),
                  ..._buildPaginator(context, notesProvider, pageInfoText),
                ],
              );
            },
            touchBottomBarBuilder: () {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 18),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  color: colorScheme.surfaceVariant,
                ),
                child: Row(children: [
                  TextButton(
                    onPressed: notesProvider.isReadyToShow ? () => notesProvider.onToggleCheckMode(context) : null,
                    child: Text(context.i18n.notesSelectButtonLabel),
                  ),
                  pageInfoText.isNotEmpty
                      ? Expanded(
                          child: Text(pageInfoText,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: colorScheme.onSurfaceVariant,
                              )),
                        )
                      : const Spacer(),
                  TextButton(
                    onPressed: notesProvider.isReadyToShow ? () => notesProvider.onCreateNew(context) : null,
                    child: Text(context.i18n.notesNewButtonLabel),
                  ),
                ]),
              );
            },
            mouseBottomBarBuilder: () {
              return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 18),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    color: colorScheme.surfaceVariant,
                  ),
                  child: tools.Toolbar(
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
                  if (notesProvider.formController.showDeleteButton)
                    TextButton.icon(
                      style: TextButton.styleFrom(
                        foregroundColor: colorScheme.inversePrimary,
                      ),
                      label: Text(context.i18n.deleteButtonText),
                      icon: const Icon(Icons.delete),
                      onPressed: notesProvider.dataView!.hasSelectedRows ? () => notesProvider.onDelete(context) : null,
                    ),
                  if (notesProvider.formController.showRestoreButton)
                    TextButton.icon(
                      style: TextButton.styleFrom(
                        foregroundColor: colorScheme.inversePrimary,
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
          ));
    });
  }
}
