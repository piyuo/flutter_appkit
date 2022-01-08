import 'package:flutter/material.dart';
import 'package:libcli/delta/delta.dart' as delta;
import 'data.dart';
import 'data_source.dart';
import 'package:libcli/pb/pb.dart' as pb;
import 'package:libcli/i18n/i18n.dart' as i18n;

class PullList<T extends pb.Object> extends StatelessWidget {
  const PullList({
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
    return delta.PullRefresh(
      onPullRefresh: dataSource.noNeedRefresh || dataSource.isBusy
          ? null
          : (BuildContext context) async {
              await dataSource.refresh(context);
            },
      onLoadMore: dataSource.noMoreData || dataSource.isBusy
          ? null
          : (BuildContext context) async {
              await dataSource.nextPage(context);
            },
      itemCount: (BuildContext context) {
        return dataSource.isEmpty ? 1 : dataSource.allRows.length;
      },
      itemBuilder: (BuildContext context, int index) {
        if (dataSource.isEmpty) {
          return _buildNoData(context);
        }

        final row = dataSource.allRows[index];
        return cardBuilder(context, row, index);
      },
    );
  }
}
