import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:libcli/pb/pb.dart' as pb;
import 'package:libcli/db/db.dart' as db;
import 'package:libcli/delta/delta.dart' as delta;
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
    required this.onBarAction,
    this.labelBuilder,
    this.onShowDetail,
    Key? key,
  }) : super(key: key);

  /// listBuilder is the builder for list view
  final ItemBuilder<T> listBuilder;

  /// gridBuilder is the builder for grid view
  final ItemBuilder<T> gridBuilder;

  /// labelBuilder is the builder for label in grid view
  final ItemBuilder<T>? labelBuilder;

  /// detailBuilder is the builder for detail view
  final Widget Function(T) detailBuilder;

  /// controller is the [NotesController]
  final NotesController<T> controller;

  /// onShowDetail is the callback for navigate to detail view
  final void Function(T)? onShowDetail;

  /// onBarAction is the callback for bar action
  final Future<void> Function(MasterDetailViewAction) onBarAction;

  @override
  Widget build(BuildContext context) {
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
            tagView: TagView<String>(
              onTagSelected: controller.tagSelected,
              tags: controller.tags,
            ),
            child: MasterDetailView<T>(
              items: controller.dataset.displayRows,
              selectedItems: controller.dataset.selectedRows,
              listBuilder: listBuilder,
              gridBuilder: gridBuilder,
              labelBuilder: labelBuilder,
              detailBuilder: detailBuilder,
              headerBuilder: () => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: delta.SearchBox(
                  prefixIcon: IconButton(
                    icon: const Icon(Icons.menu),
                    onPressed: () => showTagView<String>(
                      context,
                      onTagSelected: (value) => debugPrint('$value selected'),
                      tags: controller.tags,
                    ),
                  ),
                  controller: controller.searchController,
                ),
              ),
              onShowDetail: onShowDetail,
              checkMode: controller.checkMode,
              isListView: controller.listView,
              information: controller.dataset.information(context),
              hasNextPage:
                  controller.dataset is db.PagedDataset ? (controller.dataset as db.PagedDataset).hasNextPage : false,
              hasPrevPage:
                  controller.dataset is db.PagedDataset ? (controller.dataset as db.PagedDataset).hasPrevPage : false,
              onItemChecked: controller.selectRows,
              onItemSelected: controller.selectRows,
              onBarAction: (action) => controller.barAction(context, action),
            )));
  }
}
