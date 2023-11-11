import 'package:flutter/material.dart';
import 'package:libcli/i18n/i18n.dart' as i18n;
import 'package:libcli/net/net.dart' as net;
import 'data_view.dart';

/// ContinuousDataView is view support continuous display
class ContinuousDataView<T extends net.Object> extends DataView<T> {
  ContinuousDataView(
    super.dataset, {
    required super.loader,
  });

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
