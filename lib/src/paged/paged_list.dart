import 'package:flutter/material.dart';
import 'package:libcli/delta/delta.dart' as delta;
import 'paged_data_source.dart';
import 'types.dart';

class PagedList<T> extends StatelessWidget {
  const PagedList({
    required this.dataSource,
    required this.cardBuilder,
    Key? key,
  }) : super(key: key);

  /// cardBuilder build card layout used in mobile device
  final CardBuilder<T> cardBuilder;

  /// dataSOurce for PagedList
  final PagedDataSource dataSource;

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
