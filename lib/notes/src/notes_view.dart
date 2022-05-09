import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:libcli/pb/pb.dart' as pb;
import 'package:libcli/delta/delta.dart' as delta;
import 'package:libcli/responsive/responsive.dart' as responsive;
import 'notes_controller.dart';
import 'selectable.dart';
import 'master_detail_view.dart';
import 'tag_split_view.dart';
import 'tag_view.dart';

class NotesView<T extends pb.Object> extends StatelessWidget {
  const NotesView({
    required this.controller,
    required this.listBuilder,
    required this.gridBuilder,
    required this.detailBuilder,
    this.caption,
    this.deleteLabel,
    this.deleteIcon,
    Key? key,
  }) : super(key: key);

  /// listBuilder is the builder for list view
  final ItemBuilder<T> listBuilder;

  /// gridBuilder is the builder for grid view
  final ItemBuilder<T> gridBuilder;

  /// detailBuilder is the builder for detail view
  final Widget Function(T) detailBuilder;

  /// controller is the [NotesController]
  final NotesController<T> controller;

  /// caption on top of search box
  final String? caption;

  /// deleteLabel is the label for delete button
  final String? deleteLabel;

  /// deleteIcon is the icon for delete button
  final IconData? deleteIcon;

  @override
  Widget build(BuildContext context) {
    final MaterialLocalizations localizations = MaterialLocalizations.of(context);
    final linkColor = context.themeColor(light: Colors.blue.shade400, dark: Colors.blue.shade500);
    return LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
      final searchBox = delta.SearchBox(
        prefixIcon: controller.tags.isEmpty || responsive.isBigScreen(constraints.maxWidth)
            ? null
            : IconButton(
                icon: const Icon(Icons.menu, color: Colors.blue),
                onPressed: () => showTagView<String>(
                  context,
                  onTagSelected: (value) => controller.setSelectedTag(value),
                  tags: controller.tags,
                ),
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
                isReadyToShow: controller.isReadyToShow,
                items: controller.dataset.displayRows,
                selectedItems: controller.dataset.selectedRows,
                listBuilder: listBuilder,
                gridBuilder: gridBuilder,
                detailBuilder: detailBuilder,
                supportRefresh: context.isTouchSupported && !controller.noRefresh,
                supportLoadMore: context.isTouchSupported && !controller.noMore,
                headerBuilder: () => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: responsive.FoldPanel(
                    builder: (isColumn) => [
                      if (caption != null)
                        Padding(
                            padding: isColumn ? const EdgeInsets.only(bottom: 10) : EdgeInsets.zero,
                            child: Text(caption!,
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
                                            onPressed: () =>
                                                controller.onBarAction(context, MasterDetailViewAction.previousPage),
                                          ),
                                        if (controller.hasNextPage)
                                          TextButton.icon(
                                            icon: constraints.maxWidth < 300
                                                ? const SizedBox()
                                                : Text(localizations.nextPageTooltip,
                                                    style: TextStyle(color: linkColor)),
                                            label: Icon(Icons.chevron_right, color: linkColor),
                                            onPressed: () =>
                                                controller.onBarAction(context, MasterDetailViewAction.nextPage),
                                          ),
                                      ],
                                    )),
                          ),
                        ])
                    : null,
                newItem: controller.newItem,
                isCheckMode: controller.isCheckMode,
                isListView: controller.isListView,
                information: controller.dataset.pageInfo(context),
                hasNextPage: controller.hasNextPage,
                hasPrevPage: controller.hasPreviousPage,
                onItemChecked: (selected) => controller.onItemChecked(context, selected),
                onItemSelected: (selected) => controller.onItemSelected(context, selected),
                onItemTapped: (selected) => controller.onItemTapped(context, selected),
                onBarAction: (MasterDetailViewAction action, {ItemBuilder<T>? builder}) async =>
                    await controller.onBarAction(context, action, builder: builder),
                deleteLabel: deleteLabel,
                deleteIcon: deleteIcon,
              )));
    });
  }
}
