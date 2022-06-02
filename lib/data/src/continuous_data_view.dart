import 'package:flutter/material.dart';
import 'package:libcli/i18n/i18n.dart' as i18n;
import 'package:libcli/pb/pb.dart' as pb;
import 'dataset.dart';
import 'data_view.dart';

/// ContinuousDataView is view support continuous display
class ContinuousDataView<T extends pb.Object> extends DataView<T> {
  ContinuousDataView(
    Dataset<T> _dataset, {
    required DataViewLoader<T> loader,
    required pb.Builder<T> dataBuilder,
  }) : super(
          _dataset,
          loader: loader,
          dataBuilder: dataBuilder,
        );

  /// onRefresh called when refresh
  @override
  Future<bool> onRefresh(BuildContext context, List<T> downloadRows) async {
    final isReset = await super.onRefresh(context, downloadRows);
    await fill();
    return isReset;
  }

  /// fill display rows
  /// ```dart
  /// await ds.fill();
  /// ```
  @override
  Future<void> fill() async {
    displayRows.clear();
    displayRows.addAll(await dataset.all);
  }

  /// pageInfo return text page info like '1 - 10 of many'
  /// ```dart
  /// expect(ds.pageInfo(testing.Context()), '10 rows');
  /// ```
  @override
  String pageInfo(BuildContext context) {
    if (length == 0) {
      // no data to display
      return '';
    }
    final info = '1 - $length ';
    if (noMore) {
      return info + context.i18n.pagingCount.replaceAll('%1', length.toString());
    }
    return info + context.i18n.pagingMany;
  }
}
