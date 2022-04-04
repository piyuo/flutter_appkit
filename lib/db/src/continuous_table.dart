// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:flutter/material.dart';
import 'package:libcli/pb/pb.dart' as pb;
import 'dataset.dart';
import 'continuous_dataset.dart';
import 'memory.dart';

class ContinuousTable<T extends pb.Object> extends ContinuousDataset<T> {
  ContinuousTable(
    Memory<T> _memory, {
    BuildContext? context,
    required String id,
    required pb.Builder<T> dataBuilder,
    required DatasetLoader<T> loader,
  }) : super(
          _memory,
          context: context,
          dataBuilder: dataBuilder,
          loader: loader,
        ) {
    _memory.noMoreData = true;
  }

  /// onRefresh reset memory on dataset mode, but not on table mode
  @override
  Future<void> onRefresh(BuildContext context, List<T> downloadRows) async {
    await memory.insert(downloadRows);
    await fill();
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
