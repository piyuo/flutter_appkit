import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'pull_refresh.dart';
import 'load_more.dart';

/// kHeaderHeight is height of header that show refresh indicator
const kHeaderHeight = 60.0;

/// kFooterHeight is height of footer that show load more indicator
const kFooterHeight = 40.0;

/// LoadingCallback return true if no more data
typedef LoadingCallback = Future<dynamic> Function();

/// LoadingStatus is status of load more
enum LoadingStatus {
  idle,
  error,
  loading,
  completed,
}

class RefreshMoreProvider with ChangeNotifier {
  LoadingStatus moreStatus = LoadingStatus.idle;

  /// prevScrollDirection is previous scroll direction for pull to refresh
  ScrollDirection prevScrollDirection = ScrollDirection.idle;

  /// refreshController is controller for pull to refresh
  IndicatorController? refreshController = IndicatorController();

  @override
  void dispose() {
    refreshController?.dispose();
    refreshController = null;
    super.dispose();
  }

  bool get isRefreshing {
    return refreshController == null ? false : refreshController!.isLoading;
  }

  void setMoreStatus(LoadingStatus newStatus) {
    refreshController?.enableRefresh();
    moreStatus = newStatus;
    if (moreStatus == LoadingStatus.loading) {
      refreshController?.disableRefresh();
    }
    notifyListeners();
  }
}

/// RefreshMore support pull down refresh and pull up load more
class RefreshMore extends StatelessWidget {
  const RefreshMore({
    required this.child,
    required this.refreshMoreProvider,
    this.onRefresh,
    this.onMore,
    super.key,
  });

  /// onRefresh is the callback function when user refresh the list
  final LoadingCallback? onRefresh;

  /// onMore is the callback function when user load more
  final LoadingCallback? onMore;

  /// refreshMoreProvider control status of [RefreshMore]
  final RefreshMoreProvider refreshMoreProvider;

  /// child is the custom scroll view
  final CustomScrollView child;

  @override
  Widget build(BuildContext context) {
    return PullRefresh(
        refreshMoreProvider: refreshMoreProvider,
        onRefresh: onRefresh,
        child: LoadMore(
          refreshMoreProvider: refreshMoreProvider,
          onMore: onMore,
          child: child,
        ));
  }
}
