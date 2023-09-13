// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:libcli/net/net.dart' as net;
import 'data_view.dart';
import 'continuous_data_view.dart';
import 'dataset.dart';

class ContinuousFullView<T extends net.Object> extends ContinuousDataView<T> {
  ContinuousFullView(
    Dataset<T> dataset, {
    required String id,
    required DataViewLoader<T> loader,
  }) : super(dataset, loader: loader) {
    dataset.internalNoMore = true;
  }

  /// onRefresh called when refresh
  @override
  Future<bool> onRefresh(List<T> downloadRows) async {
    await insert(downloadRows);
    return false; // table do not reset dataset
  }

  /// more seeking more data from data loader, return true if has more data
  /// ```dart
  /// await ds.more(testing.Context(), 2);
  /// ```
  @override
  Future<bool> more(int limit) async {
    return false;
  }
}
