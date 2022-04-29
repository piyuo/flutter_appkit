import 'package:flutter/material.dart';
import 'package:libcli/i18n/i18n.dart' as i18n;
import 'package:libcli/pb/pb.dart' as pb;
import 'memory.dart';
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

  /// onRefresh reset memory on dataset mode, but not on table mode, return true if reset memory
  @override
  Future<bool> onRefresh(BuildContext context, List<T> downloadRows) async {
    final isReset = await super.onRefresh(context, downloadRows);
    await fill();
    return isReset;
  }

  /// setRowsPerPage set rows per page and change page index to 0
  /// ```dart
  /// await setRowsPerPage(context, 20);
  /// ```
  @override
  Future<void> setRowsPerPage(BuildContext context, int value) async {}

  /// fill display rows
  /// ```dart
  /// await ds.fill();
  /// ```
  @override
  Future<void> fill() async {
    displayRows.clear();
    displayRows.addAll(memory.all);
  }

  /// pageInfo return text page info like '1 - 10 of many'
  /// ```dart
  /// expect(ds.pageInfo(testing.Context()), '10 rows');
  /// ```
  @override
  String pageInfo(BuildContext context) {
    final info = '1 - $length ';
    if (noMore) {
      return info + context.i18n.pagingCount.replaceAll('%1', length.toString());
    }
    return info + context.i18n.pagingMany;
  }
}
