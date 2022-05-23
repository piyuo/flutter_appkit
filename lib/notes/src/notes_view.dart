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

class NotesView<T extends pb.Object> extends StatelessWidget {
  const NotesView({
    this.tools,
    Key? key,
  }) : super(key: key);

  /// tools is extra tools for master detail view
  final List<responsive.ToolItem>? tools;

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
    return Consumer<NotesViewProvider<T>>(
        builder: (context, controller, _) => LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
              final pageInfoText = controller.pageInfo(context);
              final searchBox = delta.SearchBox(
                enabled: controller.isReady,
                prefixIcon: controller.tags.isEmpty || responsive.isBigScreen(constraints.maxWidth)
                    ? null
                    : IconButton(
                        icon: Icon(Icons.menu, color: controller.isReady ? Colors.blue : null),
                        onPressed: controller.isReady
                            ? () => showTagView<String>(
                                  context,
                                  onTagSelected: (value) => controller.setSelectedTag(value),
                                  tags: controller.tags,
                                )
                            : null,
                      ),
                controller: controller.searchController,
              );
              return MultiProvider(
                  providers: [
                    ChangeNotifierProvider.value(
                      value: controller.refreshButtonController,
                    ),
                    ChangeNotifierProvider.value(
                      value: controller.animatedViewController,
                    )
                  ],
                  child: TagSplitView(
                      tagView: controller.tags.isNotEmpty
                          ? TagView<String>(
                              onTagSelected: controller.setSelectedTag,
                              tags: controller.tags,
                            )
                          : null,
                      child: MasterDetailView<T>(
                        isReady: controller.isReady,
                        items: controller.dataView != null ? controller.dataView!.displayRows : [],
                        selectedItems: controller.dataView != null ? controller.dataView!.selectedRows : [],
                        listScrollController: controller.listScrollController,
                        gridScrollController: controller.gridScrollController,
                        listAnimatedViewScrollController: controller.listAnimatedViewScrollController,
                        gridAnimatedViewScrollController: controller.gridAnimatedViewScrollController,
                        listBuilder: controller.listBuilder,
                        gridBuilder: controller.gridBuilder,
                        listDecorationBuilder: controller.listDecorationBuilder,
                        gridDecorationBuilder: controller.gridDecorationBuilder,
                        detailBuilder: controller.detailBuilder,
                        onRefresh: context.isTouchSupported && controller.isReady && !controller.noRefresh
                            ? () => controller.refresh(context)
                            : null,
                        onMore: context.isTouchSupported && controller.isReady && !controller.noMore
                            ? () => controller.loadMore(context)
                            : null,
                        headerBuilder: () => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: responsive.FoldPanel(
                            builder: (isColumn) => [
                              if (controller.caption != null)
                                Padding(
                                    padding: isColumn ? const EdgeInsets.only(bottom: 10) : EdgeInsets.zero,
                                    child: Text(controller.caption!,
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
                        footerBuilder: controller.hasNextPage || controller.hasPreviousPage
                            ? () => Column(children: [
                                  if (!controller.isListView) const Divider(),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 10),
                                    child: LayoutBuilder(
                                        builder: (BuildContext context, BoxConstraints constraints) => Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                if (controller.hasPreviousPage)
                                                  TextButton.icon(
                                                    icon: Icon(Icons.chevron_left, color: linkColor),
                                                    label: constraints.maxWidth < 300
                                                        ? const SizedBox()
                                                        : Text(localizations.previousPageTooltip,
                                                            style: TextStyle(color: linkColor)),
                                                    onPressed: () => controller.onPreviousPage(context),
                                                  ),
                                                if (controller.hasNextPage)
                                                  TextButton.icon(
                                                    icon: constraints.maxWidth < 300
                                                        ? const SizedBox()
                                                        : Text(localizations.nextPageTooltip,
                                                            style: TextStyle(color: linkColor)),
                                                    label: Icon(Icons.chevron_right, color: linkColor),
                                                    onPressed: () => controller.onNextPage(context),
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
                                onPressed: controller.isReady ? () async => await controller.refresh(context) : null,
                              ),
                              Expanded(
                                child: responsive.Toolbar(
                                  items: [
                                    responsive.ToolButton(
                                      label: context.i18n.notesViewAsListLabel,
                                      icon: Icons.view_headline,
                                      onPressed: controller.isReady ? controller.onListView : null,
                                      active: controller.isListView,
                                    ),
                                    responsive.ToolButton(
                                      label: context.i18n.notesViewAsGridLabel,
                                      icon: Icons.grid_view,
                                      onPressed: controller.isReady ? controller.onGridView : null,
                                      active: !controller.isListView,
                                      space: 10,
                                    ),
                                    responsive.ToolButton(
                                      label: context.i18n.notesSelectButtonLabel,
                                      icon: Icons.check_circle_outline,
                                      onPressed: controller.isNotEmpty ? controller.onToggleCheckMode : null,
                                    ),
                                    responsive.ToolSpacer(),
                                    if (controller.deleteLabel != null)
                                      responsive.ToolButton(
                                        label: controller.deleteLabel!,
                                        icon: controller.deleteIcon ?? Icons.delete,
                                        onPressed: controller.isNotEmpty ? () => controller.onDelete(context) : null,
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
                                onPressed: () => controller.onAdd(context),
                              ),
                              if (tools != null) ...tools!,
                              responsive.ToolSpacer(),
                              ..._buildPaginator(context, controller, pageInfoText),
                            ],
                          );
                        },
                        touchBottomBarBuilder: () {
                          final buttonStyle = TextStyle(
                            fontSize: 15,
                            color: controller.isReady ? Colors.blue.shade700 : Colors.grey,
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
                                style: controller.isCheckMode
                                    ? ButtonStyle(
                                        backgroundColor: MaterialStateProperty.all(
                                          context.themeColor(light: Colors.grey.shade300, dark: Colors.grey.shade900),
                                        ),
                                      )
                                    : null,
                                onPressed: controller.isReady ? controller.onToggleCheckMode : null,
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
                                onPressed: controller.isReady ? () => controller.onAdd(context) : null,
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
                                  ..._buildPaginator(context, controller, pageInfoText),
                                ],
                              ));
                        },
                        selectionBarBuilder: () {
                          return CheckableHeader(
                            selectedItemCount: controller.dataView!.selectedRows.length,
                            isAllSelected:
                                controller.dataView!.selectedRows.length == controller.dataView!.displayRows.length,
                            onSelectAll: () => controller.onItemChecked(context, controller.dataView!.displayRows),
                            onUnselectAll: () => controller.onItemChecked(context, []),
                            onCancel: () => controller.onToggleCheckMode(),
                            actions: [
                              if (controller.deleteLabel != null)
                                TextButton.icon(
                                  style: TextButton.styleFrom(
                                    primary: Colors.grey.shade900,
                                  ),
                                  label: Text(controller.deleteLabel!),
                                  icon: Icon(controller.deleteIcon ?? Icons.delete),
                                  onPressed: controller.dataView!.selectedRows.isNotEmpty
                                      ? () => controller.onDelete(context)
                                      : null,
                                ),
                            ],
                          );
                        },
                        newItem: controller.newItem,
                        isCheckMode: controller.isCheckMode,
                        isListView: controller.isListView,
                        onItemChecked: (selected) => controller.onItemChecked(context, selected),
                        onItemSelected: (selected) => controller.onSelectItems(context, selected),
                        onItemTapped: (selected) => controller.onItemTapped(context, selected),
                        deleteLabel: controller.deleteLabel,
                        deleteIcon: controller.deleteIcon,
                      )));
            }));
  }
}
