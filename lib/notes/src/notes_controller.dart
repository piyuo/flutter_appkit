import 'package:flutter/material.dart';
import 'package:libcli/delta/delta.dart' as delta;
import 'package:libcli/db/db.dart' as db;
import 'package:libcli/pb/pb.dart' as pb;
import 'package:libcli/animations/animations.dart' as animations;
import 'tag.dart';
import 'master_detail_view.dart';

class NotesController<T extends pb.Object> with ChangeNotifier {
  NotesController(
    db.Memory<T> _memory, {
    required BuildContext context,
    required db.DatasetLoader<T> loader,
    required pb.Builder<T> dataBuilder,
    this.tags = const [],
  }) {
    dataset = context.isPreferMouse
        ? db.PagedDataset<T>(
            _memory,
            dataBuilder: dataBuilder,
            loader: loader,
          )
        : db.ContinuousDataset<T>(
            _memory,
            dataBuilder: dataBuilder,
            loader: loader,
          );
    start(context);
  }

  /// start dataset
  Future<void> start(BuildContext context) async {
    await dataset.start(context);
    animatedViewController.itemCount = dataset.displayRows.length;
    setDefaultSelected();
    notifyListeners();
  }

  /// refreshButtonController is refresh button controller
  final refreshButtonController = delta.RefreshButtonController();

  /// animatedViewController control view animation
  final animatedViewController = animations.AnimatedViewProvider(0);

  /// searchController is search box controller
  final searchController = TextEditingController();

  /// table is data to be display
  late db.Dataset<T> dataset;

  /// tags is a list of tags to display.
  List<Tag<String>> tags;

  /// listView is true if is in list view mode
  bool listView = true;

  /// checkMode is true if is in check mode
  bool checkMode = false;

  @override
  void dispose() {
    refreshButtonController.dispose();
    animatedViewController.dispose();
    super.dispose();
  }

  /// setDefaultSelected will select first row if no row selected
  void setDefaultSelected() {
    if (dataset.selectedRows.isEmpty && dataset.displayRows.isNotEmpty) {
      dataset.selectRows([dataset.displayRows.first]);
    }
  }

  /// selectRows call when user select rows
  void selectRows(List<T> selectedItems) {
    dataset.selectRows(selectedItems);
    notifyListeners();
  }

  /// barAction handle bar action
  Future<void> barAction(BuildContext context, MasterDetailViewAction action) async {
    switch (action) {
      case MasterDetailViewAction.refresh:
        final originLength = dataset.length;
        var firstPage = true;
        if (dataset is db.PagedDataset) {
          firstPage = (dataset as db.PagedDataset).isFirstPage;
        }
        final isReset = await dataset.refresh(context);
        final diff = dataset.length - originLength;
        setDefaultSelected();
        if (isReset || (diff > 0 && !firstPage)) {
          animatedViewController.refreshPageAnimation();
          animatedViewController.itemCount = dataset.displayRows.length;
          return;
        }
        if (diff > 0) {
          if (dataset.isDisplayRowsFullPage) {
            animatedViewController.itemCount = dataset.rowsPerPage - diff;
          }
          for (int i = 0; i < diff; i++) {
            animatedViewController.insertAnimation();
          }
        }
        break;
      case MasterDetailViewAction.more:
        await dataset.more(context, dataset.rowsPerPage);
        animatedViewController.itemCount = dataset.displayRows.length;
        break;
      case MasterDetailViewAction.previousPage:
        if (dataset is db.PagedDataset) {
          await (dataset as db.PagedDataset).prevPage(context);
          animatedViewController.itemCount = dataset.displayRows.length;
          animatedViewController.prevPageAnimation();
        }
        break;
      case MasterDetailViewAction.nextPage:
        if (dataset is db.PagedDataset) {
          await (dataset as db.PagedDataset).nextPage(context);
          animatedViewController.itemCount = dataset.displayRows.length;
          animatedViewController.nextPageAnimation();
        }
        break;
      case MasterDetailViewAction.rows10:
        await dataset.setRowsPerPage(context, 10);
        animatedViewController.itemCount = dataset.displayRows.length;
        break;
      case MasterDetailViewAction.rows20:
        await dataset.setRowsPerPage(context, 20);
        animatedViewController.itemCount = dataset.displayRows.length;
        break;
      case MasterDetailViewAction.rows50:
        await dataset.setRowsPerPage(context, 50);
        animatedViewController.itemCount = dataset.displayRows.length;
        break;
      case MasterDetailViewAction.listView:
        listView = true;
        break;
      case MasterDetailViewAction.gridView:
        listView = false;
        break;
      case MasterDetailViewAction.toggleCheckMode:
        checkMode = !checkMode;
        if (checkMode) {
          dataset.selectRows([]);
        } else {
          if (dataset.displayRows.isNotEmpty) {
            dataset.selectRows([dataset.displayRows.first]);
          }
        }
        break;
      case MasterDetailViewAction.add:
        break;
      case MasterDetailViewAction.delete:
        break;
      case MasterDetailViewAction.archive:
        break;
    }
    notifyListeners();
    debugPrint('$action');
  }

  /// tagSelected called when a tag is selected
  tagSelected(String value) {
    debugPrint('$value selected');
  }
}
