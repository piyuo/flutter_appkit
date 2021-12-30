import 'package:flutter/material.dart';
import 'package:libcli/delta/delta.dart' as delta;
import 'data_source.dart';
import 'types.dart';

class PageList<T> extends StatelessWidget {
  const PageList({
    required this.dataSource,
    required this.cardBuilder,
    Key? key,
  }) : super(key: key);

  /// cardBuilder build card layout used in mobile device
  final CardBuilder<T> cardBuilder;

  /// dataSOurce for PagedList
  final DataSource dataSource;

  @override
  Widget build(BuildContext context) {
    return delta.PullRefresh(
      onPullRefresh: dataSource.supportRefresh
          ? (BuildContext context) async {
              await dataSource.refreshNewRow(context);
            }
          : null,
      onLoadMore: dataSource.hasNextPage || dataSource.isBusy
          ? (BuildContext context) async {
              await dataSource.nextPage(context);
            }
          : null,
      itemCount: (BuildContext context) {
        return dataSource.length;
      },
      itemBuilder: (BuildContext context, int index) {
        final row = dataSource.row(index);
        return cardBuilder(context, row, index);
      },
    );
  }
}
