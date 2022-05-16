// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:flutter/material.dart';
import 'package:libcli/pb/pb.dart' as pb;
import 'data_view.dart';
import 'continuous_data_view.dart';
import 'dataset.dart';

class ContinuousFullView<T extends pb.Object> extends ContinuousDataView<T> {
  ContinuousFullView(
    Dataset<T> _dataset, {
    BuildContext? context,
    required String id,
    required pb.Builder<T> dataBuilder,
    required DataViewLoader<T> loader,
    VoidCallback? onReady,
  }) : super(
          _dataset,
          context: context,
          dataBuilder: dataBuilder,
          loader: loader,
          onReady: onReady,
        ) {
    _dataset.internalNoMore = true;
  }

  /// onRefresh called when refresh
  @override
  Future<bool> onRefresh(BuildContext context, List<T> downloadRows) async {
    await dataset.insert(context, downloadRows);
    fill();
    return false; // table do not reset dataset
  }

  /// more seeking more data from data loader, return true if has more data
  /// ```dart
  /// await ds.more(testing.Context(), 2);
  /// ```
  @override
  Future<bool> more(BuildContext context, int limit) async {
    return false;
  }
}
