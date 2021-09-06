import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

typedef Future<bool> PullRefreshLoader(BuildContext context);

class PullRefreshProvider with ChangeNotifier {
  PullRefreshProvider();

  void refresh() {
    notifyListeners();
  }
}

class PullRefresh extends StatelessWidget {
  PullRefresh({
    this.scrollDirection = Axis.vertical,
    required this.onPullRefresh,
    required this.onLoadMore,
    required this.itemBuilder,
    required this.itemCount,
  });

  final Axis scrollDirection;

  /// onPullRefresh mean pull to refresh, return true if count change
  final PullRefreshLoader onPullRefresh;

  /// onLoadMore mean scroll down to load more, return true if count change
  final PullRefreshLoader onLoadMore;

  /// itemBuilder build widget
  final Widget Function(BuildContext context, int index) itemBuilder;

  /// itemCount return total item count
  final int Function(BuildContext context) itemCount;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<PullRefreshProvider>(
        create: (context) => PullRefreshProvider(),
        child: Consumer<PullRefreshProvider>(builder: (context, provide, child) {
          return EasyRefresh.custom(
            scrollDirection: Axis.horizontal,
            header: MaterialHeader(),
            footer: MaterialFooter(),
            onRefresh: () async {
              if (await onPullRefresh(context)) {
                provide.refresh();
              }
            },
            onLoad: () async {
              if (await onLoadMore(context)) {
                provide.refresh();
              }
            },
            slivers: <Widget>[
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  itemBuilder,
                  childCount: itemCount(context),
                ),
              ),
            ],
          );
        }));
  }
}
