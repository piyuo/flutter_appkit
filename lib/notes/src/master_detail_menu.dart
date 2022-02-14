import 'package:flutter/material.dart';
import 'package:libcli/responsive/responsive.dart' as responsive;
import 'master_detail_view.dart';
import 'view_controller.dart';

Future<MasterDetailViewAction?> showMasterDetailMenu(
  BuildContext context, {
  required ViewController viewController,
  List<responsive.ToolItem<MasterDetailViewAction>>? items,
}) async {
  final result = await responsive.showToolMenu<MasterDetailViewAction>(
    context,
    items: [
      responsive.ToolButton<MasterDetailViewAction>(
        label: 'Refresh',
        icon: Icons.refresh,
        value: MasterDetailViewAction.refresh,
      ),
      responsive.ToolButton<MasterDetailViewAction>(
        label: viewController.isListView ? 'View as Grid' : 'View as List',
        icon: viewController.isListView ? Icons.grid_view : Icons.view_headline,
        value: viewController.isListView ? MasterDetailViewAction.gridView : MasterDetailViewAction.listView,
      ),
      responsive.ToolSpacer(),
      responsive.ToolButton<MasterDetailViewAction>(
        label: 'Delete',
        icon: Icons.delete_forever,
        value: MasterDetailViewAction.delete,
      ),

      //...items,
    ],
  );

  if (result == MasterDetailViewAction.listView) {
    viewController.isListView = true;
  } else if (result == MasterDetailViewAction.gridView) {
    viewController.isListView = false;
  }

  return result;
}
