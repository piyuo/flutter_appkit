import 'package:flutter/material.dart';
import 'package:libcli/data/data.dart' as data;
import 'package:libcli/delta/delta.dart' as delta;
import 'package:libcli/pb/pb.dart' as pb;
import 'refresh_more.dart';
import 'pull_refresh.dart';
import 'load_more.dart';

/// Dataview provide a view to show data
class Dataview<T extends pb.Object> extends StatelessWidget {
  const Dataview({
    required this.dataProvider,
    required this.sliversBuilder,
    required this.refreshMoreProvider,
    super.key,
  });

  /// dataProvider provider all data need in dataview
  final data.DataProvider<T> dataProvider;

  /// sliversBuilder build slivers to show data
  final List<Widget> Function(List<T>) sliversBuilder;

  // refreshMoreProvider control status of [RefreshMore]
  final RefreshMoreProvider refreshMoreProvider;

  @override
  Widget build(BuildContext context) {
    return PullRefresh(
      refreshMoreProvider: refreshMoreProvider,
      onRefresh: () async => await dataProvider.refresh(),
      child: dataProvider.displayRows.isEmpty
          ? const delta.NoDataDisplay()
          : LoadMore(
              refreshMoreProvider: refreshMoreProvider,
              onMore: dataProvider.hasMore ? () async => await dataProvider.more() : null,
              child: CustomScrollView(
                slivers: sliversBuilder(dataProvider.displayRows),
              ),
            ),
    );
  }
}
