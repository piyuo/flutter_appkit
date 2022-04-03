import 'package:flutter/material.dart';
import 'package:libcli/i18n/i18n.dart' as i18n;
import 'package:libcli/pb/pb.dart' as pb;
import 'memory.dart';
import 'db.dart';
import 'dataset.dart';

class ContinuousDataset<T extends pb.Object> extends Dataset<T> {
  ContinuousDataset(
    Memory<T> _memory, {
    BuildContext? context,
    required DatasetLoader<T> loader,
    required pb.Builder<T> dataBuilder,
    VoidCallback? onReady,
  }) : super(
          _memory,
          context: context,
          loader: loader,
          dataBuilder: dataBuilder,
          onReady: onReady,
        );

  /// fill display rows
  /// ```dart
  /// await ds.fill();
  /// ```
  @override
  Future<void> fill() async {
    displayRows.clear();
    final range = await memory.allRows;
    if (range == null) {
      notifyState(DataState.dataMissing);
      return;
    }
    displayRows.addAll(range);
  }

  /// pagingInfo return text page info like '1-10 of many'
  /// ```dart
  /// expect(ds.pagingInfo(testing.Context()), '10 rows');
  /// ```
  @override
  String pagingInfo(BuildContext context) {
    return '${memory.length} ' + context.i18n.pagingRows;
  }

  /// gotoPage goto specified page, load more page if needed
  /// ```dart
  /// await gotoPage(context, 2);
  /// ```
  @override
  Future<void> gotoPage(BuildContext context, int index) async {
    await fill();
    notifyListeners();
  }
}
