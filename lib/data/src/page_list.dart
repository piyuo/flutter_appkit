import 'package:flutter/material.dart';
import 'package:libcli/delta/delta.dart' as delta;
import 'data.dart';
import 'data_source.dart';
import 'package:libcli/pb/pb.dart' as pb;
import 'package:libcli/i18n/i18n.dart' as i18n;

class PageList<T extends pb.Object> extends StatelessWidget {
  const PageList({
    required this.dataSource,
    required this.cardBuilder,
    Key? key,
  }) : super(key: key);

  /// cardBuilder build card layout used in mobile device
  final CardBuilder<T> cardBuilder;

  /// dataSOurce for PagedList
  final DataSource<T> dataSource;

  Widget _buildNoData(BuildContext context) {
    return SizedBox(
      height: 250,
      width: 250,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.wb_cloudy_outlined,
            size: 54,
            color: Colors.grey,
          ),
          Text(context.i18n.noDataLabel,
              style: const TextStyle(
                color: Colors.grey,
              )),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return delta.RefreshMoreView(
      /*onPullRefresh: dataSource.noNeedRefresh || dataSource.isLoading
          ? null
          : (BuildContext context) async {
              await dataSource.refreshData(context);
            },
      onLoadMore: dataSource.noMoreData || dataSource.isLoading
          ? null
          : (BuildContext context) async {
              await dataSource.nextPage(context);
            },*/
      itemCount: dataSource.isEmpty ? 1 : dataSource.rows.length,
      itemBuilder: (BuildContext context, int index) {
        if (dataSource.isEmpty) {
          return _buildNoData(context);
        }

        final row = dataSource.rows[index];
        return cardBuilder(context, row, index);
      },
    );
  }
}
