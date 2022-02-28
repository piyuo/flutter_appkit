import 'package:flutter/material.dart';
import 'grid_list.dart';
import 'package:libcli/db/db.dart' as db;
import 'package:libcli/pb/pb.dart' as pb;
import 'master_detail_view.dart';

class DataExplorer<T extends pb.Object> extends StatelessWidget {
  const DataExplorer({
    required this.dataset,
    required this.listBuilder,
    required this.gridBuilder,
    required this.detailBuilder,
    required this.onAction,
    this.labelBuilder,
    this.onNavigateToDetail,
    Key? key,
  }) : super(key: key);

  final db.Dataset<T> dataset;

  final ItemBuilder<T> listBuilder;

  final ItemBuilder<T> gridBuilder;

  final ItemBuilder<T>? labelBuilder;

  final Widget Function(T) detailBuilder;

  final void Function(T)? onNavigateToDetail;

  final Future<void> Function(MasterDetailViewAction) onAction;

  @override
  Widget build(BuildContext context) {
    return MasterDetailView<T>(
      items: dataset.displayRows,
      selectedItems: dataset.selectedRows,
      listBuilder: listBuilder,
      gridBuilder: gridBuilder,
      labelBuilder: labelBuilder,
      detailBuilder: detailBuilder,
      onItemSelected: (List<T> selectedItems) {
        dataset.selectRows(selectedItems);
      },
      onNavigateToDetail: onNavigateToDetail,
      onBarAction: onAction,
    );
  }
}
